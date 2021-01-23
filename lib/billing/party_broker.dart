import 'package:Billing/billing/invoice.dart';
import 'package:Billing/billing/product_billing.dart';
import 'package:Billing/shared/loading.dart';
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
  String party, broker;
  List<String> partyList = [];
  List<String> brokerList = [];
  var firestore, firestoreB;

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
  TextEditingController brokerMobileContactInputController;
  bool _isEnabled;

  String email;
  String name = "";
  String office_address;
  String office_contact;
  String mobile_contact;
  String fssai;
  String gst;
  String broker_name = "";
  String broker_mobile_contact;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebasefunc();
  }

  Future<void> firebasefunc() async {
    firestore = FirebaseFirestore.instance
        .collection('Company')
        .doc(widget.email)
        .collection('Party Name');
    firestoreB = FirebaseFirestore.instance
        .collection('Company')
        .doc(widget.email)
        .collection('Broker');
    await firestore.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        partyList.add(result.data()['Name']);
        print(result.data()['Name']);
      });
    });
    await firestoreB.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        brokerList.add(result.data()['Name']);
        print(result.data()['Name']);
      });
    });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      'PARTY',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    DropDownField(
                      onValueChanged: (value) async {
                        //this is the value i select from the dpropdown
                        party = value;
                        name = party;
                        print(party);
                        await firestore
                            .doc(value)
                            .get()
                            .then((value2) => info = value2.data());
                        // i send that value to firebase...and retrieve the same value
                        print(info['Name']);
                        setState(() {
                          emailInputController =
                              TextEditingController(text: info['Email']);
                          nameInputController =
                              TextEditingController(text: info['Name']);
                          officeAddressInputController = TextEditingController(
                              text: info['Address']['Office']);
                          officeContactInputController = TextEditingController(
                              text: info['Contact']['Office']);
                          mobileContactInputController = TextEditingController(
                              text: info['Contact']['Mobile']);
                          fssaiInputController = TextEditingController(
                              text: info['Tax']['FSSAI No.']);
                          gstInputController = TextEditingController(
                              text: info['Tax']['GST No.']);
                          _isEnabled = false;
                          email = info['Email'];
                          name = info['Name'];
                          office_address = info['Address']['Office'];
                          office_contact = info['Contact']['Office'];
                          mobile_contact = info['Contact']['Mobile'];
                          fssai = info['Tax']['FSSAI No.'];
                          gst = info['Tax']['GST No.'];
                        });
                      },
                      value: party,
                      required: false,
                      hintText: 'Select Party',
                      labelText: 'Party',
                      items: partyList,
                    ),
                    // TextFormField(
                    //   // -----------------------COMMENT PARTY NAME AS ALREADY IN DROPDOWN--------------------------
                    //   decoration: InputDecoration(
                    //       labelText: "Party Name",
                    //       hintText: name,
                    //       floatingLabelBehavior: FloatingLabelBehavior.always,
                    //       labelStyle: TextStyle(color: Colors.black),
                    //       prefixIcon: Icon(
                    //         Icons.perm_identity,
                    //         color: Colors.blue[400],
                    //       )),
                    //   controller: nameInputController,
                    //   enabled: false,
                    //   style: TextStyle(color: Colors.black, fontSize: 17.0),
                    // ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Party Email",
                          hintText: email,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.blue[400],
                          )),
                      controller: emailInputController,
                      enabled: false,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Mobile Number",
                          hintText: mobile_contact,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.blue[400],
                          )),
                      controller: mobileContactInputController,
                      enabled: false,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Office Contact",
                          hintText: office_contact,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.blue[400],
                          )),
                      controller: officeContactInputController,
                      enabled: false,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Office Address",
                          hintText: office_address,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Colors.blue[400],
                          )),
                      controller: officeAddressInputController,
                      enabled: false,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "FSSAI",
                          hintText: fssai,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.account_balance_wallet,
                            color: Colors.blue[400],
                          )),
                      controller: fssaiInputController,
                      enabled: false,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "GST",
                          hintText: gst,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.account_balance_wallet,
                            color: Colors.blue[400],
                          )),
                      controller: gstInputController,
                      enabled: false,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      'BROKER',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    DropDownField(
                      onValueChanged: (value) async {
                        //this is the value i select from the dpropdown
                        broker = value;
                        print(broker);
                        await firestoreB
                            .doc(value)
                            .get()
                            .then((value2) => info = value2.data());
                        // i send that value to firebase...and retrieve the same value
                        print(info['Name']);
                        setState(() {
                          brokerMobileContactInputController =
                              TextEditingController(text: info['Mobile']);
                          _isEnabled = false;
                          broker_name = info['Name'];
                          broker_mobile_contact = info['Mobile'];
                        });
                      },
                      value: party,
                      required: false,
                      hintText: 'Select Broker',
                      labelText: 'Broker Name',
                      items: brokerList,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Mobile Number",
                          hintText: broker_mobile_contact,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.blue[400],
                          )),
                      controller: brokerMobileContactInputController,
                      enabled: false,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    RaisedButton(
                        child: Text(
                          'Next',
                          style: TextStyle(color: Colors.black54),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5),
                          side: BorderSide(color: Colors.black),
                        ),
                        padding: const EdgeInsets.all(20),
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                            return new Invoice(
                                email: widget.email,
                                partyName: name,
                                brokerName: broker_name);
                          }));
                        })
                  ],
                ),
              ),
            ),
          );
  }
}
