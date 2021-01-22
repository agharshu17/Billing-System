import 'package:billing_system/services/database.dart';
import 'package:billing_system/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditExistingProduct extends StatefulWidget {
  final String name, email;
  const EditExistingProduct({Key key, this.name, this.email}) : super(key: key);
  @override
  _EditExistingPartyState createState() => _EditExistingPartyState();
}

class _EditExistingPartyState extends State<EditExistingProduct> {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  bool loading = true;

  static var info;
  var icon = Icons.edit;

  String error = '';
  var storeValue = "";
  var brand = {};
  var brandlist = {};
  var brandremove = {};
  var keyOnTap = "";

  TextEditingController nameInputController;
  Map<TextEditingController, TextEditingController> brandInputController = {};
  bool _isEnabled;

  String name;
  var textFileds = <TextField, TextField>{};

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
        .collection('Product')
        .doc(widget.name)
        .get()
        .then((value) => info = value.data());
    setState(() {
      nameInputController = TextEditingController(text: info['Name']);

      info['Brand'].forEach((k, v) {
        var keyEditingController = TextEditingController(text: k);
        var valueEditingController = TextEditingController(text: v);
        brand[k] = v;
        print('before brand');
        brandInputController[keyEditingController] = valueEditingController;
        print(brandInputController);
        // brandInputController.putIfAbsent(k, () => brand[v]);
        // textFileds[TextField(
        //   controller: keyEditingController,
        // )] = TextField(
        //   controller: valueEditingController,
        // );

        _isEnabled = false;

        name = info['Name'];
        brand.forEach((key, value) {
          brandlist[key] = value;
        });
        print('after name');
        loading = false;
      });
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
              title: const Center(child: Text('Product')),
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
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Container(
                  //   padding: const EdgeInsets.only(
                  //       top: 30, right: 30, left: 30, bottom: 100),
                  //   child: Form(
                  //     key: _formKey,
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
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
                        labelText: "Product Name",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.branding_watermark,
                          color: Colors.blue[400],
                        )),
                    controller: nameInputController,
                    enabled: false,
                    style: TextStyle(color: Colors.black, fontSize: 17.0),
                  ),
                  for (var entry in brandInputController.entries)
                    Row(children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          onTap: () {
                            keyOnTap = entry.key.text;
                          },
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (value) {
                            setState(() {
                              brandlist.remove(keyOnTap);

                              brandlist.remove(storeValue);
                              var temp = entry.value.text;
                              // brandInputController.remove(entry.key);

                              brandlist[value.toUpperCase()] = temp;
                              print(brandlist);
                              storeValue = value.toUpperCase();
                              // brandInputController[
                              //         TextEditingController(text: value)] =
                              //     TextEditingController(text: temp);
                              //  brandlist.entries.firstWhere((element) => element.value)
                            });
                          },
                          decoration: InputDecoration(
                              labelText: "HSN",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(
                                Icons.label_important,
                                color: Colors.blue[400],
                              )),
                          controller: entry.key,
                          enabled: _isEnabled,
                          style: TextStyle(color: Colors.black, fontSize: 17.0),
                        ),
                      ),
                      Flexible(
                          child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            print(entry.key.text);
                            brandlist[entry.key.text] = value.toUpperCase();
                            print(brandlist);
                          });
                        },
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                            labelText: "Brand",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(
                              Icons.label_important,
                              color: Colors.blue[400],
                            )),
                        controller: entry.value,
                        enabled: _isEnabled,
                        style: TextStyle(color: Colors.black, fontSize: 17.0),
                      )),
                    ]),
                  //         ],
                  //      ),
                  //    ),
                  //    ),
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
                        .editProduct(widget.name, brandlist)
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
