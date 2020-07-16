import '../models/member.dart';

import '../helper/graph_helper.dart';
import '../models/duty.dart';
import 'package:flutter/material.dart';

import 'auth.dart';

class Duties with ChangeNotifier {
  List<Duty> items = [];
  Auth auth;

  Duties({
    this.auth,
    this.items,
  });

  List<Duty> get list {
    return items;
  }

  int indexById(String uid) {
    return items.indexWhere((duty) => duty.uid == uid);
  }

  Future<void> deleteDuty(String dutyID, String comID) async{
    final body = '''{
        "uid": "$comID",
        "duties": [
          {
            "uid": "$dutyID"
          }
         ]
      }''';

    try {
      var response = await GraphHelper.postSecure(body, "api/dutyDelete", auth.accessToken);
      if (response != ""){
        items.removeAt(indexById(dutyID));
        notifyListeners();
      }
      else{
        throw("Delete failed :(");
      }
    }catch(err){
      throw(err);
    }
  }

  Future<void> setDone(String dutyID) async {
    final body = '''{
        "uid": "$dutyID"
      }''';
    try {
      var data = await GraphHelper.postSecure(body, "api/dutyDone", auth.accessToken);
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
          created: DateTime.fromMillisecondsSinceEpoch(data['created'] * 1000),
          changed: DateTime.fromMillisecondsSinceEpoch(data['changed'] * 1000),
          lastDone:
              DateTime.fromMillisecondsSinceEpoch(data['lastDone'] * 1000),
          nextDone:
              DateTime.fromMillisecondsSinceEpoch(data['nextDone'] * 1000),
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

  Future<void> updateDuty(Duty duty) async {
    print("update");
    final index = items.indexWhere((item) => item.uid == duty.uid);

    String buildRotationJSON(List<Member> list) {
      StringBuffer sb = StringBuffer();
      for (int i = 0; i < list.length; i++) {
        sb.write('''
        {
          "uid": "${list[i].uid}"
        }
        ''');
        if (i + 1 < list.length) {
          sb.write(",");
        }
      }

      return sb.toString();
    }

    if (index >= 0) {
      try {
        final body = '''
        {
          "uid": "${duty.uid}",
          "name": "${duty.name}",
          "description": "${duty.description}",
          "rotationTime": ${duty.rotationTime},
          "nextDone": ${duty.nextDone.millisecondsSinceEpoch / 1000},
          "rotationList": [
            ${buildRotationJSON(duty.rotationList)}
          ]
         }
        ''';
        var response = await GraphHelper.postSecure(body, "api/dutySet", auth.accessToken);
        if (response == duty.uid) {
          items[items.indexWhere((item) => item.uid == duty.uid)] = duty;
          notifyListeners();
        }
      } catch (err) {
        throw (err);
      }
    } else {
      throw ("UID not found");
    }
  }

  Future<void> createDuty(Duty duty, String comID) async {
    print("create");

    String buildRotationJSON(List<Member> list) {
      StringBuffer sb = StringBuffer();
      for (int i = 0; i < list.length; i++) {
        sb.write('''
        {
          "uid": "${list[i].uid}"
        }
        ''');
        if (i + 1 < list.length) {
          sb.write(",");
        }
      }

      return sb.toString();
    }

    try {
      final body = '''
        {
          "uid": "$comID",
          "duties": [
            {
              "name": "${duty.name}",
              "description": "${duty.description}",
              "rotationTime": ${duty.rotationTime},
              "nextDone": ${duty.nextDone.millisecondsSinceEpoch / 1000},
              "rotationList": [
                ${buildRotationJSON(duty.rotationList)}
              ]
            }
          ]
         }
        ''';
      var response = await GraphHelper.postSecure(body, "api/duty", auth.accessToken);
      if (response != "") {
        duty.uid = response;
        items.add(duty);
        fetchDuties(comID);
      } else {
        throw ("Something went wrong (Creating Duty)");
      }
    } catch (err) {
      throw (err);
    }
  }

  Future<void> fetchDuties(String comID) async {
    final body = '''{
        "uid": "$comID"
      }''';
    try {
      var data = await GraphHelper.postSecure(body, "api/dutyGet", auth.accessToken);
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
            created:
                DateTime.fromMillisecondsSinceEpoch(duty['created'] * 1000),
            changed:
                DateTime.fromMillisecondsSinceEpoch(duty['changed'] * 1000),
            lastDone: duty['lastDone'] != null
                ? DateTime.fromMillisecondsSinceEpoch(duty['lastDone'] * 1000)
                : DateTime.fromMillisecondsSinceEpoch(0),
            nextDone:
                DateTime.fromMillisecondsSinceEpoch(duty['nextDone'] * 1000),
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
