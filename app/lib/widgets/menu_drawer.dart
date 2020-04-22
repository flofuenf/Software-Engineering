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
                    Icons.work,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Duties",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/duties');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Consumables",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/consumables');
                  },
                ),
                Divider(
                  thickness: 1.0,
                  color: Colors.white,
                ),
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
