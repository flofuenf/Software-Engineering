import 'package:CommuneIsm/providers/app_state.dart';
import 'package:CommuneIsm/providers/duties.dart';
import 'package:CommuneIsm/widgets/duties_item.dart';
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
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                Navigator.of(context).pushNamed('/dutyedit');
              }),
        ],
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
                      itemBuilder: ((ctx, i) => DutiesItem(
                            duty: duties.list[i],
                          )),
                    )
                  : Text("No Duties"),
            ),
    );
  }
}
