import 'package:flutter/material.dart';

class Member {
  final String uid;
  final String name;
  final DateTime created;
  final DateTime birth;

  Member({
    @required this.uid,
    @required this.name,
    @required this.created,
    @required this.birth,
  });
}
