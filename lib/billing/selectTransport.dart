import 'package:Billing/billing/expenses.dart';
import 'package:Billing/billing/packaging.dart';
import 'package:Billing/billing/product_billing.dart';
import 'package:Billing/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';

class selectTransport extends StatefulWidget {
  final String partyName, brokerName, email, invoice;
  final Map<String, dynamic> rate, frightRate;
  final List<Map<String, dynamic>> productList;
  const selectTransport(
      {Key key,
      this.email,
      this.partyName,
      this.brokerName,
      this.invoice,
      this.productList,
      this.rate,
      this.frightRate})
      : super(key: key);

  @override
  _PartyBrokerState createState() => _PartyBrokerState();
}

class _PartyBrokerState extends State<selectTransport> {
  String product = '', brand = '';
  List<String> productList = [];
  List<String> brandList = [];
  List<String> totalList = [];
  var firestore;

  static var info;
  var icon = Icons.edit;

  String error = '';

  TextEditingController productInputController;
  TextEditingController brandInputController;
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
        .collection('Transport');
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
                      'TRANSPORT',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 50,
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
                          brandList = [];
                          for (var x in info['Vehicle No']) {
                            brandList.add(x);
                          }
                          print(brandList);
                          _isEnabled = false;
                        });
                      },
                      value: product,
                      required: false,
                      hintText: 'Select Transport',
                      labelText: 'Transport',
                      items: productList,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    DropDownField(
                      onValueChanged: (value) {
                        //   if (product == "") brand = "";

                        brand = value;

                        _isEnabled = false;
                      },
                      value: brand,
                      required: false,
                      hintText: 'Select Vehicle',
                      labelText: 'Vehicle',
                      items: brandList,
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
                            return new Expenses(
                                email: widget.email,
                                partyName: widget.partyName,
                                brokerName: widget.brokerName,
                                invoice: widget.invoice,
                                productList: widget.productList,
                                frightRate: widget.frightRate,
                                rate: widget.rate,
                                transport: [product, brand]);
                          }));
                        })
                  ],
                ),
              ),
            ),
          );
  }
}
