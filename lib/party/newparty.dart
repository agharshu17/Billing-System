import 'package:Billing/screens/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Billing/services/database.dart';

class NewParty extends StatefulWidget {
  final String email;
  const NewParty({Key key, this.email}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<NewParty> {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  var info = [];

  String error = '';

  String email = "";
  String name = "";
  String office_address = "";
  String office_contact = "";
  String mobile_contact = "";
  String fssai = "";
  String gst = "";
  String state = "";
  String stateCode = "";

  TextEditingController emailInputController;
  TextEditingController nameInputController;
  TextEditingController officeAddressInputController;
  TextEditingController officeContactInputController;
  TextEditingController mobileContactInputController;
  TextEditingController fssaiInputController;
  TextEditingController gstInputController;
  TextEditingController stateInputController;
  TextEditingController stateCodeInputController;
  bool _iscreated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseFunctToGetAllParties();
  }

  Future<void> firebaseFunctToGetAllParties() async {
    await FirebaseFirestore.instance
        .collection('Company')
        .doc(widget.email)
        .collection('Party Name')
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
                      validator: (val) {
                        if (_iscreated == true) {
                          for (var x in info) {
                            if (x['Name'] == name) {
                              print(x['Name']);
                              return "Party Already Exists!";
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
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                          labelText: "Party Name",
                          hintText: "Enter Party Name Here",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: Colors.blue[400],
                          )),
                      controller: nameInputController,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    TextFormField(
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
                          labelText: "Mobile Number",
                          hintText: "94XXXXXX12",
                          labelStyle: TextStyle(color: Colors.black)),
                      controller: mobileContactInputController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
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
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
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
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'State Details',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          state = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "State",
                          hintText: "",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Colors.blue[400],
                          )),
                      controller: stateInputController,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          stateCode = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "State Code",
                          hintText: "15",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Colors.blue[400],
                          )),
                      controller: stateCodeInputController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
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
                      textCapitalization: TextCapitalization.characters,
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
                      textCapitalization: TextCapitalization.characters,
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
                    SizedBox(
                      height: 50,
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
                'Create Party',
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
                      .createNewParty(
                          name,
                          email,
                          office_address,
                          office_contact,
                          mobile_contact,
                          state,
                          stateCode,
                          fssai,
                          gst)
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
                      emailInputController =
                          new TextEditingController(text: "");
                      officeAddressInputController =
                          new TextEditingController(text: "");
                      mobileContactInputController =
                          new TextEditingController(text: "");
                      officeContactInputController =
                          new TextEditingController(text: "");
                      fssaiInputController =
                          new TextEditingController(text: "");
                      gstInputController = new TextEditingController(text: "");
                      stateInputController =
                          new TextEditingController(text: "");
                      stateCodeInputController =
                          new TextEditingController(text: "");
                      name = email = office_address = mobile_contact =
                          office_contact = state = stateCode = fssai = gst = "";
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
