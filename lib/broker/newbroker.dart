import 'package:billing_system/screens/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:billing_system/services/database.dart';

class NewBroker extends StatefulWidget {
  final String email;
  const NewBroker({Key key, this.email}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<NewBroker> {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  var info = [];

  String error = '';

  String name = "";
  String mobile_contact = "";

  TextEditingController nameInputController;
  TextEditingController mobileContactInputController;
  bool _iscreated;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection('Company')
        .doc(widget.email)
        .collection('Broker')
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.length == 0) {
        _iscreated = false;
      } else {
        _iscreated = true;
        querySnapshot.docs.forEach((result) {
          info.add(result.data());
        });
      }
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
                      validator: (val) {
                        if (_iscreated == true) {
                          for (var x in info) {
                            if (x['Name'] == name) {
                              print(x['Name']);
                              return "Broker Already Exists!";
                            }
                          }
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "Broker Name",
                          hintText: "Enter Broker Name Here",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: Colors.blue[400],
                          )),
                      controller: nameInputController,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    TextFormField(
                      validator: (val) => val.length != 10
                          ? "Enter a 10 Digit Mobile Number"
                          : null,
                      onChanged: (value) {
                        setState(() {
                          mobile_contact = value;
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.blue[400],
                          ),
                          labelText: "Mobile Number",
                          hintText: "94XXXXXX12",
                          labelStyle: TextStyle(color: Colors.black)),
                      controller: mobileContactInputController,
                      keyboardType: TextInputType.number,
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
                'Create Broker',
                style: TextStyle(color: Colors.black54),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5),
                side: BorderSide(color: Colors.black),
              ),
              padding: const EdgeInsets.all(20),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  FirebaseFirestore.instance
                      .collection('Company')
                      .doc(widget.email)
                      .collection('Broker')
                      .doc(name)
                      .set({
                    "Name": name,
                    "Mobile": mobile_contact,
                  }, SetOptions(merge: true)).then((value) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return new CustomDialogBox(
                              title: 'Successful!',
                              descriptions:
                                  'Your data has been successfully saved!',
                              text: 'OK');
                        });

                    nameInputController = new TextEditingController(text: "");
                    mobileContactInputController =
                        new TextEditingController(text: "");
                    name = mobile_contact = "";
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
