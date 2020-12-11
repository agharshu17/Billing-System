import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Company extends StatefulWidget {
  final String email;
  const Company({Key key, this.email}) : super(key: key);

  @override
  _CompanyState createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  bool loading = false;

  static var info;
  var icon = Icons.edit;

  String error = '';

  TextEditingController emailInputController;
  TextEditingController nameInputController;
  TextEditingController factoryAddressInputControler;
  TextEditingController officeAddressInputController;
  TextEditingController officeContactInputController;
  TextEditingController factoryContactInputController;
  TextEditingController mobileContactInputController;
  TextEditingController fssaiInputController;
  TextEditingController gstInputController;
  TextEditingController tanInputController;
  bool _isEnabled;

  String email;
  String name;
  String factory_address;
  String office_address;
  String factory_contact;
  String office_contact;
  String mobile_contact;
  String fssai;
  String gst;
  String tan;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('------------');
    print(widget.email);
    FirebaseFirestore.instance
        .collection('Company')
        .doc(widget.email)
        .get()
        .then((value) => info = value.data());
    emailInputController = TextEditingController(text: info['Email']);
    nameInputController = TextEditingController(text: info['Name']);
    factoryAddressInputControler =
        TextEditingController(text: info['Address']['Factory']);
    officeAddressInputController =
        TextEditingController(text: info['Address']['Office']);
    officeContactInputController =
        TextEditingController(text: info['Contact']['Office']);
    factoryContactInputController =
        TextEditingController(text: info['Contact']['Factory']);
    mobileContactInputController =
        TextEditingController(text: info['Contact']['Mobile']);
    fssaiInputController =
        TextEditingController(text: info['Tax']['FSSAI No.']);
    gstInputController = TextEditingController(text: info['Tax']['GST No.']);
    tanInputController = TextEditingController(text: info['Tax']['TAN No.']);
    _isEnabled = false;

    email = info['Email'];
    name = info['Name'];
    factory_address = info['Address']['Factory'];
    office_address = info['Address']['Office'];
    factory_contact = info['Contact']['Factory'];
    office_contact = info['Contact']['Office'];
    mobile_contact = info['Contact']['Mobile'];
    fssai = info['Tax']['FSSAI No.'];
    gst = info['Tax']['GST No.'];
    tan = info['Tax']['TAN No.'];

    print(info['Email']);
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
                      controller: emailInputController,
                      enabled: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.blue[400],
                          ),
                          labelText: "Email ID",
                          hintText: "john.doe@gmail.com",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: Colors.black)),
                      style: TextStyle(color: Colors.black, fontSize: 17),
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: Colors.blue[400],
                          )),
                      controller: nameInputController,
                      enabled: _isEnabled,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                      enabled: _isEnabled,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.blue[400],
                          ),
                          labelText: "Office Contact Number",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "94XXXXXX12",
                          labelStyle: TextStyle(color: Colors.black)),
                      controller: officeContactInputController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          factory_contact = value;
                        });
                      },
                      enabled: _isEnabled,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: Colors.blue[400],
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "Factory Contact Number",
                          hintText: "94XXXXXX12",
                          labelStyle: TextStyle(color: Colors.black)),
                      controller: factoryContactInputController,
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
                      enabled: _isEnabled,
                      decoration: InputDecoration(
                          labelText: "Office Address",
                          hintText: "Name, Locality, City, Pincode",
                          labelStyle: TextStyle(color: Colors.black),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Colors.blue[400],
                          )),
                      controller: officeAddressInputController,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          factory_address = value;
                        });
                      },
                      enabled: _isEnabled,
                      decoration: InputDecoration(
                          labelText: "Factory Address",
                          hintText: "Name, Locality, City, Pincode",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Colors.blue[400],
                          )),
                      controller: factoryAddressInputControler,
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: Colors.black)),
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                    TextFormField(
                      validator: (val) => val.length != 10
                          ? "Enter a 10 Digit TAN Number"
                          : null,
                      controller: tanInputController,
                      enabled: _isEnabled,
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "xxxxxxxxxx",
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
              FirebaseFirestore.instance
                  .collection('Company')
                  .doc(widget.email)
                  .update({
                "Name": name,
                "Address": {
                  "Office": office_address,
                  "Factory": factory_address
                },
                "Contact": {
                  "Mobile": mobile_contact,
                  "Office": office_contact,
                  "Factory": factory_contact
                },
                "Email": email,
                "Tax": {"GST No.": gst, "FSSAI No.": fssai, "TAN No.": tan}
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
