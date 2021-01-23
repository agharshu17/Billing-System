import 'package:Billing/services/database.dart';
import 'package:Billing/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditExistingTransport extends StatefulWidget {
  final String name, email;
  const EditExistingTransport({Key key, this.name, this.email})
      : super(key: key);
  @override
  _EditExistingPartyState createState() => _EditExistingPartyState();
}

class _EditExistingPartyState extends State<EditExistingTransport> {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  bool loading = true;

  static var info;
  var icon = Icons.edit;

  String error = '';
  var brand = {};
  var brandlist = [];
  var brandremove = [];

  TextEditingController nameInputController;
  Map<String, TextEditingController> brandInputController = {};
  bool _isEnabled;

  String name;
  var textFileds = <TextField>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseFunct();
  }

  Future<void> firebaseFunct() async {
    await FirebaseFirestore.instance
        .collection('Company')
        .doc(widget.email)
        .collection('Transport')
        .doc(widget.name)
        .get()
        .then((value) => info = value.data());
    setState(() {
      nameInputController = TextEditingController(text: info['Name']);

      info['Vehicle No'].forEach((str) {
        var textEditingController = TextEditingController(text: str);
        brand[str] = str;
        brandInputController.putIfAbsent(str, () => textEditingController);
        textFileds.add(TextField(
          controller: textEditingController,
        ));
      });
      _isEnabled = false;

      name = info['Name'];
      for (var x in brand.values) {
        brandlist.add(x);
      }
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
              title: const Center(child: Text('Transport')),
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
                                labelText: "Transport Name",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.local_shipping,
                                  color: Colors.blue[400],
                                )),
                            controller: nameInputController,
                            enabled: false,
                            style:
                                TextStyle(color: Colors.black, fontSize: 17.0),
                          ),
                          for (String key in brandInputController.keys)
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  brandremove.add(brand[key]);
                                  brandlist.remove(brand[key]);
                                  brand[key] = value;
                                  if (brand[key] != "")
                                    brandlist.add(brand[key].toUpperCase());
                                });
                              },
                              decoration: InputDecoration(
                                  labelText: "Vehicle Number",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(color: Colors.black),
                                  prefixIcon: Icon(
                                    Icons.label_important,
                                    color: Colors.blue[400],
                                  )),
                              controller: brandInputController[key],
                              enabled: _isEnabled,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 17.0),
                            )
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
                        .editTransport(name, brandremove, brandlist)
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
