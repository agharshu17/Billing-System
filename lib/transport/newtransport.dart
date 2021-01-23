import 'package:Billing/screens/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Billing/services/database.dart';

class NewTransport extends StatefulWidget {
  final String email;
  const NewTransport({Key key, this.email}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<NewTransport> {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  var info = [];

  String error = '';

  String name = "";
  String vehicle = "";

  TextEditingController nameInputController;
  TextEditingController vehicleInputController;
  bool _iscreated;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseFuncToGetTransport();
  }

  Future<void> firebaseFuncToGetTransport() async {
    await FirebaseFirestore.instance
        .collection('Company')
        .doc(widget.email)
        .collection('Transport')
        .get()
        .then((querySnapshot) {
      setState(() {
        if (querySnapshot.docs.length == 0) {
          _iscreated = false;
        } else {
          _iscreated = true;
          querySnapshot.docs.forEach((result) {
            info.add(result.data());
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  top: 30, right: 30, left: 30, bottom: 100),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          name = value.toUpperCase();
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "Transport Name",
                          hintText: "Enter Transport Name Here",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.local_shipping,
                            color: Colors.blue[400],
                          )),
                      controller: nameInputController,
                      textCapitalization: TextCapitalization.characters,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    TextFormField(
                      validator: (val) {
                        if (_iscreated == true) {
                          print('------------');
                          for (var x in info) {
                            if (x['Vehicle No'].contains(vehicle)) {
                              print(x['Vehicle No']);
                              return "Vehicle Already Exists!";
                            }
                          }
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          vehicle = value.toUpperCase();
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "Vehicle Number",
                          hintText: "Enter Vehicle Number Here",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.label_important,
                            color: Colors.blue[400],
                          )),
                      controller: vehicleInputController,
                      textCapitalization: TextCapitalization.characters,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
            RaisedButton(
              child: Text(
                'Create Transport',
                style: TextStyle(color: Colors.black54),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5),
                side: BorderSide(color: Colors.black),
              ),
              padding: const EdgeInsets.all(20),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  Database(email: widget.email)
                      .createNewTransport(name, vehicle)
                      .then((value) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return new CustomDialogBox(
                              title: 'Successful!',
                              descriptions:
                                  'Your data has been successfully saved!',
                              text: 'OK');
                        });
                    setState(() {
                      nameInputController = new TextEditingController(text: "");
                      vehicleInputController =
                          new TextEditingController(text: "");
                      name = vehicle = "";
                    });
                  }).catchError((e) {
                    print(e);
                  });
                }
              },
              splashColor: Colors.grey,
            ),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
