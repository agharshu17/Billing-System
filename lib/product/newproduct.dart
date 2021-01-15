import 'package:billing_system/screens/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:billing_system/services/database.dart';

class NewProduct extends StatefulWidget {
  final String email;
  const NewProduct({Key key, this.email}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<NewProduct> {
  final _formKey = new GlobalKey<FormState>();
  final scaffoldkey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  var info = [];

  String error = '';

  String name = "";
  String brand = "", hsn = "";

  TextEditingController nameInputController;
  TextEditingController brandInputController;
  TextEditingController hsnInputController;
  bool _iscreated;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseFuncToGetProducts();
  }

  Future<void> firebaseFuncToGetProducts() async {
    await FirebaseFirestore.instance
        .collection('Company')
        .doc(widget.email)
        .collection('Product')
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
                      onChanged: (value) {
                        setState(() {
                          name = value.toUpperCase();
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "Product Name",
                          hintText: "Enter Product Name Here",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: Colors.blue[400],
                          )),
                      controller: nameInputController,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    TextFormField(
                      validator: (val) {
                        if (_iscreated == true) {
                          print('------------');
                          for (var x in info) {
                            if (x['Brand'].values.contains(brand)) {
                              print(x['Brand']);
                              return "Brand Already Exists!";
                            }
                          }
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          brand = value.toUpperCase();
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "Brand Name",
                          hintText: "Enter Brand Name Here",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: Colors.blue[400],
                          )),
                      controller: brandInputController,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                    TextFormField(
                      validator: (val) =>
                          val.length != 6 ? "Enter a 6 Digit HSN Number" : null,
                      onChanged: (value) {
                        setState(() {
                          hsn = value.toUpperCase();
                        });
                      },
                      decoration: InputDecoration(
                          labelText: "HSN/SAC Number",
                          hintText: "Enter HSN Number Here",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: Colors.blue[400],
                          )),
                      controller: hsnInputController,
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
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
                'Create Product',
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
                      .createNewProduct(name, brand, hsn)
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
                      brandInputController =
                          new TextEditingController(text: "");
                      hsnInputController = new TextEditingController(text: "");
                      hsn = "";
                      name = brand = "";
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
