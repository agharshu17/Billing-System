import 'package:Billing/billing/packaging.dart';
import 'package:Billing/billing/product_billing.dart';
import 'package:Billing/home/product.dart';
import 'package:flutter/material.dart';

class Invoice extends StatefulWidget {
  final String partyName, brokerName, email;
  const Invoice({
    Key key,
    this.email,
    this.partyName,
    this.brokerName,
  });
  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  String invoice = "";
//  List<Map<String, dynamic>> productList = [];
  TextEditingController invoiceInputController;
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
                  TextFormField(
                    onChanged: (value) {
                      invoice = value;
                    },
                    decoration: InputDecoration(
                        labelText: "Invoice No.",
                        hintText: "xxxx",
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.blue[400],
                        )),
                    controller: invoiceInputController,
                    keyboardType: TextInputType.number,
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
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return new ProductBilling(
                              email: widget.email,
                              partyName: widget.partyName,
                              brokerName: widget.brokerName,
                              invoice: invoice,
                              productList: []);
                        }));
                      })
                ],
              ),
            )));
  }
}
