import 'package:CommuneIsm/models/member.dart';
import 'package:flutter/material.dart';

class User extends Member with ChangeNotifier {
  DateTime created;
  String uid;
  String name;
  DateTime birth;

  User({
    @required this.uid,
    @required this.name,
    this.created,
    @required this.birth,
  });

  void setUser(User u) {
    this.uid = u.uid;
    this.name = u.name;
    this.created = u.created;
    this.birth = u.birth;
  }
}
