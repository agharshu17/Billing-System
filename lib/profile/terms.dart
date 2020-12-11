import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:billing_system/services/database.dart';

class Terms extends StatefulWidget {
  final String email;
  const Terms({Key key, this.email}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Terms> {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  bool loading = false;

  static var info;
  var icon = Icons.edit;

  String error = '';
  String terms;

  TextEditingController termsInputController;
  bool _isEnabled;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('Company')
        .doc(widget.email)
        .get()
        .then((value) => info = value.data());
    termsInputController = TextEditingController(text: info['Description']);
    _isEnabled = false;

    terms = info['Description'];

    print("------------------------------------");
    print(info);
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
                          terms = value;
                        });
                      },
                      enabled: _isEnabled,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Terms & Conditions",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "Enter Here",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.subtitles,
                            color: Colors.blue[400],
                          )),
                      controller: termsInputController,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isEnabled == false) {
            setState(() {
              _isEnabled = true;
              icon = Icons.save;
              print('save');
            });
          } else if (_isEnabled == true) {
            setState(() {
              _isEnabled = false;
              icon = Icons.edit;
              print('edit');
              FirebaseFirestore.instance
                  .collection('Company')
                  .doc(widget.email)
                  .update({
                "Description": terms,
              }).then((value) => print('success'));
            });
          }
        },
        child: Icon(icon),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
