import 'package:CommuneIsm/models/duty.dart';
import 'package:CommuneIsm/models/member.dart';
import 'package:CommuneIsm/models/rotation.dart';
import 'package:CommuneIsm/providers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditDutyScreen extends StatefulWidget {
  static const routeName = "/dutyedit";

  @override
  _EditDutyScreenState createState() => _EditDutyScreenState();
}

class _EditDutyScreenState extends State<EditDutyScreen> {
  bool _isInit = true;
  Duty duty;
  final _form = GlobalKey<FormState>();
  List<Member> members = [];
  List<DropdownMenuItem<Rotation>> _rotationList = [];
  Rotation _selectedRotation;

  @override
  void initState() {
    super.initState();
  }

  List<DropdownMenuItem<Rotation>> buildRotationDropdown() {
    List<DropdownMenuItem<Rotation>> items = List();
    for (Rotation rot in Rotation.values) {
      items.add(
        DropdownMenuItem(
          value: rot,
          child: Text(rot.name),
        ),
      );
    }
    return items;
  }

  bool checkOnMember(Member member) {
    if (duty.rotationList == null) {
      duty.rotationList = [];
      return false;
    }
    if (duty.rotationList.any((element) => element.uid == member.uid)) {
      return true;
    }
    return false;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _rotationList = buildRotationDropdown();
      this.duty = ModalRoute.of(context).settings.arguments as Duty;
      this.members = Provider.of<AppState>(context, listen: false).members;
      if (duty == null) {
        duty = Duty();
        _selectedRotation = _rotationList[0].value;
      } else {
        _selectedRotation = _rotationList[_rotationList
                .indexWhere((rot) => rot.value.duration == duty.rotationTime)]
            .value;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('dd.MM.yyyy');

    changeRotation(Rotation selectedRotation) {
      setState(() {
        _selectedRotation = selectedRotation;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Putzdienst ändern"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      initialValue: duty.name,
                      decoration: InputDecoration(
                        labelText: "Name",
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      initialValue: duty.description,
                      decoration: InputDecoration(
                        labelText: "Beschreibung",
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(duty.nextDone == null
                          ? 'Start-Datum wählen'
                          : f.format(duty.nextDone)),
                      RaisedButton(
                        child: Text("Pick a date"),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate:
                                DateTime.now().subtract(Duration(days: 10)),
                            lastDate: DateTime.now().add(Duration(days: 30)),
                          ).then((date) {
                            setState(() {
                              duty.nextDone = date;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                  Flexible(
                    child: DropdownButton(
                      value: _selectedRotation,
                      items: _rotationList,
                      onChanged: changeRotation,
                    ),
                  ),
                ],
              ),
              Column(
                children: members
                    .map((e) => CheckboxListTile(
                          title: Text(e.name),
                          value: checkOnMember(e),
                          onChanged: (bool val) {
                            setState(() {
                              if (val) {
                                duty.rotationList.add(e);
                              } else {
                                duty.rotationList.removeWhere((item) => item.uid == e.uid);
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
