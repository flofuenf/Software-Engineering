import 'package:CommuneIsm/helper/graph_helper.dart';
import 'package:CommuneIsm/models/consumable.dart';
import 'package:CommuneIsm/models/member.dart';
import 'package:flutter/cupertino.dart';

class Consumables with ChangeNotifier {
  List<Consumable> items = [];

  Consumables({
    this.items,
  });

  List<Consumable> get list {
    return items;
  }

  int indexById(String uid) {
    return items.indexWhere((duty) => duty.uid == uid);
  }

  Future<void> updateConsumable(Consumable con, String comID) async {
    final index = items.indexWhere((item) => item.uid == con.uid);

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
          "uid": "${con.uid}",
          "name": "${con.name}",
          "isNeeded": ${con.isNeeded},
          "rotationList": [
            ${buildRotationJSON(con.rotationList)}
          ]
         }
        ''';
        var response = await GraphHelper.postSecure(body, "api/consumableSet", "");
        print(response);
        print(con.uid);
        if (response == con.uid) {
          items[items.indexWhere((item) => item.uid == con.uid)] = con;
          fetchConsumables(comID);
        }
      } catch (err) {
        throw (err);
      }
    } else {
      throw ("UID not found");
    }
  }

  Future<void> switchStatus(String conID) async {
    final body = '''{
        "uid": "$conID"
      }''';
    try {
      var data = await GraphHelper.postSecure(body, "api/consumableSwitch", "");
      if (data != null) {
        final List<Member> rotMember = [];
        data['rotationList'].forEach((mem) {
          rotMember.add(Member(
            uid: mem['uid'],
            name: mem['name'],
          ));
        });
        items[indexById(data['uid'])] = Consumable(
          uid: data['uid'],
          name: data['name'],
          created: DateTime.fromMillisecondsSinceEpoch(data['created'] * 1000),
          changed: DateTime.fromMillisecondsSinceEpoch(data['changed'] * 1000),
          lastBought:
              DateTime.fromMillisecondsSinceEpoch(data['lastBought'] * 1000),
          isNeeded: data['isNeeded'],
          rotationList: rotMember,
          rotationIndex: data['rotationIndex'],
        );
      }
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> fetchConsumables(String comID) async {
    final body = '''{
        "uid": "$comID"
      }''';
    try {
      var data = await GraphHelper.postSecure(body, "api/consumableGet", "");
      if (data != null) {
        final List<Consumable> loadedConsumables = [];
        data.forEach((con) {
          final List<Member> rotMember = [];
          con['rotationList'].forEach((mem) {
            rotMember.add(Member(
              uid: mem['uid'],
              name: mem['name'],
            ));
          });
          loadedConsumables.add(Consumable(
            uid: con['uid'],
            name: con['name'],
            created: DateTime.fromMillisecondsSinceEpoch(con['created'] * 1000),
            changed: DateTime.fromMillisecondsSinceEpoch(con['changed'] * 1000),
            lastBought:
                DateTime.fromMillisecondsSinceEpoch(con['lastBought'] * 1000),
            isNeeded: con['isNeeded'],
            rotationList: rotMember,
            rotationIndex: con['rotationIndex'],
          ));
        });
        items = loadedConsumables;
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
