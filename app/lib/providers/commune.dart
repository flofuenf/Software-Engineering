import '../helper/graph_helper.dart';

import '../models/address.dart';
import 'package:flutter/material.dart';

import '../models/duty.dart';
import '../models/member.dart';

class Commune with ChangeNotifier {
  String uid;
  String name;
  String description;
  DateTime created;
  Address address;
  List<Member> members;
  List<Duty> duties;

  bool get isLoaded {
    return uid != null;
  }

  Future<void> fetchCommune() async {
    final body = '''{
        "uid": "0x20"
      }''';
    try {
      var data = await GraphHelper.postSecure(body, "communeGet");
      this.uid = data['uid'];
      this.name = data['name'];
      this.description = data['description'];
      this.address = Address(
        uid: data['address']['uid'],
        street: data['address']['street'],
        city: data['address']['city'],
        zip: data['address']['zip'],
      );
      notifyListeners();
    } catch (err) {
      print(err);
      uid = null;
      notifyListeners();
      throw (err);
    }
  }

  Commune({
    this.uid,
    this.name,
    this.description,
    this.created,
    this.address,
    this.members,
    this.duties,
  });
}
