import 'package:Billing/services/database.dart';
import 'package:Billing/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditExistingBroker extends StatefulWidget {
  final String name, email;
  const EditExistingBroker({Key key, this.name, this.email}) : super(key: key);
  @override
  _EditExistingPartyState createState() => _EditExistingPartyState();
}

class _EditExistingPartyState extends State<EditExistingBroker> {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  bool loading = true;

  static var info;
  var icon = Icons.edit;

  String error = '';

  TextEditingController nameInputController;
  TextEditingController mobileContactInputController;
  bool _isEnabled;

  String name;
  String mobile_contact;

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
        .collection('Broker')
        .doc(widget.name)
        .get()
        .then((value) => info = value.data());
    setState(() {
      nameInputController = TextEditingController(text: info['Name']);
      mobileContactInputController =
          TextEditingController(text: info['Mobile']);
      _isEnabled = false;

      name = info['Name'];
      mobile_contact = info['Mobile'];
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
              title: const Center(child: Text('Broker')),
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
                                labelText: "Broker Name",
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
                        .createNewBroker(name, mobile_contact)
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
