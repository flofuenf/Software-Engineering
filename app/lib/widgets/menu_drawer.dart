import 'package:CommuneIsm/providers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                    "Deine WG",
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
                    "Dienste",
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
                    "Gegenstände",
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
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Ausloggen",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Ausloggen"),
                        content: Text("Bist du dir sicher, dass du dich abmelden möchtest?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Ja, sicher"),
                            onPressed: () {
                              Provider.of<AppState>(context, listen: false).logout();
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text("Nein"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
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
