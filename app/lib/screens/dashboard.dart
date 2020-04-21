import 'package:CommuneIsm/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
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
                elevation: 1.0,
                child: Column(
                  children: <Widget>[
                    Text("lol"),
                    Text("lol"),
                    Text("lol"),
                  ],
                ),
              ),
              Card(
                elevation: 1.0,
                child: Column(
                  children: <Widget>[
                    Text("lol"),
                    Text("lol"),
                    Text("lol"),
                  ],
                ),
              ),
              Card(
                elevation: 1.0,
                child: Column(
                  children: <Widget>[
                    Text("lol"),
                    Text("lol"),
                    Text("lol"),
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
