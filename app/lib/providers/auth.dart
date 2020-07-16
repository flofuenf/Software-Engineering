import 'package:flutter/material.dart';

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
}
