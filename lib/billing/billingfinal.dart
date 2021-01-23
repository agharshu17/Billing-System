import 'package:Billing/billing/billingTransport.dart';
import 'package:Billing/billing/expenses.dart';
import 'package:Billing/shared/loading.dart';
import 'package:flutter/material.dart';

class billingAns extends StatefulWidget {
  final String partyName, brokerName, pan, email, invoice;
  final double taxRate, taxRateHalf, panRate;
  final List<Map<String, dynamic>> productList;
  final bool interstate;
  const billingAns(
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
      this.panRate})
      : super(key: key);
  @override
  _billingAnsState createState() => _billingAnsState();
}

class _billingAnsState extends State<billingAns> {
  String rateWithoutTax, rateWithTax, taxString, panString;
  double totalRateWithoutPan, totalPan, total;
  bool noTaxable = false, cgst = false, igst = false;
  TextEditingController rateWithoutTaxInputController,
      rateWithTaxInputController,
      panInputController,
      totalPanInputController,
      totalInputController;
  bool loading = true;
  double sum = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      for (var x in widget.productList) {
        sum += x['Rate'];
      }
      rateWithoutTax = sum.toStringAsFixed(2);
      rateWithoutTaxInputController =
          new TextEditingController(text: rateWithoutTax);
      func();
      tcsfunc();
    });
  }

  void func() {
    if (widget.taxRate == 0 && widget.taxRateHalf == 0) {
      noTaxable = true;
      taxString = "Rate With No Tax (Rs)";
      rateWithTax = sum.toStringAsFixed(2);
      totalRateWithoutPan = sum;
    } else if (widget.taxRateHalf == 0) {
      igst = true;
      taxString = "IGST Rate (Rs)";
      double temp = sum * widget.taxRate / 100;
      rateWithTax = temp.toStringAsFixed(2);
      totalRateWithoutPan = sum + temp;
    } else {
      cgst = true;
      taxString = "CGST Rate (Rs)";
      double temp = sum * widget.taxRateHalf / 100;
      rateWithTax = temp.toStringAsFixed(2);
      totalRateWithoutPan = sum + (2 * temp);
    }
    rateWithTaxInputController = new TextEditingController(text: rateWithTax);
  }

  void tcsfunc() {
    if (widget.pan == "Yes") {
      panString = "With PAN";
    } else if (widget.pan == "No")
      panString = "Without PAN";
    else
      panString = "No TCS";
    totalPan = totalRateWithoutPan * widget.panRate / 100;
    totalPanInputController =
        new TextEditingController(text: totalPan.toStringAsFixed(2));
    total = totalRateWithoutPan + totalPan;
    totalInputController =
        new TextEditingController(text: total.toStringAsFixed(2));
    loading = false;
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
        body: loading
            ? Loading()
            : Container(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Rate without taxes (Rs)",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: Colors.blue[400],
                              )),
                          controller: rateWithoutTaxInputController,
                          enabled: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          'TAX',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: taxString,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: Colors.blue[400],
                              )),
                          controller: rateWithTaxInputController,
                          enabled: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                          ),
                        ),
                        !cgst
                            ? Text('')
                            : TextFormField(
                                decoration: InputDecoration(
                                    labelText: "SGST Rate (Rs)",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(
                                      Icons.attach_money,
                                      color: Colors.blue[400],
                                    )),
                                controller: rateWithTaxInputController,
                                enabled: false,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
                              ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          'TCS',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Rate $panString (Rs)',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: Colors.blue[400],
                              )),
                          controller: totalPanInputController,
                          enabled: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          'AMOUNT',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Billing Amount (Rs)",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(
                                Icons.monetization_on,
                                color: Colors.blue[400],
                              )),
                          controller: totalInputController,
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
                                return new BillingTransport(
                                    email: widget.email,
                                    partyName: widget.partyName,
                                    brokerName: widget.brokerName,
                                    invoice: widget.invoice,
                                    productList: widget.productList,
                                    rate: {
                                      'TaxString': widget.interstate,
                                      'CGSTRate': widget.taxRateHalf,
                                      'TAX': rateWithTax,
                                      'IGSTRate': widget.taxRate,
                                      'PanRate': widget.panRate,
                                      'TCS': double.parse(
                                          totalPan.toStringAsFixed(2)),
                                      'PanString': panString,
                                      'Net': double.parse(
                                          total.toStringAsFixed(2)),
                                    });
                              }));
                            })
                      ]),
                )));
  }
}
