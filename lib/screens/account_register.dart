import 'package:billing_system/screens/terms_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:billing_system/services/database.dart';

class AccountRegister extends StatefulWidget {
  final String email;

  const AccountRegister({Key key, this.email}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<AccountRegister> {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  bool loading = false;

  String error = '';
  String bankName = "";
  String accountNumber = "";
  String ifsc = "";

  TextEditingController bankNameInputController;
  TextEditingController accountNumberInputController;
  TextEditingController ifscInputController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
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
                          bankName = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "Bank Name",
                          hintText: "PNB",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.account_balance,
                            color: Colors.blue[400],
                          )),
                      controller: bankNameInputController,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    TextFormField(
                      controller: accountNumberInputController,
                      onChanged: (value) {
                        setState(() {
                          accountNumber = value;
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.branding_watermark,
                            color: Colors.blue[400],
                          ),
                          labelText: "Account Number",
                          hintText: "xxxxxxxxxx",
                          labelStyle: TextStyle(color: Colors.black)),
                      style: TextStyle(color: Colors.black, fontSize: 17),
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
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.branding_watermark,
                            color: Colors.blue[400],
                          ),
                          labelText: "IFSC Code",
                          hintText: "xxxxxxxxxxx",
                          labelStyle: TextStyle(color: Colors.black)),
                      controller: ifscInputController,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                  ],
                ),
              ),
            ),
            RaisedButton(
              child: Text(
                'Save',
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
                      .set({
                    "Bank": {
                      "Account No": accountNumber,
                      "Bank Name": bankName,
                      "IFSC Code": ifsc
                    }
                  }, SetOptions(merge: true)).then((value) {
                    Navigator.of(context).pop();

                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new TermsRegister(
                        email: widget.email,
                      );
                    }));
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
