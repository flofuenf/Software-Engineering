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
    print("login");
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

      if (auth.accessToken != null &&
          auth.refreshToken != null &&
          auth.userID != null) {
        print("init App");
        initApp();
        return;
      }
      print("dont init app");
//      if (auth.token != null && auth.expiryDate.isAfter(DateTime.now())) {
//        initApp();
//      }

    } catch (err) {
      throw (err);
    }
  }

  Future<void> initApp() async {
    try{
      print("before fetch User");
      await fetchUser(auth.userID);
      print(user.name);
    }catch(err){
      throw(err);
    }

    if(user.communeID == null){
      //go to Commune Selection / Invitation
      return;
    }

    try{
      await fetchCommune(user.communeID);
      print(comID);
    }catch(err){
      throw(err);
    }
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
      var data = await GraphHelper.postSecure(body, "api/communeGet", auth.accessToken);
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

  Future<void> fetchUser(String userID) async {
    final body = '''{
        "uid": "$userID"
      }''';

    try {
      print("before graph fetch");
      var data = await GraphHelper.postSecure(body, "api/userGet", auth.accessToken);
      print(data);
      user = User(
        uid: data['uid'],
        name: data['name'],
        birth: DateTime.fromMillisecondsSinceEpoch(data['birth'] * 1000),
        communeID: data['commune']
      );
      notifyListeners();
    } catch (err) {
      user = null;
      notifyListeners();
      throw (err);
    }
  }
}
