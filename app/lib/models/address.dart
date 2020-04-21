import 'package:flutter/material.dart';

class Address {
  final String uid;
  final DateTime created;
  final String street;
  final String city;
  final String zip;

  Address({
    @required this.uid,
    this.created,
    @required this.street,
    @required this.city,
    @required this.zip,
  });

  @override
  String toString(){
    return ("$street $zip $city");
  }
}
