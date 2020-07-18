import 'package:CommuneIsm/providers/app_state.dart';
import 'package:CommuneIsm/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = "/register";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Image.network(
                    "https://cdn.onlinewebfonts.com/svg/img_193664.png",
                    height: 200),
                SizedBox(height: 50),
                Container(
                  width: 400,
                  child: RegisterForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key key,
  }) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _regFormKey = GlobalKey();
  final _nameController = TextEditingController();
  final _pwController1 = TextEditingController();
  final _mailController = TextEditingController();
  final _pwController2 = TextEditingController();
  final _birthController = TextEditingController();

  bool _isLoading = false;
  DateTime _selectedDate;
  final f = new DateFormat('dd.MM.yyyy');

  Map<String, String> _regData = {
    'mail': '',
    'pass': '',
    'name': '',
    'birth': '',
  };

  bool _checkMap(Map<String, String> map) {
    bool complete = false;
    map.forEach((key, value) {
      print(value);
      value.length > 0 ? complete = true : complete = false;
    });
    return complete;
  }

  void _submit() async {
    print("submit");
    if (!_regFormKey.currentState.validate()) {
      print("validate false");
      return;
    }
    print("save Form");
    _regFormKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    _regData['mail'] = _mailController.text;
    _regData['pass'] = _pwController1.text;
    _regData['birth'] = _selectedDate.millisecondsSinceEpoch.toString();
    _regData['name'] = _nameController.text;

    if (_checkMap(_regData)) {
      try {
        await Provider.of<AppState>(context, listen: false).register(_regData);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text("Registration erfolgreich"),
              content: Text("Du kannst dich nun anmelden"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Super!"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                  },
                ),
              ],
            );
          },
        );
      } catch (err) {
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
        _pwController1.clear();
        _pwController2.clear();
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("is not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _regFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
              ),
              labelText: "Dein Name",
              labelStyle: TextStyle(
                color: Colors.white,
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
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return "Bitte gib einen Namen ein";
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Container(
                width: 250,
                child: TextFormField(
                  enabled: false,
                  controller: _birthController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Theme.of(context).errorColor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    labelText: "Dein Geburtstag",
                    labelStyle: TextStyle(
                      color: Colors.white,
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
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  validator: (value) {
                    print("validate date");
                    if (value.isEmpty || value.length < 1) {
                      print("val false");
                      return "Bitte wähle ein Geburtsdatum aus";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 30),
              RaisedButton(
//            focusNode: _dateFocusNode,
                child: Text("Auswählen"),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    lastDate: DateTime.now(),
                    firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                  ).then((date) {
                    setState(() {
                      _selectedDate = date;
                      _birthController.text = f.format(date);
                    });
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _mailController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
              ),
              labelText: "E-Mail Adresse",
              labelStyle: TextStyle(
                color: Colors.white,
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
                  Icons.mail,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return "Bitte gib eine E-Mail Adresse ein";
              }
              if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
                return "Bitte gib eine gültige Mail Adresse ein";
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _pwController1,
            textInputAction: TextInputAction.done,
            obscureText: true,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
              ),
              labelText: "Passwort",
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              contentPadding: EdgeInsets.all(10),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 5,
                  right: 15,
                  bottom: 0,
                ),
                child: Icon(
                  Icons.vpn_key,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return "Bitte gib ein Passwort ein";
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _pwController2,
            textInputAction: TextInputAction.done,
            obscureText: true,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
              ),
              labelText: "Passwort wiederholen",
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              contentPadding: EdgeInsets.all(10),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 5,
                  right: 15,
                  bottom: 0,
                ),
                child: Icon(
                  Icons.vpn_key,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return "Bitte gib ein Passwort ein";
              }
              if (value != _pwController1.text) {
                return "Passwörter stimmen nicht überein";
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
                    _submit();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Registrieren"),
                  ),
                )
        ],
      ),
    );
  }
}
