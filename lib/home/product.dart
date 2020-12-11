import 'package:billing_system/party/existingparty.dart';
import 'package:billing_system/party/newparty.dart';
import 'package:billing_system/product/existingproduct.dart';
import 'package:billing_system/product/newproduct.dart';
import 'package:billing_system/profile/account.dart';
import 'package:billing_system/profile/company.dart';
import 'package:billing_system/profile/terms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Product extends StatefulWidget {
  final String email;
  const Product({Key key, this.email}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Product> with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Center(
          child: Text(
            "Product",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        bottom: TabBar(
          tabs: [
            Tab(
              child: Text("CREATE"),
            ),
            Tab(
              child: Text("EXISTING"),
            ),
          ],
          indicatorColor: Colors.white,
          controller: tabController,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          new NewProduct(email: widget.email),
          new ExistingProduct(
            email: widget.email,
          ),
        ],
      ),
    );
  }
}
