import 'dart:convert';

import 'package:CommuneIsm/models/member.dart';
import 'package:CommuneIsm/providers/auth.dart';

import '../models/address.dart';

import '../helper/graph_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'commune.dart';
import 'user.dart';

class AppState with ChangeNotifier {
  User user;
  Commune commune;
  Auth auth;

  AppState({
    this.user,
    this.commune,
    this.auth,
  });

  bool get isLoaded {
    return (user != null && commune != null);
  }

  String get comID {
    return commune.uid;
  }

  List<Member> get members {
    return this.commune.members;
  }

  Future<void> login(Map<String, String> input) async {
    auth = Auth();
    final body = '''{
      "mail": \"${input['mail']}\",
      "pw": \"${input['pw']}\"
    }''';

    try {
      final res = await GraphHelper.authPost(body);

      auth.token = "${res['token_type']} ${res['access_token']}";
      auth.expiryDate = DateTime.parse(res['expiry']);
      user.uid = res['userID'];

      if (auth.token != null && auth.expiryDate.isAfter(DateTime.now())) {
        initApp();
      }
    } catch (err) {
      throw (err);
    }
  }

  Future<void> initApp() async {
//    const comID = '0x20';
//    const userID = '0x22';
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'comID': comID,
        'userID': user.uid,
      });
      prefs.setString('userData', userData);
      return;
    } catch (err) {
      throw (err);
    }
  }

  Future<void> loadApp() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.containsKey('comID') || prefs.containsKey('userID'))) {
      await initApp();
    }
    final prefsData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final comID = prefsData['comID'];
    final userID = prefsData['userID'];

    await fetchUser(userID);
    await fetchCommune(comID);
  }

  Future<void> fetchCommune(String comID) async {
    final body = '''{
        "uid": "$comID"
      }''';

    List<Member> getMembers(List<dynamic> list) {
      List<Member> members = [];
      list.forEach((mem) {
        members.add(Member(
          uid: mem['uid'],
          name: mem['name'],
          created: DateTime.fromMillisecondsSinceEpoch(mem['created'] * 1000),
          birth: DateTime.fromMillisecondsSinceEpoch(mem['birth'] * 1000),
        ));
      });
      return members;
    }

    try {
      var data = await GraphHelper.postSecure(body, "communeGet");
      commune = Commune(
        uid: data['uid'],
        name: data['name'],
        description: data['description'],
        address: Address(
          uid: data['address']['uid'],
          street: data['address']['street'],
          city: data['address']['city'],
          zip: data['address']['zip'],
        ),
        members: getMembers(data['members']),
      );
      notifyListeners();
    } catch (err) {
      commune = null;
      notifyListeners();
      throw (err);
    }
  }

  Future<void> fetchUser(String userUD) async {
    final body = '''{
        "uid": "$userUD"
      }''';

    try {
      var data = await GraphHelper.postSecure(body, "userGet");
      user = User(
        uid: data['uid'],
        name: data['name'],
        birth: DateTime.fromMillisecondsSinceEpoch(data['birth'] * 1000),
      );
      notifyListeners();
    } catch (err) {
      user = null;
      notifyListeners();
      throw (err);
    }
  }
}
