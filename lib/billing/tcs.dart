import 'package:Billing/billing/billingfinal.dart';
import 'package:flutter/material.dart';

class tcs extends StatefulWidget {
  final String partyName, brokerName, email, invoice;
  final double taxRate, taxRateHalf;
  final List<Map<String, dynamic>> productList;
  final bool interstate;
  const tcs(
      {Key key,
      this.email,
      this.partyName,
      this.brokerName,
      this.invoice,
      this.productList,
      this.taxRate,
      this.taxRateHalf,
      this.interstate})
      : super(key: key);
  @override
  _tcsState createState() => _tcsState();
}

class _tcsState extends State<tcs> {
  bool tcsyes = false, tcsno = false, panyes = false, panno = false;
  String tcsChange = "YES";
  String nontcsChange = "NO";
  String tcs = " TCS";
  bool _isEnabled = false;
  String inputRate = "";
  double inputRateDouble = 0, inputRateDoubleHalf = 0;
  TextEditingController panInputController,
      nopanInputController,
      notcsInputController;

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
                    tcs,
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
                        if (tcsyes == false) {
                          setState(() {
                            tcsyes = true;
                            tcsno = false;
                            tcs = "PAN Applicable?";
                          });
                        } else {
                          setState(() {
                            panno = false;
                            panyes = true;
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
                        if (tcsyes == false) {
                          setState(() {
                            tcsno = true;
                            tcsyes = false;
                            _isEnabled = true;
                          });
                        } else {
                          setState(() {
                            panno = true;
                            panyes = false;
                            _isEnabled = true;
                          });
                        }
                      },
                    ),
                  ]),
                  SizedBox(
                    height: 50,
                  ),
                  !panno
                      ? Text('')
                      : new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                              TextFormField(
                                onChanged: (value) {
                                  inputRate = value;
                                  inputRateDouble = double.parse(inputRate);
                                },
                                decoration: InputDecoration(
                                    labelText: "NO PAN Percentage(%)",
                                    hintText: '0',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: panInputController,
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
                                      return new billingAns(
                                          email: widget.email,
                                          partyName: widget.partyName,
                                          brokerName: widget.brokerName,
                                          invoice: widget.invoice,
                                          productList: widget.productList,
                                          taxRate: widget.taxRate,
                                          taxRateHalf: widget.taxRateHalf,
                                          interstate: widget.interstate,
                                          pan: 'Yes',
                                          panRate: inputRateDouble);
                                    }));
                                  }),
                            ]),
                  !panyes
                      ? Text('')
                      : new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                              TextFormField(
                                onChanged: (value) {
                                  inputRate = value;
                                  inputRateDouble = double.parse(inputRate);
                                },
                                decoration: InputDecoration(
                                    labelText: "PAN Percentage(%)",
                                    hintText: '0',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: nopanInputController,
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
                                      return new billingAns(
                                          email: widget.email,
                                          partyName: widget.partyName,
                                          brokerName: widget.brokerName,
                                          invoice: widget.invoice,
                                          productList: widget.productList,
                                          taxRate: widget.taxRate,
                                          taxRateHalf: widget.taxRateHalf,
                                          interstate: widget.interstate,
                                          pan: 'No',
                                          panRate: inputRateDouble);
                                    }));
                                  }),
                            ]),
                  !tcsno
                      ? Text('')
                      : new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "NO TCS Percentage(%)",
                                    hintText: '0',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Colors.blue[400],
                                    )),
                                controller: notcsInputController,
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
                                    setState(() {
                                      inputRateDouble = 0;
                                    });
                                    Navigator.of(context).push(
                                        MaterialPageRoute<Null>(
                                            builder: (BuildContext context) {
                                      return new billingAns(
                                          email: widget.email,
                                          partyName: widget.partyName,
                                          brokerName: widget.brokerName,
                                          invoice: widget.invoice,
                                          productList: widget.productList,
                                          taxRate: widget.taxRate,
                                          taxRateHalf: widget.taxRateHalf,
                                          interstate: widget.interstate,
                                          pan: 'NA',
                                          panRate: inputRateDouble);
                                    }));
                                  })
                            ]),
                ],
              ),
            )));
  }
}
