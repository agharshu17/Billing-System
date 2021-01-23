import 'package:Billing/pdf/createpdf.dart';
import 'package:Billing/pdf/writepdf.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  final String partyName, brokerName, email, invoice;
  final List<Map<String, dynamic>> productList;
  final List<String> transport;
  final Map<String, dynamic> rate, frightRate;
  const Expenses(
      {Key key,
      this.email,
      this.partyName,
      this.brokerName,
      this.invoice,
      this.productList,
      this.rate,
      this.frightRate,
      this.transport})
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
                                      Icons.label_important,
                                      color: Colors.blue[400],
                                    )),
                                controller: expenseNameInputController,
                                textCapitalization:
                                    TextCapitalization.characters,
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
                                    labelText: "Expense Rate (Rs)",
                                    hintText: '0',
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.attach_money,
                                      color: Colors.blue[400],
                                    )),
                                keyboardType: TextInputType.number,
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
                                        widget.invoice,
                                        widget.productList,
                                        widget.frightRate,
                                        widget.rate,
                                        widget.transport,
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
                                widget.invoice,
                                widget.productList,
                                widget.frightRate,
                                widget.rate,
                                widget.transport,
                                expenseName,
                                expenseDouble);
                          }),
                ],
              ),
            )));
  }
}
