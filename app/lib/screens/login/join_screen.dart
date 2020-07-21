import 'package:CommuneIsm/providers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinScreen extends StatelessWidget {
  static const routeName = "/join";

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              Image.network("https://cdn.onlinewebfonts.com/svg/img_115995.png",
                  height: 200),
              SizedBox(height: 50),
              Container(
                width: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: Text("Per Einladung beitreten"),
                                content: Container(
                                  height: 190,
                                  child: InviteForm(),
                                ),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("Abbrechen"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("Per Einladung beitreten"),
                      ),
                      RaisedButton(
                        onPressed: () {
                        },
                        child: Text("WG erstellen"),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
    );
  }
}

class InviteForm extends StatefulWidget {
  const InviteForm({
    Key key,
  }) : super(key: key);

  @override
  _InviteFormState createState() => _InviteFormState();
}

class _InviteFormState extends State<InviteForm> {
  final GlobalKey<FormState> _inviteFormKey = GlobalKey();
  final _idController = TextEditingController();

  bool _isLoading = false;

  Map<String, String> _joinData = {
    'comID': '',
    'userID': '',
  };

  void _submitID() async {
    if (!_inviteFormKey.currentState.validate()) {
      return;
    }
    _inviteFormKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    _joinData['comID'] = _idController.text;
    _joinData['userID'] = Provider.of<AppState>(context).user.uid;

    if(_joinData['comID'].length > 1 && _joinData['userID'].length > 1){
      try{
        await Provider.of<AppState>(context, listen: false).join(_joinData);
        Navigator.of(context).pop();
      }catch(err){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text("Registration fehlgeschlagen"),
              content: Text(err),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Schade..."),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        _idController.clear();
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _inviteFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _idController,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.black,
                ),
              ),
              labelText: "WG - Identifier",
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              contentPadding: EdgeInsets.all(10),
              fillColor: Colors.blueGrey,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 5,
                  right: 15,
                  bottom: 0,
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
            validator: (value) {
              if (value.isEmpty || value.length < 3) {
                return "Bitte gib eine ID ein";
              }
              return null;
            },
          ),
          SizedBox(
            height: 30,
          ),
          _isLoading
              ? CircularProgressIndicator()
              : RaisedButton(
                  onPressed: () {
                    _submitID();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Beitreten"),
                  ),
                )
        ],
      ),
    );
  }
}
