import 'package:CommuneIsm/providers/duties.dart';

import 'screens/consumables.dart';
import 'screens/debug.dart';
import 'screens/duties_screen.dart';
import 'screens/overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/dashboard.dart';

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
        ChangeNotifierProvider.value(
          value: Duties(),
        ),
      ],
      child: Consumer<AppState>(
        builder: (ctx, app, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CommuneIsm',
          theme: ThemeData(
            primarySwatch: Colors.grey,
            accentColor: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: app.isLoaded
              ? Dashboard()
              : FutureBuilder(
                  future: app.loadApp(),
                  builder: (ctx, comResultSnapshot) =>
                      comResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            )),
          routes: {
            DebugScreen.routeName: (ctx) => DebugScreen(),
            CommuneOverview.routeName: (ctx) => CommuneOverview(),
            DutyScreen.routeName: (ctx) => app.isLoaded ? DutyScreen() : CircularProgressIndicator(),
            ConsumablesScreen.routeName: (ctx) => ConsumablesScreen(),
          },
        ),
      ),
    );
  }
}
