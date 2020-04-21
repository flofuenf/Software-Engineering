import 'package:CommuneIsm/screens/debug.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/commune.dart';
import 'providers/app_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AppState(),
        ),
      ],
      child: Consumer<AppState>(
        builder: (ctx, app, _) =>
            MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'CommuneIsm',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: app.isLoaded ? DebugScreen() : FutureBuilder(
                  future: app.loadApp(),
                  builder: (ctx, comResultSnapshot) =>
                  comResultSnapshot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator(),)
                      : Center(child: CircularProgressIndicator(),)
      ),
      routes: {},
    ),)
    ,
    );
  }
}
