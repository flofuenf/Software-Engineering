import 'package:CommuneIsm/providers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              Image.network(
                  "https://d338t8kmirgyke.cloudfront.net/icons/icon_pngs/000/000/859/original/login.png",
                  height: 200),
              SizedBox(height: 50),
              Container(
                width: 400,
                child: AuthForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key key,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _pwController = TextEditingController();
  final _mailController = TextEditingController();

  bool _isLoading = false;

  Map<String, String> _authData = {
    'username': '',
    'password': '',
  };

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    _authData['mail'] = _mailController.text;
    _authData['pw'] = _pwController.text;

    if(_authData['mail'].length > 1 && _authData['pw'].length > 1){
      try {
        await Provider.of<AppState>(context, listen: false).login(_authData);
        Navigator.of(context).pop();
      } catch (err) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text("Login fehlgeschlagen"),
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
        _pwController.clear();
        setState(() {
          _isLoading = false;
        });
      }
    }else{
      print("check your map!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
                fontSize: 18,
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
                  size: 35,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return "Bitte gib einen Benutzernamen ein";
              }
              return null;
            },
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: _pwController,
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
                fontSize: 18,
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
                  size: 35,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return "Bitte gib ein Passwort ein";
              }
              return null;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text("Passwort vergessen?"),
                onPressed: () {
                  print("forgot");
                },
              ),
            ],
          ),
          _isLoading
              ? CircularProgressIndicator()
              : RaisedButton(
                  onPressed: () {
                    _submit();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Login"),
                  ),
                )
        ],
      ),
    );
  }
}
