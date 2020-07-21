import 'package:CommuneIsm/models/consumable.dart';
import 'package:CommuneIsm/providers/app_state.dart';
import 'package:CommuneIsm/providers/consumables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConsumablesItem extends StatefulWidget {
  final Consumable consumable;

  ConsumablesItem({@required this.consumable});

  @override
  _ConsumablesItemState createState() => _ConsumablesItemState();
}

class _ConsumablesItemState extends State<ConsumablesItem> {
  void _deleteConsumable() async{
    try{
      String comID = Provider.of<AppState>(context, listen: false).commune.uid;
      await Provider.of<Consumables>(context, listen: false).deleteConsumable(widget.consumable.uid, comID);
    }catch(err){
      print(err);
    }
  }

  void _switchStatus() async {
    try {
      await Provider.of<Consumables>(context, listen: false)
          .switchStatus(widget.consumable.uid);
    } catch (err) {
      print(err);
    }
  }

  String buildNameOrder(){
    StringBuffer sb = StringBuffer();
    sb.write("Reihenfolge: ");
    int index = widget.consumable.rotationIndex;
    for(int i=index+1; i< widget.consumable.rotationList.length; i++){
      sb.write(widget.consumable.rotationList[i].name);
      if( i > index +1){
        sb.write(" --> ");
      }
    }

    for(int i=0; i < index; i++){
      sb.write(widget.consumable.rotationList[i].name);
      if(i < index-1){
        sb.write(" --> ");
      }
    }

    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('dd.MM.yyyy');
    return Card(
      elevation: 2,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                color: widget.consumable.isNeeded ? Colors.deepOrange : Colors.green,
                width: double.infinity,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 100, top: 10, right: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(widget.consumable.rotationList[widget.consumable.rotationIndex].name),
                      Text(widget.consumable.isNeeded ? "Kaufen" : ""),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 100, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(widget.consumable.name),
                        Text(
                            "Zuletzt gekauft am ${f.format(widget.consumable.lastBought)} von Flo"),
                      ],
                    ),
                    //Text("Rotation Time in Seconds: ${duty.rotationTime.toString()}"),
                    Text("Wird benötigt?: ${widget.consumable.isNeeded ? "Ja" : "Nein"}"),
                    //Text("Changed: ${duty.changed.toString()}"),
                    //Text("Index: ${duty.rotationIndex.toString()}"),
                    Text(buildNameOrder()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.edit),
                            padding: EdgeInsets.all(0),
                            iconSize: 20,
                            onPressed: () {
                              Navigator.of(context).pushNamed('/consumableEdit', arguments: widget.consumable);
                            }),
                        IconButton(
                            icon: Icon(Icons.delete),
                            padding: EdgeInsets.all(0),
                            iconSize: 20,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: new Text("Gegenstand löschen"),
                                      content:
                                      new Text("Bist du dir sicher, dass du diesen Gegenstand löschen möchtest?"),
                                      actions: <Widget>[
                                        new FlatButton(
                                          child: new Text("Sicher"),
                                          onPressed: () {
                                            _deleteConsumable();
                                            Navigator.of(context).pop();
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
                                  }
                              );
                            })
                      ],
                    ),
                    IconButton(
                        icon: widget.consumable.isNeeded ? Icon(Icons.hourglass_full) : Icon(Icons.new_releases),
                        padding: EdgeInsets.all(0),
                        iconSize: 20,
                        onPressed: _switchStatus),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.green,
              backgroundImage: NetworkImage(
                  "https://w7.pngwing.com/pngs/802/861/png-transparent-rage-comic-internet-meme-trollface-funny-face-comics-face-vertebrate.png"),
            ),
          ),
        ],
      ),
    );
  }
}
