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
    return (user != null && commune != null && auth.isAuth());
  }

  bool get isAuth {
    return auth.isAuth();
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

  Future<void> initApp() async {
    if (auth == null || !auth.isAuth()) {
      try {
        await autoLogin();
      } catch (err) {
        print(err);
        throw (err);
      }
    }
    if (auth == null || !auth.isAuth()) {
      return;
    }
    if (user == null) {
      try {
        await fetchUser(auth.userID);
      } catch (err) {
        print(err);
        throw (err);
      }
    }

    if (user.communeID == null || user.communeID.length < 1) {
      return;
    }

    try {
      await fetchCommune(user.communeID);
    } catch (err) {
      print(err);
      throw (err);
    }
  }

  Future<void> autoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('authData')) {
        return;
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
      }
      notifyListeners();
    } catch (err) {
      print(err);
      throw (err);
    }
  }

  Future<void> fetchUser(String userID) async {
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
    } catch (err) {
      print(err);
      throw (err);
    }
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
          commune: mem['commune'],
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
      notifyListeners();
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<void> login(Map<String, String> input) async {
    auth = Auth();
    final body = '''{
      "mail": \"${input['mail']}\",
      "pass": \"${input['pw']}\"
    }''';

    try {
      final res = await GraphHelper.authPost(body, "login");
      if (res['success'] == false) {
        throw ("E-Mail oder Passwort falsch");
      }

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
          print(err);
          throw (err);
        }
      }
    } catch (err) {
      print(err);
      throw (err);
    }
  }

  Future<void> join(Map<String, String> input) async {
    final body = '''{
      "uid": \"${input['comID']}\",
      "members": [
          {
            "uid": \"${input['userID']}\"  
          }
       ]
    }''';

    try {
      await GraphHelper.postSecure(body, "api/joinCommune", auth.accessToken);
      user.communeID = input['comID'];
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> register(Map<String, String> input) async {
    final body = '''{
      "mail": \"${input['mail']}\",
      "pass": \"${input['pass']}\",
      "name": \"${input['name']}\",
      "birth": ${int.parse(input['birth']) / 1000}
    }''';

    try {
      final res = await GraphHelper.authPost(body, "register");
      if (res['uid'] == null) {
        throw ("Something went wrong");
      }
    } catch (err) {
      throw (err);
    }
  }

  Future<void> logout() async{
    try{
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('authData');
    }catch(err){
      print(err);
      throw(err);
    }
    this.commune = null;
    this.user = null;
    this.auth = null;
    notifyListeners();
  }

  Future<void> leaveCommune() async{
    final body = '''{
      "uid": \"${commune.uid}\",
      "members": [
          {
            "uid": \"${user.uid}\"  
          }
       ]
    }''';
    try{
      final _ = await GraphHelper.postSecure(body, "api/leaveCommune", auth.accessToken);
      this.commune = null;
      this.user.communeID = null;
      notifyListeners();
    }catch(err){
      print(err);
      throw(err);
    }
  }
}
