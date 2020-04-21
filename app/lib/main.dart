import 'package:CommuneIsm/screens/debug.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/commune.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Commune(),
        ),
      ],
      child: Consumer<Commune>(
        builder: (ctx, com, _) =>
            MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'CommuneIsm',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: com.isLoaded ? DebugScreen() : FutureBuilder(
                  future: com.fetchCommune(),
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
