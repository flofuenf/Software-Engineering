import 'package:flutter/material.dart';

class Member{
  final String uid;
  final String name;
  final DateTime created;
  final DateTime birth;
  final String commune;

  Member({
    @required this.uid,
    @required this.name,
    this.created,
    this.birth,
    this.commune,
  });
}
