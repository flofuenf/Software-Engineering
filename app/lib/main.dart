import 'package:CommuneIsm/providers/auth.dart';
import 'package:CommuneIsm/providers/consumables.dart';
import 'package:CommuneIsm/providers/duties.dart';
import 'package:CommuneIsm/screens/edit_duty_screen.dart';
import 'package:CommuneIsm/screens/login/join_screen.dart';
import 'package:CommuneIsm/screens/login/login_screen.dart';
import 'package:CommuneIsm/screens/login/welcome_screen.dart';

import 'providers/app_state.dart';
import 'providers/commune.dart';
import 'providers/user.dart';
import 'screens/consumables_screen.dart';
import 'screens/dashboard.dart';
import 'screens/debug.dart';
import 'screens/duties_screen.dart';
import 'screens/edit_consumable_screen.dart';
import 'screens/commune_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/dashboard.dart';
import 'screens/login/login_screen.dart';
import 'screens/login/register_screen.dart';
import 'screens/login/welcome_screen.dart';
import 'screens/login/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class CommuneFuture extends StatelessWidget {
  final AppState app;
  final String comId;

  const CommuneFuture({Key key, this.app, this.comId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("com future");
    return FutureBuilder<Commune>(
      future: app.fetchCommune(comId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            //commune ok
            return Dashboard();
          } else {
            //no commune
            return Error();
          }
        }
        return Loading();
      },
    );
  }
}

class UserFuture extends StatelessWidget {
  final String userId;
  final AppState app;

  const UserFuture({Key key, this.userId, this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: app.fetchUser(userId),
      builder: (context, snapshot) {
        print("builder");
        if (snapshot.connectionState == ConnectionState.done) {
          print("done");
          if (snapshot.data != null && snapshot.data.communeID != "") {
            print("got ID");
            //user ok
            return CommuneFuture(
              app: app,
              comId: snapshot.data.communeID,
            );
          } else {
            print("penis");
            //no user
            return JoinScreen();
          }
        }
        return Loading();
      },
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Internal Error"));
  }
}

class AuthFuture extends StatelessWidget {
  final AppState app;

  const AuthFuture({Key key, this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Auth>(
      future: app.loadApp(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            //auth ok
            return UserFuture(
              app: app,
              userId: snapshot.data.userID,
            );
          } else {
            //no auth
            return WelcomeScreen();
          }
        } else {
          return Loading();
        }
      },
    );
  }
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
          home: AuthFuture(app: app),
          routes: {
            DebugScreen.routeName: (ctx) => DebugScreen(),
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
