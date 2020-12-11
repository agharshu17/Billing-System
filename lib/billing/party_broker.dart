import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';

class PartyBroker extends StatefulWidget {
  final String email;

  const PartyBroker({Key key, this.email}) : super(key: key);

  @override
  _PartyBrokerState createState() => _PartyBrokerState();
}

class _PartyBrokerState extends State<PartyBroker> {
  String party;
  List<String> partyList = [];
  var firestore;

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
    firestore = FirebaseFirestore.instance
        .collection('Company')
        .doc(widget.email)
        .collection('Party Name');
    firestore.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        partyList.add(result.data()['Name']);
        print(result.data()['Name']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Billing",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DropDownField(
              onValueChanged: (value) {
                //this is the value i select from the dpropdown
                party = value;
                print(party);
                firestore
                    .doc(value)
                    .get()
                    .then((value2) => info = value2.data());
                // i send that value to firebase...and retrieve the same value
                print(info['Name']);

                emailInputController =
                    TextEditingController(text: info['Email']);
                nameInputController = TextEditingController(text: info['Name']);
                officeAddressInputController =
                    TextEditingController(text: info['Address']['Office']);
                officeContactInputController =
                    TextEditingController(text: info['Contact']['Office']);
                mobileContactInputController =
                    TextEditingController(text: info['Contact']['Mobile']);
                fssaiInputController =
                    TextEditingController(text: info['Tax']['FSSAI No.']);
                gstInputController =
                    TextEditingController(text: info['Tax']['GST No.']);
                _isEnabled = false;
                email = info['Email'];
                name = info['Name'];
                office_address = info['Address']['Office'];
                office_contact = info['Contact']['Office'];
                mobile_contact = info['Contact']['Mobile'];
                fssai = info['Tax']['FSSAI No.'];
                gst = info['Tax']['GST No.'];
              },
              value: party,
              required: false,
              hintText: 'Select Party',
              labelText: 'Party',
              items: partyList,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Party Name",
                  hintText: name,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(
                    Icons.perm_identity,
                    color: Colors.blue[400],
                  )),
              controller: nameInputController,
              enabled: false,
              style: TextStyle(color: Colors.black, fontSize: 17.0),
            ),
          ],
        ),
      ),
    );
  }
}
