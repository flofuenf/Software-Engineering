import 'package:CommuneIsm/models/consumable.dart';
import 'package:CommuneIsm/models/member.dart';
import 'package:CommuneIsm/providers/app_state.dart';
import 'package:CommuneIsm/providers/consumables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditConsumableScreen extends StatefulWidget {
  static const routeName = "/consumableEdit";

  @override
  _EditConsumableScreenState createState() => _EditConsumableScreenState();
}

class _EditConsumableScreenState extends State<EditConsumableScreen> {
  final _nameFocusNode = FocusNode();
  final _nameController = TextEditingController();
  bool _isInit = true;
  bool _isLoading = false;
  bool update = true;
  Consumable consumable;
  final _form = GlobalKey<FormState>();
  List<Member> members = [];

  @override
  void initState() {
    super.initState();
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
    if (consumable.rotationList == null) {
      consumable.rotationList = [];
      return false;
    }
    if (consumable.rotationList.any((element) => element.uid == member.uid)) {
      return true;
    }
    return false;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      this.consumable = ModalRoute.of(context).settings.arguments as Consumable;
      this.members = Provider.of<AppState>(context, listen: false).members;
      if (consumable == null) {
        update = false;
        consumable = Consumable();
      }
      _nameController.text = consumable.name;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveConsumable() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    if (consumable.rotationList.length < 1) {
      await showPopUp("Error", "Bitte wähle mindestens ein WG-Mitglied aus");
      return;
    }

    consumable.name = _nameController.text;

    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (update) {
      try {
        await Provider.of<Consumables>(context, listen: false).updateConsumable(
            consumable, Provider.of<AppState>(context).commune.uid);
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        throw (err);
      }
    } else {
      try {
        await Provider.of<Consumables>(context, listen: false).createConsumable(
            consumable, Provider.of<AppState>(context).commune.uid);
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        throw (err);
      }
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gegenstand bearbeiten"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveConsumable,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading ? Center(child: CircularProgressIndicator(),) : Form(
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
              Column(
                children: members
                    .map((e) => CheckboxListTile(
                          title: Text(e.name),
                          value: checkOnMember(e),
                          onChanged: (bool val) {
                            setState(() {
                              if (val) {
                                consumable.rotationList.add(e);
                              } else {
                                consumable.rotationList
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
