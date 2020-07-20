import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String userID;
  String accessToken;
  String refreshToken;
  DateTime atExp;
  DateTime rtExp;

  Auth({
    this.userID,
    this.accessToken,
    this.refreshToken,
    this.atExp,
    this.rtExp,
  });

  bool isAuth() => this.userID != null && this.atExp.isAfter(DateTime.now()) && rtExp.isAfter(DateTime.now()) && this.accessToken != null && this.refreshToken != null;

  Future<void> authentication() async{
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('authData')) {
        print("no authData");
        return;
      }

      final prefsData =
      json.decode(prefs.getString('authData')) as Map<String, Object>;
        userID = prefsData['userID'];
        accessToken = prefsData['accessToken'];
        refreshToken = prefsData['refreshToken'];
        atExp = DateTime.fromMillisecondsSinceEpoch(
            int.parse(prefsData['atExp']) * 1000);
        rtExp = DateTime.fromMillisecondsSinceEpoch(
            int.parse(prefsData['rtExp']) * 1000);

      if (!atExp.isAfter(DateTime.now())) {
        print("refresh token");
      }
//      auth.rtExp = DateTime.now().subtract(Duration(days: 1));

      if (!rtExp.isAfter(DateTime.now())) {
        print("refresh Refresh");
      }
      notifyListeners();
    } catch (err) {
      print(err);
      throw(err);
    }
  }
}
