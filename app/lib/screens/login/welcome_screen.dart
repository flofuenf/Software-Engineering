import 'package:CommuneIsm/providers/app_state.dart';
import 'package:CommuneIsm/screens/login/join_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = ("/welcome");
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: appState.auth == null ? Selection() : JoinScreen(),
      ),
    );
  }
}

class Selection extends StatelessWidget {
  const Selection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 60,
          ),
          Image.network("https://www.sainte-fereole.fr/sites/default/files/logos/black-towncenter.png", height: 300),
          Container(
            width: 200,
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Login"),
                    onPressed: (){
                      Navigator.of(context).pushNamed('/login');
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Registration"),
                    onPressed: (){
                      Navigator.of(context).pushNamed('/register');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
