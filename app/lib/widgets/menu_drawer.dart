import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Menu"),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.black87,
            ),
            Column(
              children: <Widget>[
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.dashboard,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Dashboard",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("/");
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Your Commune",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/overview');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.bug_report,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Debug View",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/debug');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
