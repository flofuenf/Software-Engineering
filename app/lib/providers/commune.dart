import 'package:flutter/cupertino.dart';

import '../models/address.dart';

import '../models/duty.dart';
import '../models/member.dart';

class Commune with ChangeNotifier{
  String uid;
  String name;
  String description;
  DateTime created;
  Address address;
  List<Member> members;
  List<Duty> duties;

  Commune({
    this.uid,
    this.name,
    this.description,
    this.created,
    this.address,
    this.members,
    this.duties,
  });

  List<Member> get member{
    return this.members;
  }
}
