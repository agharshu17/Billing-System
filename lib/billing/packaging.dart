import 'package:billing_system/billing/tax.dart';
import 'package:flutter/material.dart';

class Packaging extends StatefulWidget {
  final String partyName, brokerName, product, brand;
  const Packaging(
      {Key key, this.partyName, this.brokerName, this.product, this.brand})
      : super(key: key);
  @override
  _PackagingState createState() => _PackagingState();
}

class _PackagingState extends State<Packaging> {
  String package = "", bag = "", ratePerQuintal = "", rate = "", weight = "";
  double total = 0, totalWeight = 0;
  TextEditingController packageInputController,
      bagInputController,
      ratePerQuintalInputController,
      totalRateInputController,
      totalWeightInputController;

  void findRate() {
    if (package != "" && ratePerQuintal != "" && bag != "")
      total = (double.parse(package) / 100) *
          double.parse(ratePerQuintal) *
          double.parse(bag);
    print(total.toString());
    setState(() {
      rate = total.toString();
      print(rate);
      totalRateInputController = new TextEditingController(text: rate);
    });
  }

  void findWeight() {
    if (package != "" && bag != "")
      totalWeight = (double.parse(package)) * double.parse(bag);
    print(totalWeight.toString());
    setState(() {
      weight = totalWeight.toString();
      totalWeightInputController = new TextEditingController(text: weight);
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
                  TextFormField(
                    onChanged: (value) {
                      package = value;
                      findWeight();
                      findRate();
                    },
                    decoration: InputDecoration(
                        labelText: "Packaging(kgs)",
                        hintText: "xxx kgs",
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.perm_identity,
                          color: Colors.blue[400],
                        )),
                    controller: packageInputController,
                    keyboardType: TextInputType.number,
                    enabled: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      bag = value;
                      findWeight();
                      findRate();
                    },
                    decoration: InputDecoration(
                        labelText: "Number of Bags",
                        hintText: "xxxxx",
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.perm_identity,
                          color: Colors.blue[400],
                        )),
                    controller: bagInputController,
                    keyboardType: TextInputType.number,
                    enabled: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Total Weight(kgs)",
                        hintText: '0 kgs',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.perm_identity,
                          color: Colors.blue[400],
                        )),
                    controller: totalWeightInputController,
                    enabled: false,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      ratePerQuintal = value;
                      findRate();
                    },
                    decoration: InputDecoration(
                        labelText: "Rate per Quintal",
                        hintText: "xxx Rs",
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.perm_identity,
                          color: Colors.blue[400],
                        )),
                    controller: ratePerQuintalInputController,
                    keyboardType: TextInputType.number,
                    enabled: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Total Rate(Rs)",
                        hintText: '0 Rs',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.perm_identity,
                          color: Colors.blue[400],
                        )),
                    controller: totalRateInputController,
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
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return new Taxation(
                              partyName: widget.partyName,
                              brokerName: widget.brokerName,
                              product: widget.product,
                              brand: widget.brand,
                              rate: total,
                              weight: totalWeight);
                        }));
                      })
                ],
              ),
            )));
  }
}
