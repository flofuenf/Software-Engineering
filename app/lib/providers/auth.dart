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
}
