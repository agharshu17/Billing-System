import 'dart:ffi';

import 'package:billing_system/services/database.dart';
import 'package:billing_system/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditExistingParty extends StatefulWidget {
  final String name, email;
  const EditExistingParty({Key key, this.name, this.email}) : super(key: key);
  @override
  _EditExistingPartyState createState() => _EditExistingPartyState();
}

class _EditExistingPartyState extends State<EditExistingParty> {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  bool loading = true;

  static var info;
  var icon = Icons.edit;

  String error = '';

  TextEditingController emailInputController;
  TextEditingController nameInputController;
  TextEditingController officeAddressInputController;
  TextEditingController officeContactInputController;
  TextEditingController mobileContactInputController;
  TextEditingController fssaiInputController;
  TextEditingController gstInputController;
  bool _isEnabled;

  String email;
  String name;
  String office_address;
  String office_contact;
  String mobile_contact;
  String fssai;
  String gst;

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
        .collection('Party Name')
        .doc(widget.name)
        .get()
        .then((value) => info = value.data());
    setState(() {
      emailInputController = TextEditingController(text: info['Email']);
      nameInputController = TextEditingController(text: info['Name']);
      officeAddressInputController =
          TextEditingController(text: info['Address']['Office']);
      officeContactInputController =
          TextEditingController(text: info['Contact']['Office']);
      mobileContactInputController =
          TextEditingController(text: info['Contact']['Mobile']);
      fssaiInputController =
          TextEditingController(text: info['Tax']['FSSAI No.']);
      gstInputController = TextEditingController(text: info['Tax']['GST No.']);
      _isEnabled = false;
      email = info['Email'];
      name = info['Name'];
      office_address = info['Address']['Office'];
      office_contact = info['Contact']['Office'];
      mobile_contact = info['Contact']['Mobile'];
      fssai = info['Tax']['FSSAI No.'];
      gst = info['Tax']['GST No.'];
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
            appBar: AppBar(
              title: const Center(child: Text('Party')),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
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
                                name = value;
                              });
                            },
                            decoration: InputDecoration(
                                labelText: "Party Name",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.perm_identity,
                                  color: Colors.blue[400],
                                )),
                            controller: nameInputController,
                            enabled: false,
                            style:
                                TextStyle(color: Colors.black, fontSize: 17.0),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            controller: emailInputController,
                            enabled: _isEnabled,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.blue[400],
                                ),
                                labelText: "Email ID",
                                hintText: "john.doe@gmail.com",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
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
                            enabled: _isEnabled,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone_android,
                                  color: Colors.blue[400],
                                ),
                                labelText: "Mobile Number",
                                hintText: "94XXXXXX12",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
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
                            enabled: _isEnabled,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone_android,
                                  color: Colors.blue[400],
                                ),
                                labelText: "Office Contact Number",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: "94XXXXXX12",
                                labelStyle: TextStyle(color: Colors.black)),
                            controller: officeContactInputController,
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
                            enabled: _isEnabled,
                            decoration: InputDecoration(
                                labelText: "Office Address",
                                hintText: "Name, Locality, City, Pincode",
                                labelStyle: TextStyle(color: Colors.black),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: Colors.blue[400],
                                )),
                            controller: officeAddressInputController,
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
                            enabled: _isEnabled,
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
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(color: Colors.black)),
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          TextFormField(
                            validator: (val) => val.length != 15
                                ? "Enter a 15 Digit GST Number"
                                : null,
                            controller: gstInputController,
                            enabled: _isEnabled,
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
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(color: Colors.black)),
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          SizedBox(
                            height: 50,
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
                        .createNewParty(name, email, office_address,
                            office_contact, mobile_contact, fssai, gst)
                        .then((value) => print('success'));
                  });
                }
              },
              child: Icon(icon),
              backgroundColor: Colors.blue,
            ),
          );
  }
}
