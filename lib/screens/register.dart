import 'package:billing_system/screens/account_register.dart';
import 'package:billing_system/services/auth.dart';
import 'package:billing_system/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:billing_system/services/database.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  final AuthService _authService = AuthService();

  String error = '';
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  String email = "";
  String password = "";
  String name = "";
  String factory_address = "";
  String office_address = "";
  String factory_contact = "";
  String office_contact = "";
  String mobile_contact = "";
  String fssai = "";
  String gst = "";
  String tan = "";

  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  TextEditingController nameInputController;
  TextEditingController factoryAddressInputControler;
  TextEditingController officeAddressInputController;
  TextEditingController officeContactInputController;
  TextEditingController factoryContactInputController;
  TextEditingController mobileContactInputController;
  TextEditingController fssaiInputController;
  TextEditingController gstInputController;
  TextEditingController tanInputController;

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

  String confirmPwdValidator(String val) {
    if (val.isEmpty) return 'Empty';
    if (val != pwdInputController.text) return "Password Dosen't Match";
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      emailInputController = new TextEditingController();
      pwdInputController = new TextEditingController();
    });
  }

//---------------------CHANGE PASSWORD OPTION NEED TO BE ADDED---------------------
  // void _changePassword(String password) async {
  //   User user = await FirebaseAuth.instance.currentUser;
  //   user.updatePassword(password).then((_) {
  //     print("Successfully changed password.");
  //   }).catchError((e) {
  //     print("Password can't be changed" + e.toString());
  //   });
  // }

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
                            validator: (val) {
                              if (val.length < 3) {
                                return "Enter a Valid Company Name";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                            decoration: InputDecoration(
                                labelText: "Company Name",
                                hintText: "Gangasahai",
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.perm_identity,
                                  color: Colors.blue[400],
                                )),
                            controller: nameInputController,
                            style:
                                TextStyle(color: Colors.black, fontSize: 17.0),
                          ),
                          TextFormField(
                            validator: (val) => emailValidator(val),
                            controller: emailInputController,
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.blue[400],
                                ),
                                labelText: "Email ID",
                                hintText: "john.doe@gmail.com",
                                labelStyle: TextStyle(color: Colors.black)),
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            'Contact Details',
                            style: TextStyle(fontSize: 20),
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
                                labelText: "10 Digit Mobile Number",
                                hintText: "94XXXXXX12",
                                labelStyle: TextStyle(color: Colors.black)),
                            controller: mobileContactInputController,
                            keyboardType: TextInputType.number,
                            style:
                                TextStyle(color: Colors.black, fontSize: 17.0),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                office_contact = value;
                              });
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone_android,
                                  color: Colors.blue[400],
                                ),
                                labelText: "Office Contact Number",
                                hintText: "94XXXXXX12",
                                labelStyle: TextStyle(color: Colors.black)),
                            controller: officeContactInputController,
                            keyboardType: TextInputType.number,
                            style:
                                TextStyle(color: Colors.black, fontSize: 17.0),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                factory_contact = value;
                              });
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone_android,
                                  color: Colors.blue[400],
                                ),
                                labelText: "Factory Contact Number",
                                hintText: "94XXXXXX12",
                                labelStyle: TextStyle(color: Colors.black)),
                            controller: factoryContactInputController,
                            keyboardType: TextInputType.number,
                            style:
                                TextStyle(color: Colors.black, fontSize: 17.0),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            'Address Details',
                            style: TextStyle(fontSize: 20),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                office_address = value;
                              });
                            },
                            decoration: InputDecoration(
                                labelText: "Office Address",
                                hintText: "Name, Locality, City, Pincode",
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: Colors.blue[400],
                                )),
                            controller: officeAddressInputController,
                            style:
                                TextStyle(color: Colors.black, fontSize: 17.0),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                factory_address = value;
                              });
                            },
                            decoration: InputDecoration(
                                labelText: "Factory Address",
                                hintText: "Name, Locality, City, Pincode",
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: Colors.blue[400],
                                )),
                            controller: factoryAddressInputControler,
                            style:
                                TextStyle(color: Colors.black, fontSize: 17.0),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            'Tax',
                            style: TextStyle(fontSize: 20),
                          ),
                          TextFormField(
                            validator: (val) => val.length != 14
                                ? "Enter a 14 Digit FSSAI Number"
                                : null,
                            controller: fssaiInputController,
                            onChanged: (value) {
                              setState(() {
                                fssai = value;
                              });
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.blue[400],
                                ),
                                labelText: "FSSAI Number",
                                hintText: "xxxxxxxxxxxxxx",
                                labelStyle: TextStyle(color: Colors.black)),
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          TextFormField(
                            validator: (val) => val.length != 15
                                ? "Enter a 15 Digit GST Number"
                                : null,
                            controller: gstInputController,
                            onChanged: (value) {
                              setState(() {
                                gst = value;
                              });
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.blue[400],
                                ),
                                labelText: "GST Number",
                                hintText: "xxxxxxxxxxxxxxx",
                                labelStyle: TextStyle(color: Colors.black)),
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          TextFormField(
                            validator: (val) => val.length != 10
                                ? "Enter a 10 Digit TAN Number"
                                : null,
                            controller: tanInputController,
                            onChanged: (value) {
                              setState(() {
                                tan = value;
                              });
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.blue[400],
                                ),
                                labelText: "TAN Number",
                                hintText: "xxxxxxxxxx",
                                labelStyle: TextStyle(color: Colors.black)),
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            'Password',
                            style: TextStyle(fontSize: 20),
                          ),
                          TextFormField(
                            validator: (val) => pwdValidator(val),
                            controller: pwdInputController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blue[400],
                                ),
                                labelText: "Password",
                                hintText: "*********",
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
                                  ),
                                )),
                            style: TextStyle(color: Colors.black, fontSize: 17),
                            obscureText: !_showPassword,
                          ),
                          TextFormField(
                            validator: (val) => confirmPwdValidator(val),
                            controller: confirmPwdInputController,
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blue[400],
                                ),
                                labelText: "Confirm Password",
                                hintText: "*********",
                                labelStyle: TextStyle(color: Colors.black),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showConfirmPassword =
                                          !_showConfirmPassword;
                                    });
                                  },
                                  child: Icon(
                                    _showConfirmPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.blue[400],
                                  ),
                                )),
                            style: TextStyle(color: Colors.black, fontSize: 17),
                            obscureText: !_showConfirmPassword,
                          ),
                        ],
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.black54),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5),
                      side: BorderSide(color: Colors.black),
                    ),
                    padding: const EdgeInsets.all(20),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _authService
                            .registerWithEmailPassword(email, password);
                        if (result == null) {
                          setState(() {
                            error =
                                'User not registered. Please check the details!';
                            loading = false;
                          });
                        } else {
                          Database(email: email)
                              .storecompanyinfo(
                                  name,
                                  factory_address,
                                  office_address,
                                  factory_contact,
                                  office_contact,
                                  mobile_contact,
                                  fssai,
                                  gst,
                                  tan,
                                  context)
                              .then((value) {
                            Navigator.of(context).pop();

                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new AccountRegister(
                                email: email,
                              );
                            }));
                          }).catchError((e) {
                            print(e);
                          });
                        }
                      }
                    },
                    splashColor: Colors.grey,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  FlatButton(
                      color: Colors.white,
                      onPressed: () async {
                        Navigator.pushNamed(context, '/SignIn');
                      },
                      child: Text(
                        'Already Have An Account? Login Here!',
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
            ),
          );
  }
}
