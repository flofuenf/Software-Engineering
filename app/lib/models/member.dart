import 'package:CommuneIsm/providers/user.dart';
import 'package:flutter/material.dart';

class Member{
  final String uid;
  final String name;
  final DateTime created;
  final DateTime birth;

  Member({
    @required this.uid,
    @required this.name,
    this.created,
    this.birth,
  });
}
