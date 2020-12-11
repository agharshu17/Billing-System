import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:billing_system/services/database.dart';

class SignIn extends StatefulWidget {
  @override
  _SignINState createState() => _SignINState();
}

class _SignINState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool flag = false;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String error = '';
  bool _showPassword = false;
  String email = " ";
  String password = " ";

  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();

    super.initState();
    Firebase.initializeApp();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter an Email';
    } else if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 6 && value.length > 1) {
      return 'Password must be longer than 6 characters';
    } else if (value.isEmpty) {
      return 'Please enter the password';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        top: 150, right: 50, left: 50, bottom: 150),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            validator: (val) => emailValidator(val),
                            controller: emailInputController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.blue[400],
                                ),
                                labelText: "Email ID",
                                hintText: "john.doe@gmail.com",
                                labelStyle: TextStyle(color: Colors.black)),
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            onChanged: (value) => {
                              setState(() {
                                password = value;
                              })
                            },
                            controller: pwdInputController,
                            validator: (val) => pwdValidator(val),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.blue[400],
                              ),
                              labelText: "Password",
                              hintText: "********",
                              labelStyle: TextStyle(color: Colors.black),
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                  child: Icon(
                                    _showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.blue[400],
                                  )),
                            ),
                            obscureText: !_showPassword,
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          RaisedButton(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                side: BorderSide(color: Colors.black),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: email, password: password)
                                      .then((user) async {
                                    if (user != null) {
                                      flag = true;
                                      Navigator.of(context).pushNamed('/Home');
                                    }
                                  }).catchError((e) {
                                    print(e);
                                  });
                                }
                                if (flag == false) {
                                  print('invalid');
                                  Text('Invalid Login Credential',
                                      style: TextStyle(color: Colors.black));
                                }
                              },
                              splashColor: Colors.grey),
                          FlatButton(
                            color: Colors.white,
                            child: Text(
                              'Not a Member Yet? Sign Up Here.',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () async {
                              Navigator.pushNamed(context, '/Register');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
