import 'package:flutter/material.dart';

class CreateBill extends StatefulWidget {
  final String partyName, brokerName, product, brand, pan, otherExpenseName;
  final double rate,
      taxRate,
      taxRateHalf,
      panRate,
      weight,
      frightRate,
      otherExpenseRate;
  const CreateBill(
      {Key key,
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
      this.frightRate,
      this.otherExpenseName,
      this.otherExpenseRate})
      : super(key: key);
  @override
  _CreateBillState createState() => _CreateBillState();
}

class _CreateBillState extends State<CreateBill> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
