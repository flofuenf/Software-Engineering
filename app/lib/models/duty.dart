import 'package:flutter/material.dart';

import 'member.dart';

class Duty {
  final String uid;
  final DateTime created;
  final DateTime changed;
  final String name;
  final String description;
  final DateTime lastDone;
  final DateTime nextDone;
  final int rotationTime;
  final List<Member> rotationList;

  Duty({
    @required this.uid,
    @required this.created,
    @required this.changed,
    @required this.name,
    @required this.description,
    @required this.lastDone,
    @required this.nextDone,
    @required this.rotationTime,
    @required this.rotationList,
  });
}
