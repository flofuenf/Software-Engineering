import 'package:flutter/material.dart';

class JoinScreen extends StatelessWidget {
  static const routeName = "/join";
  @override
  Widget build(BuildContext context) {
    print("asdibasdsa");
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              Image.network(
                  "https://d338t8kmirgyke.cloudfront.net/icons/icon_pngs/000/000/859/original/login.png",
                  height: 200),
              SizedBox(height: 50),
              Text("JOIN HERE"),
            ],
          ),
        ),
      ),
    );
  }
}
