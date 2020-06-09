import 'package:CommuneIsm/providers/app_state.dart';
import 'package:CommuneIsm/providers/consumables.dart';
import 'package:CommuneIsm/widgets/consumables_item.dart';
import 'package:provider/provider.dart';

import '../widgets/menu_drawer.dart';
import 'package:flutter/material.dart';

class ConsumablesScreen extends StatefulWidget {
  static const routeName = "/consumables";

  @override
  _ConsumablesScreenState createState() => _ConsumablesScreenState();
}

class _ConsumablesScreenState extends State<ConsumablesScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  void _fetchConsumables() async {
    try {
      String comID = Provider.of<AppState>(context, listen: false).comID;
      await Provider.of<Consumables>(context, listen: false).fetchConsumables(comID);
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
      _fetchConsumables();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var consumables = Provider.of<Consumables>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Gegenstände"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () {
                  Navigator.of(context).pushNamed('/consumableEdit');
                }),
          ],
        ),
        drawer: MenuDrawer(),
        body: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Center(
          child: consumables.list != null
              ? ListView.builder(
            itemCount: consumables.list.length,
            itemBuilder: ((ctx, i) => ConsumablesItem(
              consumable: consumables.list[i],
            )),
          )
              : Text("No Duties"),
        ),
    );
  }
}
