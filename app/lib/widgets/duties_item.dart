import 'package:CommuneIsm/models/duty.dart';
import 'package:CommuneIsm/providers/duties.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DutiesItem extends StatefulWidget {
  final Duty duty;

  DutiesItem({@required this.duty});

  @override
  _DutiesItemState createState() => _DutiesItemState();
}

class _DutiesItemState extends State<DutiesItem> {
  void _setAsDone() async {
    try {
      await Provider.of<Duties>(context, listen: false)
          .setDone(widget.duty.uid);
    } catch (err) {
      print(err);
    }
  }

  String buildNameOrder(){
    StringBuffer sb = StringBuffer();
    sb.write("Reihenfolge: ");
    int index = widget.duty.rotationIndex;
    for(int i=index+1; i< widget.duty.rotationList.length; i++){
      sb.write(widget.duty.rotationList[i].name);
      if( i > index +1){
        sb.write(" --> ");
      }
    }

    for(int i=0; i < index; i++){
      sb.write(widget.duty.rotationList[i].name);
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
                color: Colors.deepOrange,
                width: double.infinity,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 100, top: 10, right: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(widget.duty.rotationList[widget.duty.rotationIndex].name),
                      Text("In 3 Tagen"),
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
                        Text(widget.duty.name),
                        Text(
                            "Zuletzt erledigt am ${f.format(widget.duty.lastDone)} von Flo"),
                      ],
                    ),
                    Text(widget.duty.description),
                    //Text("Rotation Time in Seconds: ${duty.rotationTime.toString()}"),
                    Text("Fällig am: ${f.format(widget.duty.nextDone)}"),
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
                    IconButton(
                        icon: Icon(Icons.edit),
                        padding: EdgeInsets.all(0),
                        iconSize: 20,
                        onPressed: () {
                          Navigator.of(context).pushNamed('/dutyedit');
                        }),
                    IconButton(
                        icon: Icon(Icons.check),
                        padding: EdgeInsets.all(0),
                        iconSize: 20,
                        onPressed: _setAsDone),
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
