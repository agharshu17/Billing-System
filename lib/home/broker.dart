import 'package:Billing/broker/existingbroker.dart';
import 'package:Billing/broker/newbroker.dart';
import 'package:Billing/party/existingparty.dart';
import 'package:Billing/party/newparty.dart';
import 'package:Billing/profile/account.dart';
import 'package:Billing/profile/company.dart';
import 'package:Billing/profile/terms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Broker extends StatefulWidget {
  final String email;
  const Broker({Key key, this.email}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Broker> with TickerProviderStateMixin {
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
            "Broker",
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
            Tab(child: Text("EXISTING")),
          ],
          indicatorColor: Colors.white,
          controller: tabController,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          new NewBroker(email: widget.email),
          new ExistingBroker(
            email: widget.email,
          ),
        ],
      ),
    );
  }
}
