import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  final String partyName, brokerName, product, brand;
  final double rate, taxRate, taxRateHalf, panRate, weight;
  const Expenses(
      {Key key,
      this.partyName,
      this.brokerName,
      this.product,
      this.brand,
      this.rate,
      this.weight,
      this.taxRate,
      this.taxRateHalf,
      this.panRate})
      : super(key: key);
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
