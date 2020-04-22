import 'dart:convert';

import '../models/address.dart';

import '../helper/graph_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'commune.dart';
import 'user.dart';

class AppState with ChangeNotifier {
  User user;
  Commune commune;

  AppState({
    this.user,
    this.commune,
  });

  bool get isLoaded {
    return (user != null && commune != null);
  }

  String get comID{
    return commune.uid;
  }

  Future<void> initApp() async {
    const comID = '0x20';
    const userID = '0x22';
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'comID': comID,
        'userID': userID,
      });
      prefs.setString('userData', userData);
      return;
    } catch (err) {
      throw (err);
    }
  }

  Future<void> loadApp() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.containsKey('comID') || prefs.containsKey('userID'))) {
      await initApp();
    }
    final prefsData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final comID = prefsData['comID'];
    final userID = prefsData['userID'];

    await fetchUser(userID);
    await fetchCommune(comID);
  }

  Future<void> fetchCommune(String comID) async {
    final body = '''{
        "uid": "$comID"
      }''';
    try {
      var data = await GraphHelper.postSecure(body, "communeGet");
      commune = Commune(
        uid: data['uid'],
        name: data['name'],
        description: data['description'],
        address: Address(
          uid: data['address']['uid'],
          street: data['address']['street'],
          city: data['address']['city'],
          zip: data['address']['zip'],
        ),
      );
      notifyListeners();
    } catch (err) {
      commune = null;
      notifyListeners();
      throw (err);
    }
  }

  Future<void> fetchUser(String userUD) async {
    final body = '''{
        "uid": "$userUD"
      }''';

    try {
      var data = await GraphHelper.postSecure(body, "userGet");
      user = User(
        uid: data['uid'],
        name: data['name'],
        birth: DateTime.fromMillisecondsSinceEpoch(data['birth']),
      );
      notifyListeners();
    } catch (err) {
      user = null;
      notifyListeners();
      throw (err);
    }
  }
}
