import 'package:CommuneIsm/models/consumable.dart';
import 'package:CommuneIsm/models/duty.dart';
import 'package:CommuneIsm/providers/app_state.dart';
import 'package:CommuneIsm/providers/consumables.dart';
import 'package:CommuneIsm/providers/duties.dart';
import 'package:CommuneIsm/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/member.dart';

class Dashboard extends StatelessWidget {
  static const routeName = "/";

  int _getDueInDays(DateTime date) {
    DateTime now = DateTime.now();
    DateTime todayMidnight = DateTime.utc(now.year, now.month, now.day);
    DateTime nextDoneMidnight = DateTime.utc(date.year, date.month, date.day);
    Duration dur = nextDoneMidnight.difference(todayMidnight);
    return dur.inDays;
  }

  Widget _getNextBirthday(List<Member> members) {
    final f = new DateFormat('dd.MM.yyyy');

    Member _memberWithNextBday;
    int _minDue;

    members.forEach((mem) {
      if (_memberWithNextBday == null) {
        _memberWithNextBday = mem;
        _minDue = _getDueInDays(mem.birth);
        return;
      }
      final due = _getDueInDays(mem.birth);
      if (due >= 0 && due < _minDue) {
        _memberWithNextBday = mem;
        _minDue = due;
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(_memberWithNextBday.name),
        Text(f.format(_memberWithNextBday.birth)),
        Text(_minDue == 0
            ? "Heute!"
            : _minDue < 0 ? "in ${365 + _minDue} Tagen" : "in $_minDue Tagen"),
      ],
    );
  }

  Widget _getNextConsumables(List<Consumable> consumables, String userID) {
    final f = new DateFormat('dd.MM.yyyy');
    List<Widget> list;
    List<Consumable> nextConsumables = new List<Consumable>();

    consumables.forEach((con) {
      if (con.rotationList[con.rotationIndex].uid == userID) {
        nextConsumables.add(con);
      }
    });

    if (nextConsumables.length > 0) {
      list = new List<Widget>();
      nextConsumables.forEach((con) {
        list.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(con.name),
            Text("zuletzt am ${f.format(con.lastBought)} gekauft"),
            con.isNeeded
                ? Text(
                    "Benötigt!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  )
                : Text("Noch vorhanden", style: TextStyle(color: Colors.green)),
          ],
        ));
      });
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: nextConsumables.length == 0
          ? <Widget>[
              Text("Sieht gut aus!"),
              Text("Momentan musst du nichts besorgen :)"),
            ]
          : list,
    );
  }

  Widget _getNextDuty(List<Duty> duties, String userID) {
    final f = new DateFormat('dd.MM.yyyy');
    List<Widget> list;
    List<Duty> nextDuties = new List<Duty>();
    List<int> dutyDues = new List<int>();

    duties.forEach((duty) {
      if (duty.rotationList[duty.rotationIndex].uid == userID) {
        nextDuties.add(duty);
        dutyDues.add(_getDueInDays(duty.nextDone));
      }
    });

    if (nextDuties.length > 0) {
      list = new List<Widget>();
      for (var i = 0; i < nextDuties.length; i++) {
        list.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(nextDuties[i].name),
            Text("am ${f.format(nextDuties[i].nextDone)}"),
            dutyDues[i] == 0
                ? Text(
                    "Heute!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  )
                : dutyDues[i] < 0
                    ? Text(
                        "vor ${dutyDues[i] *= -1} Tagen",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      )
                    : Text("in ${dutyDues[i]} Tagen")
          ],
        ));
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: nextDuties.length == 0
          ? <Widget>[
              Text("Momentan sieht es gut aus für dich! :)"),
              Text("Keine Dienste fällig."),
            ]
          : list,
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final duties = Provider.of<Duties>(context);
    final consumables = Provider.of<Consumables>(context);
    duties.fetchDuties(app.comID);
    consumables.fetchConsumables(app.comID);
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      drawer: MenuDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Nächster Geburtstag",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _getNextBirthday(app.commune.members),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Dein nächster Putzdienst",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _getNextDuty(duties.list, app.user.uid)
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Einkaufsliste",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _getNextConsumables(consumables.list, app.user.uid)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
