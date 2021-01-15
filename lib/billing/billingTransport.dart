import 'package:billing_system/billing/expenses.dart';
import 'package:billing_system/billing/selectTransport.dart';
import 'package:flutter/material.dart';

class BillingTransport extends StatefulWidget {
  final String partyName, brokerName, pan, email, invoice;
  final double taxRate, taxRateHalf, panRate;
  final bool interstate;
  final List<Map<String, dynamic>> productList;
  final Map<String, dynamic> rate;
  const BillingTransport(
      {Key key,
      this.email,
      this.partyName,
      this.brokerName,
      this.invoice,
      this.productList,
      this.taxRate,
      this.taxRateHalf,
      this.interstate,
      this.pan,
      this.panRate,
      this.rate})
      : super(key: key);
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<BillingTransport> {
  bool transportyes = false,
      transportno = false,
      advanceyes = false,
      advanceno = false;
  String transportChange = "YES";
  String nontransportChange = "NO";
  String transport = "TRANSPORTATION COST";
  bool _isEnabled = false;
  String inputRatePerQuintal = "", advance = "", totalFright = "";
  double inputRatePerQuintalDouble = 0,
      advanceDouble = 0,
      totalFrightDouble = 0;
  TextEditingController advanceInputController,
      inputRatePerQuintalInputController,
      noadvanceInputController,
      notransportInputController,
      weightInputController,
      totalFrightInputController;
  double weightSum = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      for (var x in widget.productList) {
        weightSum += x['Weight'];
      }
      weightInputController = TextEditingController(text: weightSum.toString());
    });
  }

  void func() {
    setState(() {
      if (inputRatePerQuintal != "" && advance != "") {
        totalFrightDouble =
            (inputRatePerQuintalDouble * weightSum / 100) - advanceDouble;
        totalFrightInputController =
            TextEditingController(text: totalFrightDouble.toString());
      }
    });
  }

  void func2() {
    setState(() {
      if (inputRatePerQuintal != "" && advance == "0") {
        totalFrightDouble = (inputRatePerQuintalDouble * weightSum / 100);
        totalFrightInputController =
            TextEditingController(text: totalFrightDouble.toString());
      }
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
            child: SingleChildScrollView(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    transport,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black38,
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
                      child: new Text('YES'),
                      color: Colors.blueAccent[600],
                      onPressed: () {
                        if (transportyes == false) {
                          setState(() {
                            transportyes = true;
                            transportno = false;
                            transport = "Advance Payment?";
                            _isEnabled = false;
                          });
                        } else {
                          setState(() {
                            advanceno = false;
                            advanceyes = true;
                            _isEnabled = true;
                            advance = "";
                            advanceInputController =
                                TextEditingController(text: "");
                            totalFrightInputController =
                                TextEditingController(text: "");
                            totalFrightDouble = 0;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    new RaisedButton(
                      child: new Text('NO'),
                      color: Colors.blueAccent[600],
                      onPressed: () {
                        if (transportyes == false) {
                          setState(() {
                            transportno = true;
                            transportyes = false;
                            _isEnabled = false;
                          });
                        } else {
                          setState(() {
                            advanceno = true;
                            advanceyes = false;
                            _isEnabled = false;
                            advance = "0";
                            advanceInputController =
                                TextEditingController(text: "0");
                            totalFrightInputController =
                                TextEditingController(text: "");
                            totalFrightDouble = 0;
                          });
                        }
                      },
                    ),
                  ]),
                  SizedBox(
                    height: 50,
                  ),
                  (!advanceyes)
                      ? Text('')
                      : new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Total Weight",
                                    hintText: '0',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: weightInputController,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
                                enabled: false,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  inputRatePerQuintal = value;
                                  inputRatePerQuintalDouble =
                                      double.parse(inputRatePerQuintal);
                                  func();
                                },
                                decoration: InputDecoration(
                                    labelText: "Fright Rate Per Quintal(Rs)",
                                    hintText: '0',
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: inputRatePerQuintalInputController,
                                enabled: true,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  advance = value;
                                  advanceDouble = double.parse(advance);
                                  func();
                                },
                                decoration: InputDecoration(
                                    labelText: "Advance Payment",
                                    hintText: '0',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: advanceInputController,
                                enabled: _isEnabled,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Total Fright(Rs)",
                                    hintText: '0',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: totalFrightInputController,
                                enabled: false,
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
                                      return new selectTransport(
                                          email: widget.email,
                                          partyName: widget.partyName,
                                          brokerName: widget.brokerName,
                                          invoice: widget.invoice,
                                          productList: widget.productList,
                                          taxRate: widget.taxRate,
                                          taxRateHalf: widget.taxRateHalf,
                                          interstate: widget.interstate,
                                          pan: widget.pan,
                                          panRate: widget.panRate,
                                          rate: widget.rate,
                                          frightRate: {
                                            'FrightRatePerQuintal':
                                                inputRatePerQuintalDouble,
                                            'Advance': advanceDouble,
                                            'TotalFright': totalFrightDouble,
                                          });
                                    }));
                                  }),
                            ]),
                  (!advanceno)
                      ? Text('')
                      : new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Total Weight",
                                    hintText: '0',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: weightInputController,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  inputRatePerQuintal = value;
                                  inputRatePerQuintalDouble =
                                      double.parse(inputRatePerQuintal);
                                  func2();
                                },
                                decoration: InputDecoration(
                                    labelText: "Fright Rate Per Quintal(Rs)",
                                    hintText: '0',
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: inputRatePerQuintalInputController,
                                enabled: true,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Advance Payment",
                                    hintText: '0',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: advanceInputController,
                                enabled: false,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Total Fright(Rs)",
                                    hintText: '0',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: totalFrightInputController,
                                enabled: false,
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
                                      return new selectTransport(
                                        email: widget.email,
                                        partyName: widget.partyName,
                                        brokerName: widget.brokerName,
                                        invoice: widget.invoice,
                                        productList: widget.productList,
                                        taxRate: widget.taxRate,
                                        taxRateHalf: widget.taxRateHalf,
                                        interstate: widget.interstate,
                                        pan: widget.pan,
                                        panRate: widget.panRate,
                                        rate: widget.rate,
                                        frightRate: {
                                          'FrightRatePerQuintal':
                                              inputRatePerQuintalDouble,
                                          'Advance': advanceDouble,
                                          'TotalFright': totalFrightDouble,
                                        },
                                      );
                                    }));
                                  }),
                            ]),
                  !transportno
                      ? Text("")
                      : RaisedButton(
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
                                taxRate: widget.taxRate,
                                taxRateHalf: widget.taxRateHalf,
                                interstate: widget.interstate,
                                pan: widget.pan,
                                panRate: widget.panRate,
                                rate: widget.rate,
                                frightRate: {
                                  'FrightRatePerQuintal':
                                      inputRatePerQuintalDouble,
                                  'Advance': advanceDouble,
                                  'TotalFright': totalFrightDouble,
                                },
                                transport: [],
                              );
                            }));
                          }),
                ],
              ),
            )));
  }
}
