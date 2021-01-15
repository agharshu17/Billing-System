import 'package:billing_system/billing/invoice.dart';
import 'package:billing_system/billing/packaging.dart';
import 'package:billing_system/billing/product_billing.dart';
import 'package:billing_system/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';

class ProductBilling extends StatefulWidget {
  final String email, partyName, brokerName, invoice;
  final List<Map<String, dynamic>> productList;

  const ProductBilling(
      {Key key,
      this.email,
      this.partyName,
      this.brokerName,
      this.invoice,
      this.productList})
      : super(key: key);

  @override
  _PartyBrokerState createState() => _PartyBrokerState();
}

class _PartyBrokerState extends State<ProductBilling> {
  String product = '', brand = '';
  List<String> productList = [];
  Map<String, String> brandList = {};
  List<String> totalList = [];
  var firestore;
  var hsn;

  static var info;
  var icon = Icons.edit;

  String error = '';

  TextEditingController productInputController;
  TextEditingController brandInputController;
  TextEditingController hsnInputController =
      new TextEditingController(text: "");
  bool _isEnabled;

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
        .collection('Product');
    await firestore.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        //  totalList.add(result.data());
        productList.add(result.data()['Name']);
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
                      'PRODUCT',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    DropDownField(
                      onValueChanged: (value) async {
                        //this is the value i select from the dpropdown
                        product = value;

                        await firestore
                            .doc(value)
                            .get()
                            .then((value2) => info = value2.data());
                        // i send that value to firebase...and retrieve the same value

                        setState(() {
                          brand = "";
                          brandList = {};
                          print(info['Brand']);
                          for (var x in info['Brand'].entries) {
                            brandList[x.key] = x.value;
                          }
                          print(brandList);
                          _isEnabled = false;
                        });
                      },
                      value: product,
                      required: false,
                      hintText: 'Select Product',
                      labelText: 'Product',
                      items: productList,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    DropDownField(
                      onValueChanged: (value) {
                        //   if (product == "") brand = "";
                        setState(() {
                          brand = value;
                          print(brand);
                          print("--------------------------");
                          print(brandList);
                          hsn = (brandList.entries.firstWhere(
                              (element) => element.value == brand,
                              orElse: () => null)).key;
                          print(hsn);
                          hsnInputController =
                              new TextEditingController(text: hsn);
                          _isEnabled = false;
                        });
                      },
                      value: brand,
                      required: false,
                      hintText: 'Select Brand',
                      labelText: 'Brand',
                      items: brandList.values.toList(),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "HSN Code",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: Colors.black),
                          hintText: hsn,
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: Colors.blue[400],
                          )),
                      enabled: false,
                      controller: hsnInputController,
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
                            return new Packaging(
                                email: widget.email,
                                partyName: widget.partyName,
                                brokerName: widget.brokerName,
                                product: '$product - $brand',
                                hsn: hsn,
                                invoice: widget.invoice,
                                productList: widget.productList);
                          }));
                        })
                  ],
                ),
              ),
            ),
          );
  }
}
