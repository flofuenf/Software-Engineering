import 'package:CommuneIsm/providers/app_state.dart';
import 'package:CommuneIsm/providers/duties.dart';
import 'package:provider/provider.dart';

import '../widgets/menu_drawer.dart';
import 'package:flutter/material.dart';

class DutyScreen extends StatefulWidget {
  static const routeName = "/duties";

  @override
  _DutyScreenState createState() => _DutyScreenState();
}

class _DutyScreenState extends State<DutyScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  void _fetchDuties() async {
    try {
      String comID = Provider.of<AppState>(context, listen: false).comID;
      await Provider.of<Duties>(context).fetchDuties(comID);
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _fetchDuties();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var duties = Provider.of<Duties>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Putzdienste"),
      ),
      drawer: MenuDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: duties.list != null
                  ? ListView.builder(
                      itemCount: duties.list.length,
                      itemBuilder: ((ctx, i) => Card(
                            elevation: 2,
                            child: Column(
                              children: <Widget>[
                                Text(duties.list[i].name),
                                Text(duties.list[i].description),
                                Text(
                                    "Rotation Time in Seconds: ${duties.list[i].rotationTime.toString()}"),
                                Text(
                                    "Last Done: ${duties.list[i].lastDone.toString()}"),
                                Text(
                                    "Next Done: ${duties.list[i].nextDone.toString()}"),
                                Text(
                                    "Created: ${duties.list[i].created.toString()}"),
                                Text(
                                    "Changed: ${duties.list[i].changed.toString()}"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: duties.list[i].rotationList
                                      .map((rot) => Text("List: ${rot.name}"))
                                      .toList(),
                                ),

//                                    Text(
//                                        "List: ${duties.list[i].rotationList.toString()}"),
                              ],
                            ),
                          )),
                    )
                  : Text("No Duties"),
            ),
    );
  }
}
