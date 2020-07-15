import 'package:flutter/material.dart';

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
      body: Padding(
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
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
//                        controller: _usernameController,
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
                        onSaved: (value) {
                          print(value);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
//                        controller: _usernameController,
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
                            return "Bitte gib einen Benutzernamen ein";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          print(value);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
//                        controller: _passwordController,
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
                        onSaved: (value) {
                          print(value);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
//                        controller: _passwordController,
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
                          return null;
                        },
                        onSaved: (value) {
                          print(value);
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RaisedButton(
                        onPressed: () {
                          print("save");
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Registrieren"),
                        ),
                      )
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
