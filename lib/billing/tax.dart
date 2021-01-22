import 'dart:ffi';

import 'package:billing_system/billing/tcs.dart';
import 'package:flutter/material.dart';

class Taxation extends StatefulWidget {
  final String partyName, brokerName, email, invoice;
  final List<Map<String, dynamic>> productList;
  const Taxation(
      {Key key,
      this.email,
      this.partyName,
      this.brokerName,
      this.invoice,
      this.productList})
      : super(key: key);
  @override
  _PackagingState createState() => _PackagingState();
}

class _PackagingState extends State<Taxation> {
  bool taxable = false,
      nontaxable = false,
      intrastate = false,
      interstate = false;
  String taxableChange = "Taxable";
  String nontaxableChange = "Non-Taxable";
  String tax = "TAX";
  bool _isEnabled = false;
  String inputRate = "";
  double inputRateDouble = 0, inputRateDoubleHalf = 0;
  bool _boolInterstate = false;
  TextEditingController inputRateInputController;
  TextEditingController igstInputController,
      cgstInputController,
      sgstInputController;

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
            child: SingleChildScrollView(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    tax,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  new Row(children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    new RaisedButton(
                      child: new Text(taxableChange),
                      color: Colors.blueAccent[600],
                      onPressed: () {
                        if (taxable == false && nontaxable == false) {
                          setState(() {
                            taxable = true;
                            nontaxable = false;
                            _isEnabled = true;
                            tax = "Trade Type";
                            taxableChange = "Intra State";
                            nontaxableChange = "Inter State";
                          });
                        } else {
                          setState(() {
                            _boolInterstate = false;
                            interstate = false;
                            intrastate = true;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    new RaisedButton(
                      child: new Text(nontaxableChange),
                      color: Colors.blueAccent[600],
                      onPressed: () {
                        if (taxable == false && nontaxable == false) {
                          setState(() {
                            nontaxable = true;
                            taxable = false;
                            _isEnabled = false;
                            tax = "Trade Type";
                            taxableChange = "Intra State";
                            nontaxableChange = "Inter State";
                          });
                        } else {
                          setState(() {
                            _boolInterstate = true;
                            interstate = true;
                            intrastate = false;
                          });
                        }
                      },
                    ),
                  ]),
                  SizedBox(
                    height: 50,
                  ),
                  !interstate
                      ? Text('')
                      : new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                              TextFormField(
                                onChanged: (value) {
                                  inputRate = value;
                                  setState(() {
                                    inputRateDouble = double.parse(inputRate);
                                    inputRateDoubleHalf = 0;
                                    igstInputController = TextEditingController(
                                        text: inputRateDouble.toString());
                                  });
                                },
                                decoration: InputDecoration(
                                    labelText: "Input Tax Percentage(%)",
                                    hintText: '0',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: inputRateInputController,
                                enabled: _isEnabled,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "IGST(%)",
                                    hintText: '0',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: igstInputController,
                                enabled: _isEnabled,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
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
                                    Navigator.of(context).push(
                                        MaterialPageRoute<Null>(
                                            builder: (BuildContext context) {
                                      return new tcs(
                                          email: widget.email,
                                          partyName: widget.partyName,
                                          brokerName: widget.brokerName,
                                          invoice: widget.invoice,
                                          productList: widget.productList,
                                          taxRate: inputRateDouble,
                                          taxRateHalf: inputRateDoubleHalf,
                                          interstate: _boolInterstate);
                                    }));
                                  }),
                            ]),
                  !intrastate
                      ? Text('')
                      : new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                              TextFormField(
                                onChanged: (value) {
                                  inputRate = value;
                                  setState(() {
                                    inputRateDouble = double.parse(inputRate);
                                    inputRateDoubleHalf = inputRateDouble / 2;
                                    cgstInputController = TextEditingController(
                                        text: inputRateDoubleHalf.toString());
                                    sgstInputController = TextEditingController(
                                        text: inputRateDoubleHalf.toString());
                                  });
                                },
                                decoration: InputDecoration(
                                    labelText: "Input Tax Percentage(%)",
                                    hintText: '0',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: inputRateInputController,
                                enabled: _isEnabled,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "CGST(%)",
                                    hintText: '0',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: cgstInputController,
                                enabled: _isEnabled,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "SGST(%)",
                                    hintText: '0',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: sgstInputController,
                                enabled: _isEnabled,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
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
                                    Navigator.of(context).push(
                                        MaterialPageRoute<Null>(
                                            builder: (BuildContext context) {
                                      return new tcs(
                                          email: widget.email,
                                          partyName: widget.partyName,
                                          brokerName: widget.brokerName,
                                          invoice: widget.invoice,
                                          productList: widget.productList,
                                          taxRate: inputRateDouble,
                                          taxRateHalf: inputRateDoubleHalf,
                                          interstate: _boolInterstate);
                                    }));
                                  }),
                            ]),
                  //     !nontaxable
                  //         ? Text('')
                  //         : new Column(
                  //             crossAxisAlignment: CrossAxisAlignment.stretch,
                  //             children: <Widget>[
                  //                 TextFormField(
                  //                   decoration: InputDecoration(
                  //                       labelText: "Input Tax Percentage(%)",
                  //                       hintText: '0',
                  //                       floatingLabelBehavior:
                  //                           FloatingLabelBehavior.always,
                  //                       labelStyle: TextStyle(color: Colors.black),
                  //                       prefixIcon: Icon(
                  //                         Icons.perm_identity,
                  //                         color: Colors.blue[400],
                  //                       )),
                  //                   controller: inputRateInputController,
                  //                   enabled: false,
                  //                   style: TextStyle(
                  //                     color: Colors.black,
                  //                     fontSize: 17.0,
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 50,
                  //                 ),
                  //                 RaisedButton(
                  //                     child: Text(
                  //                       'Next',
                  //                       style: TextStyle(color: Colors.black54),
                  //                     ),
                  //                     shape: RoundedRectangleBorder(
                  //                       borderRadius: new BorderRadius.circular(5),
                  //                       side: BorderSide(color: Colors.black),
                  //                     ),
                  //                     padding: const EdgeInsets.all(20),
                  //                     onPressed: () async {
                  //                       setState(() {
                  //                         inputRateDouble = 0;
                  //                         inputRateDoubleHalf = 0;
                  //                       });
                  //                       Navigator.of(context).push(
                  //                           MaterialPageRoute<Null>(
                  //                               builder: (BuildContext context) {
                  //                         return new tcs(
                  //                             email: widget.email,
                  //                             partyName: widget.partyName,
                  //                             brokerName: widget.brokerName,
                  //                             product: widget.product,
                  //                             brand: widget.brand,
                  //                             rate: widget.rate,
                  //                             weight: widget.weight,
                  //                             taxRate: inputRateDouble,
                  //                             taxRateHalf: inputRateDoubleHalf);
                  //                       }));
                  //                     })
                  //               ]),
                ],
              ),
            )));
  }
}
