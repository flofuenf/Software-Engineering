import 'package:CommuneIsm/providers/auth.dart';
import 'package:CommuneIsm/providers/consumables.dart';
import 'package:CommuneIsm/providers/duties.dart';
import 'package:CommuneIsm/screens/edit_duty_screen.dart';
import 'package:CommuneIsm/screens/login/join_screen.dart';
import 'package:CommuneIsm/screens/login/login_screen.dart';
import 'package:CommuneIsm/screens/login/welcome_screen.dart';

import 'providers/app_state.dart';
import 'providers/commune.dart';
import 'screens/consumables_screen.dart';
import 'screens/dashboard.dart';
import 'screens/duties_screen.dart';
import 'screens/edit_consumable_screen.dart';
import 'screens/commune_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login/login_screen.dart';
import 'screens/login/register_screen.dart';
import 'screens/login/welcome_screen.dart';

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
        ChangeNotifierProxyProvider<AppState, Duties>(
          //Duties
          builder: (ctx, app, prevDuties) => Duties(
              auth: app.auth,
              items: prevDuties == null ? [] : prevDuties.items),
        ),
        ChangeNotifierProvider.value(
          value: Commune(),
        ),
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<AppState, Consumables>(
          //Consumables
          builder: (ctx, app, prevCons) => Consumables(
              auth: app.auth, items: prevCons == null ? [] : prevCons.items),
        ),
      ],
      child: Consumer<AppState>(
        builder: (ctx, app, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CommuneIsm',
          theme: ThemeData(
            primarySwatch: Colors.grey,
            accentColor: Colors.deepOrange,
          ),
          home: app.isLoaded
              ? Dashboard()
              : FutureBuilder(
                  future: app.initApp(),
                  builder: (ctx, appResultSnapshot) =>
                      appResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? CircularProgressIndicator()
                          : WelcomeScreen(),
                ),
          routes: {
            CommuneOverview.routeName: (ctx) =>
                app.isLoaded ? CommuneOverview() : CircularProgressIndicator(),
            DutyScreen.routeName: (ctx) =>
                app.isLoaded ? DutyScreen() : CircularProgressIndicator(),
            ConsumablesScreen.routeName: (ctx) => app.isLoaded
                ? ConsumablesScreen()
                : CircularProgressIndicator(),
            EditDutyScreen.routeName: (ctx) =>
                app.isLoaded ? EditDutyScreen() : CircularProgressIndicator(),
            EditConsumableScreen.routeName: (ctx) => app.isLoaded
                ? EditConsumableScreen()
                : CircularProgressIndicator(),
            LoginScreen.routeName: (ctx) =>
                app.isLoaded ? Dashboard() : LoginScreen(),
            RegisterScreen.routeName: (ctx) =>
                app.isLoaded ? Dashboard() : RegisterScreen(),
            JoinScreen.routeName: (ctx) => JoinScreen(),
          },
        ),
      ),
    );
  }
}
