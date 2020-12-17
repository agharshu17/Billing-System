import 'package:billing_system/models/user.dart';
import 'package:billing_system/screens/home.dart';
import 'package:billing_system/screens/sign-in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    if (user == null) {
      return SignIn();
    } else {
      return Home();
    }
  }
}
