import 'member.dart';

class Consumable {
  String uid;
  final DateTime created;
  final DateTime changed;
  String name;
  final DateTime lastBought;
  final int rotationIndex;
  bool isNeeded;
  List<Member> rotationList;

  Consumable({
    this.uid,
    this.created,
    this.changed,
    this.name,
    this.isNeeded,
    this.lastBought,
    this.rotationIndex,
    this.rotationList,
  });
}
