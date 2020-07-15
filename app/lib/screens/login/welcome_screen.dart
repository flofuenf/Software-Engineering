import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
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
        ),
      ),
    );
  }
}
