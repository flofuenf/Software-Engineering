import '../models/member.dart';

import '../helper/graph_helper.dart';
import '../models/duty.dart';
import 'package:flutter/material.dart';

class Duties with ChangeNotifier {
  List<Duty> items = [];

  Duties({
    this.items,
  });

  List<Duty> get list {
    return items;
  }

  int indexById(String uid) {
    return items.indexWhere((duty) => duty.uid == uid);
  }

  Future<void> setDone(String dutyID) async {
    final body = '''{
        "uid": "$dutyID"
      }''';
    try {
      var data = await GraphHelper.postSecure(body, "dutyDone");
      if (data != null) {
        final List<Member> rotMember = [];
        data['rotationList'].forEach((mem) {
          rotMember.add(Member(
            uid: mem['uid'],
            name: mem['name'],
          ));
        });
        items[indexById(data['uid'])] = Duty(
          uid: data['uid'],
          name: data['name'],
          description: data['description'],
          created: DateTime.fromMillisecondsSinceEpoch(data['created']* 1000),
          changed: DateTime.fromMillisecondsSinceEpoch(data['changed'] * 1000),
          lastDone: DateTime.fromMillisecondsSinceEpoch(data['lastDone'] * 1000),
          nextDone: DateTime.fromMillisecondsSinceEpoch(data['nextDone'] * 1000),
          rotationList: rotMember,
          rotationTime: data['rotationTime'],
          rotationIndex: data['rotationIndex'],
        );
      }
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> fetchDuties(String comID) async {
    final body = '''{
        "uid": "$comID"
      }''';
    try {
      var data = await GraphHelper.postSecure(body, "dutyGet");
      if (data != null) {
        final List<Duty> loadedDuties = [];
        data.forEach((duty) {
          final List<Member> rotMember = [];
          duty['rotationList'].forEach((mem) {
            rotMember.add(Member(
              uid: mem['uid'],
              name: mem['name'],
            ));
          });
          loadedDuties.add(Duty(
            uid: duty['uid'],
            name: duty['name'],
            description: duty['description'],
            created: DateTime.fromMillisecondsSinceEpoch(duty['created'] * 1000),
            changed: DateTime.fromMillisecondsSinceEpoch(duty['changed'] * 1000),
            lastDone: DateTime.fromMillisecondsSinceEpoch(duty['lastDone'] * 1000),
            nextDone: DateTime.fromMillisecondsSinceEpoch(duty['nextDone'] * 1000),
            rotationList: rotMember,
            rotationTime: duty['rotationTime'],
            rotationIndex: duty['rotationIndex'],
          ));
        });
        items = loadedDuties;
        notifyListeners();
      }
      notifyListeners();
    } catch (err) {
      items = [];
      notifyListeners();
      throw (err);
    }
  }
}
