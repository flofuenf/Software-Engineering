import 'package:CommuneIsm/models/address.dart';
import 'package:CommuneIsm/providers/app_state.dart';
import 'package:CommuneIsm/providers/commune.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateCommuneScreen extends StatelessWidget {
  static const routeName = "/createCommune";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.network("https://img.icons8.com/pastel-glyph/2x/home.png",
                    height: 200),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: 400,
                  child: Center(
                    child: CreateForm(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateForm extends StatefulWidget {
  const CreateForm({
    Key key,
  }) : super(key: key);

  @override
  _CreateFormState createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final GlobalKey<FormState> _createFormKey = GlobalKey();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _streetController = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();

  bool _isLoading = false;

  void _submit() async {
    if (!_createFormKey.currentState.validate()) {
      return;
    }
    _createFormKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    final Commune commune = new Commune(
      name: _nameController.text,
      description: _descriptionController.text,
      address: new Address(
        street: _streetController.text,
        city: _cityController.text,
        zip: _zipController.text,
      ),
    );

    try{
      await Provider.of<AppState>(context, listen: false).createCommune(commune);
      Navigator.of(context).pop();
    }catch(err){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Erstellen fehlgeschlagen"),
            content: Text(err),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Schade..."),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _createFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
              ),
              labelText: "Name der Wohngemeinschaft",
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              contentPadding: EdgeInsets.all(10),
              fillColor: Colors.blueGrey,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 5,
                  right: 15,
                  bottom: 0,
                ),
                child: Icon(
                  Icons.chat_bubble,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return "Bitte gib einen Namen ein";
              }
              return null;
            },
          ),
          TextFormField(
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            controller: _descriptionController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              errorStyle: TextStyle(color: Theme.of(context).errorColor),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
              ),
              labelText: "Beschreibung",
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              contentPadding: EdgeInsets.all(10),
              fillColor: Colors.blueGrey,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 5,
                  right: 15,
                  bottom: 0,
                ),
                child: Icon(
                  Icons.description,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return "Bitte gib eine Beschreibung ein";
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _streetController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
              ),
              labelText: "Straße & Haus Nr.",
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              contentPadding: EdgeInsets.all(10),
              fillColor: Colors.blueGrey,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 5,
                  right: 15,
                  bottom: 0,
                ),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return "Bitte gib eine Adresse ein";
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _zipController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
              ),
              labelText: "Postleitzahl",
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              contentPadding: EdgeInsets.all(10),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 5,
                  right: 15,
                  bottom: 0,
                ),
                child: Icon(
                  Icons.flag,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return "Bitte gib eine Postleitzahl ein";
              }
              if(value.length < 5){
                return "Bitte gib eine gültige Postleitzahl ein";
              }
              if (double.tryParse(value) == null) {
                return "Nur Zahlen erlaubt";
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _cityController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.white,
                ),
              ),
              labelText: "Stadt",
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              contentPadding: EdgeInsets.all(10),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 5,
                  right: 15,
                  bottom: 0,
                ),
                child: Icon(
                  Icons.location_city,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return "Bitte gib eine Stadt ein";
              }
              return null;
            },
          ),
          SizedBox(
            height: 30,
          ),
          _isLoading
              ? CircularProgressIndicator()
              : RaisedButton(
                  onPressed: () {
                    _submit();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Wohngemeinschaft Erstellen"),
                  ),
                )
        ],
      ),
    );
  }
}
