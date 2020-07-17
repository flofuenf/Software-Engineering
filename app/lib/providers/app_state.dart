import 'dart:convert';

import 'package:CommuneIsm/models/member.dart';
import 'package:CommuneIsm/providers/auth.dart';
import 'package:CommuneIsm/screens/login/join_screen.dart';

import '../models/address.dart';

import '../helper/graph_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'commune.dart';
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
    return (user != null &&
        commune != null &&
        auth.accessToken != null &&
        auth.atExp.isAfter(DateTime.now()));
  }

  bool get hasCommune {
    return this.user == null || this.user.communeID != "";
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
      "pass": \"${input['pw']}\"
    }''';

    try {
      final res = await GraphHelper.authPost(body);
      auth.accessToken = "Bearer ${res['access_token']}";
      auth.refreshToken = res['refresh_token'];
      auth.userID = "${res['user_id']}";
      auth.atExp = DateTime.fromMillisecondsSinceEpoch(res['atExp'] * 1000);
      auth.rtExp = DateTime.fromMicrosecondsSinceEpoch(res['rtExp'] * 1000);

      if (auth.accessToken != null &&
          auth.refreshToken != null &&
          auth.userID != null) {
        try {
          final prefs = await SharedPreferences.getInstance();
          final authData = json.encode({
            'accessToken': auth.accessToken,
            'refreshToken': auth.refreshToken,
            'userID': auth.userID,
            "atExp": auth.atExp.millisecondsSinceEpoch.toString(),
            "rtExp": auth.rtExp.millisecondsSinceEpoch.toString(),
          });
          prefs.setString('authData', authData);
          notifyListeners();
        } catch (err) {
          throw (err);
        }
      }
    } catch (err) {
      throw (err);
    }
  }

  Future<void> initApp() async {
    try {
      await fetchUser(auth.userID);
    } catch (err) {
      throw (err);
    }

    if (user.communeID == "") {
      print("no Commune for User");
      return;
      //go to Commune Selection / Invitation
    }

    try {
      await fetchCommune(user.communeID);
      print(user.communeID);
    } catch (err) {
      throw (err);
    }
  }

  Future<Auth> loadApp(BuildContext ctx) async {
    print("load App");
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('authData')) {
        print("no authData");
        return null;
      }

      final prefsData =
          json.decode(prefs.getString('authData')) as Map<String, Object>;
      auth = Auth(
        userID: prefsData['userID'],
        accessToken: prefsData['accessToken'],
        refreshToken: prefsData['refreshToken'],
        atExp: DateTime.fromMillisecondsSinceEpoch(
            int.parse(prefsData['atExp']) * 1000),
        rtExp: DateTime.fromMillisecondsSinceEpoch(
            int.parse(prefsData['rtExp']) * 1000),
      );

      if (!auth.atExp.isAfter(DateTime.now())) {
        print("refresh token");
      }
//      auth.rtExp = DateTime.now().subtract(Duration(days: 1));

      if (!auth.rtExp.isAfter(DateTime.now())) {
        print("refresh Refresh");
        return null;
      }
      return auth;
    } catch (err) {
      return null;
    }
  }

  Future<Commune> fetchCommune(String comID) async {
    if (comID == null) {
      return null;
    }
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
      var data = await GraphHelper.postSecure(
          body, "api/communeGet", auth.accessToken);
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
      return commune;
    } catch (err) {
      return null;
    }
  }

  Future<User> fetchUser(String userID) async {
    final body = '''{
        "uid": "$userID"
      }''';

    try {
      var data =
          await GraphHelper.postSecure(body, "api/userGet", auth.accessToken);
      user = User(
          uid: data['uid'],
          name: data['name'],
          birth: DateTime.fromMillisecondsSinceEpoch(data['birth'] * 1000),
          communeID: data['commune']);
      print(data);
      return user;
    } catch (err) {
      return null;
    }
  }
}
