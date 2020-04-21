import 'package:CommuneIsm/providers/app_state.dart';
import 'package:CommuneIsm/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommuneOverview extends StatelessWidget {
  static const routeName = "/overview";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Commune"),
      ),
      drawer: MenuDrawer(),
      body: Consumer<AppState>(
        builder: (ctx, app, _) => Center(
      child: Column(
        children: <Widget>[
          Text(app.commune.uid),
          Text(app.commune.name),
          Text(app.commune.description),
          Text(app.commune.address.toString()),
          Text("##########################"),
          Text(app.user.uid),
          Text(app.user.name),
          Text(DateFormat('dd--MM--yyy').format(app.user.birth)),
        ],
      ),
    ),
    ),
    );
  }
}
