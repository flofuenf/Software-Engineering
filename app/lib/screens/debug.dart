import '../providers/commune.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebugScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Debug"),
      ),
      body: Consumer<Commune>(
        builder: (ctx, com, _)=> Center(
          child: Column(
            children: <Widget>[
              Text(com.uid),
              Text(com.name),
              Text(com.description),
              Text(com.address.toString()),
            ],
          ),
        ),
      ),
    );
  }
}