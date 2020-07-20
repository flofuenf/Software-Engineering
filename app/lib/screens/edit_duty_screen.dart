import 'package:CommuneIsm/models/duty.dart';
import 'package:CommuneIsm/models/member.dart';
import 'package:CommuneIsm/models/rotation.dart';
import 'package:CommuneIsm/providers/app_state.dart';
import 'package:CommuneIsm/providers/duties.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditDutyScreen extends StatefulWidget {
  static const routeName = "/dutyedit";

  @override
  _EditDutyScreenState createState() => _EditDutyScreenState();
}

class _EditDutyScreenState extends State<EditDutyScreen> {
  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isInit = true;
  bool _isLoading = false;
  Duty duty;
  bool update = true;
  final _form = GlobalKey<FormState>();
  List<Member> members = [];
  List<DropdownMenuItem<Rotation>> _rotationList = [];
  Rotation _selectedRotation;
  DateTime _selectedDate;

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

  Future<void> showPopUp(String title, String text) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: Text("Okay"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
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
        update = false;
        duty = Duty();
        _selectedRotation = _rotationList[0].value;
      } else {
        _selectedRotation = _rotationList[_rotationList
                .indexWhere((rot) => rot.value.duration == duty.rotationTime)]
            .value;
      }
      _nameController.text = duty.name;
      _descriptionController.text = duty.description;
      _selectedDate = duty.nextDone;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveDuty() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    if(duty.rotationList.length < 1){
      await showPopUp("Error", "Bitte wähle mindestens ein WG-Mitglied aus");
      return;
    }

    duty.rotationTime = _selectedRotation.duration;
    duty.name = _nameController.text;
    duty.description = _descriptionController.text;
    duty.nextDone = _selectedDate;

    if(duty.nextDone == null){
      await showPopUp("Error", "Bitte wähle ein Datum aus...");
      return;
    }

    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if(update){
      try{
        await Provider.of<Duties>(context, listen: false).updateDuty(duty);
      }catch(err){
        throw(err);
      }
    }else{
      try{
        String comID = Provider.of<AppState>(context, listen: false).commune.uid;
        await Provider.of<Duties>(context, listen: false).createDuty(duty, comID);
      }catch(err){
        throw(err);
      }
    }
    Navigator.of(context).pop();
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
        title: Text("Putzdienst bearbeiten"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveDuty,
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
                      focusNode: _nameFocusNode,
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      focusNode: _descriptionFocusNode,
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: "Beschreibung",
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_dateFocusNode);
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(_selectedDate == null
                          ? 'Start-Datum wählen'
                          : f.format(_selectedDate)),
                      RaisedButton(
                        focusNode: _dateFocusNode,
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
                              _selectedDate = date;
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
                                duty.rotationList
                                    .removeWhere((item) => item.uid == e.uid);
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
