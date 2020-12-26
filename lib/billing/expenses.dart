import 'package:billing_system/billing/createbill.dart';
import 'package:billing_system/pdf/createpdf.dart';
import 'package:billing_system/pdf/writepdf.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  final String partyName, brokerName, product, brand, pan, email;
  final double rate, taxRate, taxRateHalf, panRate, weight, frightRate;
  const Expenses(
      {Key key,
      this.email,
      this.partyName,
      this.brokerName,
      this.product,
      this.brand,
      this.rate,
      this.weight,
      this.taxRate,
      this.taxRateHalf,
      this.pan,
      this.panRate,
      this.frightRate})
      : super(key: key);
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  bool otheryes = false, otherno = false;
  bool _isEnabled = false;
  String expense = "", expenseName = "";
  double expenseDouble = 0;
  TextEditingController expenseNameInputController, expenseInputController;

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
                    "Any Other Expenses?",
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
                        setState(() {
                          otheryes = true;
                          otherno = false;
                        });
                      },
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    new RaisedButton(
                      child: new Text('NO'),
                      color: Colors.blueAccent[600],
                      onPressed: () {
                        setState(() {
                          otherno = true;
                          otheryes = false;
                        });
                      },
                    ),
                  ]),
                  SizedBox(
                    height: 50,
                  ),
                  (!otheryes)
                      ? Text('')
                      : new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                              TextFormField(
                                onChanged: (value) {
                                  expenseName = value;
                                },
                                decoration: InputDecoration(
                                    labelText: "Expense Name",
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: expenseNameInputController,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  expense = value;
                                  expenseDouble = double.parse(expense);
                                },
                                decoration: InputDecoration(
                                    labelText: "Expense Rate(Rs)",
                                    hintText: '0',
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: expenseInputController,
                                enabled: true,
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
                                    'Create Bill',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(5),
                                    side: BorderSide(color: Colors.black),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  onPressed: () async {
                                    reportView(
                                        context,
                                        widget.email,
                                        widget.partyName,
                                        widget.brokerName,
                                        widget.product,
                                        widget.brand,
                                        widget.rate,
                                        widget.weight,
                                        widget.taxRate,
                                        widget.taxRateHalf,
                                        widget.pan,
                                        widget.panRate,
                                        widget.frightRate,
                                        expenseName,
                                        expenseDouble);
                                  }),
                            ]),
                  !otherno
                      ? Text('')
                      : RaisedButton(
                          child: Text(
                            'Create Bill',
                            style: TextStyle(color: Colors.black54),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5),
                            side: BorderSide(color: Colors.black),
                          ),
                          padding: const EdgeInsets.all(20),
                          onPressed: () async {
                            reportView(
                                context,
                                widget.email,
                                widget.partyName,
                                widget.brokerName,
                                widget.product,
                                widget.brand,
                                widget.rate,
                                widget.weight,
                                widget.taxRate,
                                widget.taxRateHalf,
                                widget.pan,
                                widget.panRate,
                                widget.frightRate,
                                expenseName,
                                expenseDouble);
                          }),
                ],
              ),
            )));
  }
}
