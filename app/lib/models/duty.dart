
import 'member.dart';

class Duty {
  final String uid;
  final DateTime created;
  final DateTime changed;
  final String name;
  final String description;
  final DateTime lastDone;
  DateTime nextDone;
  final int rotationTime;
  final int rotationIndex;
  final List<Member> rotationList;

  Duty({
    this.uid,
    this.created,
    this.changed,
    this.name,
    this.description,
    this.lastDone,
    this.nextDone,
    this.rotationTime,
    this.rotationIndex,
    this.rotationList,
  });
}
