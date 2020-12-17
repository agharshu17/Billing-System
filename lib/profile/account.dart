import 'package:billing_system/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:billing_system/services/database.dart';

class Account extends StatefulWidget {
  final String email;
  const Account({Key key, this.email}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  bool loading = true;

  static var info;
  var icon = Icons.edit;

  String error = '';

  TextEditingController bankNameInputController;
  TextEditingController accountInputController;
  TextEditingController ifscInputController;
  bool _isEnabled;

  String bankName;
  String account;
  String ifsc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseFunc();
  }

  Future<void> firebaseFunc() async {
    await FirebaseFirestore.instance
        .collection('Company')
        .doc(widget.email)
        .get()
        .then((value) => info = value.data());
    setState(() {
      bankNameInputController =
          TextEditingController(text: info['Bank']['Bank Name']);
      accountInputController =
          TextEditingController(text: info['Bank']['Account No']);
      ifscInputController =
          TextEditingController(text: info['Bank']['IFSC Code']);
      _isEnabled = false;

      bankName = info['Bank']['Bank Name'];
      account = info['Bank']['Account No'];
      ifsc = info['Bank']['IFSC Code'];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
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
                            controller: bankNameInputController,
                            enabled: _isEnabled,
                            onChanged: (value) {
                              setState(() {
                                bankName = value;
                              });
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_balance,
                                  color: Colors.blue[400],
                                ),
                                labelText: "Bank Name",
                                hintText: "PNB",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(color: Colors.black)),
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          TextFormField(
                            controller: accountInputController,
                            onChanged: (value) {
                              setState(() {
                                account = value;
                              });
                            },
                            decoration: InputDecoration(
                                labelText: "Account Number",
                                hintText: "xxxxxxxxx",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.branding_watermark,
                                  color: Colors.blue[400],
                                )),
                            enabled: _isEnabled,
                            style:
                                TextStyle(color: Colors.black, fontSize: 17.0),
                          ),
                          TextFormField(
                            validator: (val) => val.length != 11
                                ? "Enter a 11 Digit IFSC Code"
                                : null,
                            onChanged: (value) {
                              setState(() {
                                ifsc = value;
                              });
                            },
                            enabled: _isEnabled,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.branding_watermark,
                                  color: Colors.blue[400],
                                ),
                                labelText: "IFSC Code",
                                hintText: "xxxxxxxxxxx",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(color: Colors.black)),
                            controller: ifscInputController,
                            style:
                                TextStyle(color: Colors.black, fontSize: 17.0),
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
                    Database(email: widget.email)
                        .updateAccount(account, bankName, ifsc);
                  });
                }
              },
              child: Icon(icon),
              backgroundColor: Colors.blue,
            ),
          );
  }
}
