import 'package:CommuneIsm/providers/app_state.dart';
import 'package:CommuneIsm/screens/login/welcome_screen.dart';
import 'package:CommuneIsm/widgets/menu_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CommuneOverview extends StatelessWidget {
  static const routeName = "/overview";

  @override
  Widget build(BuildContext context) {
    void _toClipboard(String str) async {
      await Clipboard.setData(ClipboardData(text: str));
      Navigator.of(context).pop();
    }

    void _leave() async{
      await Provider.of<AppState>(context).leaveCommune();
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Commune"),
      ),
      drawer: MenuDrawer(),
      body: Consumer<AppState>(
        builder: (ctx, app, _) => Column(
          children: <Widget>[
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Übersicht"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Name der WG:"),
                        Text(app.commune.name),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Beschreibung:"),
                        Text(app.commune.description),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Adresse:"),
                        Text("${app.commune.address.street}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                            "${app.commune.address.zip} ${app.commune.address.city}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Mitglieder",
                        textAlign: TextAlign.center,
                      ),
                      Column(
                        children: app.commune.members
                            .map((e) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(e.name),
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                          "https://w7.pngwing.com/pngs/802/861/png-transparent-rage-comic-internet-meme-trollface-funny-face-comics-face-vertebrate.png"),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Einladungslink"),
                                content:
                                    Text("Lade deine Freunde in die WG ein!"),
                                actions: <Widget>[
                                  !kIsWeb
                                      ? IconButton(
                                          icon:
                                              FaIcon(FontAwesomeIcons.whatsapp),
                                          onPressed: () {
                                            FlutterShareMe().shareToWhatsApp(
                                                msg:
                                                    "Tritt meiner WG bei. Dein Code: ${app.comID}");
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      : SizedBox.shrink(),
                                  IconButton(
                                    icon: Icon(Icons.content_copy),
                                    onPressed: () {
                                      _toClipboard(app.comID);
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Text("Einladung-Code versenden"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("Austritt aus WG"),
                                content: new Text(
                                    "Bist du dir sicher, dass du aus dieser WG austreten möchtest?"),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text("Sicher"),
                                    onPressed: () {
                                      _leave();
                                    },
                                  ),
                                  new FlatButton(
                                    child: new Text("Lieber nicht..."),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Text("Aus WG austreten"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
