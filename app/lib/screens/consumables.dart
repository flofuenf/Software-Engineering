import '../widgets/menu_drawer.dart';
import 'package:flutter/material.dart';

class ConsumablesScreen extends StatelessWidget {
  static const routeName = "/consumables";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Gegenstände"),
        ),
        drawer: MenuDrawer(),
        body: Center(
          child: Text("Consumables here!"),
        )
    );
  }
}
