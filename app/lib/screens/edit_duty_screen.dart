import 'package:CommuneIsm/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';

class EditDutyScreen extends StatelessWidget {
  static const routeName = "/dutyedit";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Putzdienst ändern"),
      ),
      body: Center(
        child: Text("Formular hier!! :)"),
      ),
    );
  }
}
