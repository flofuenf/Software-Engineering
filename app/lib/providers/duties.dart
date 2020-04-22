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

  Future<void> fetchDuties(String comID) async {
    final body = '''{
        "uid": "$comID"
      }''';
    try {
      var data = await GraphHelper.postSecure(body, "dutyGet");
      if (data != null){
        final List<Duty> loadedDuties = [];
        data.forEach((duty){
          final List<Member> rotMember = [];
          duty['rotationList'].forEach((mem){
            rotMember.add(Member(
              uid: mem['uid'],
              name: mem['name'],
            ));
          });
          loadedDuties.add(
            Duty(uid: duty['uid'],
              name: duty['name'],
              description: duty['description'],
              created: DateTime.fromMillisecondsSinceEpoch(duty['created']),
              changed: DateTime.fromMillisecondsSinceEpoch(duty['changed']),
              lastDone: DateTime.fromMillisecondsSinceEpoch(duty['lastDone']),
              nextDone: DateTime.fromMillisecondsSinceEpoch(duty['nextDone']),
              rotationList: rotMember,
              rotationTime: duty['rotationTime'],
            )
          );
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
