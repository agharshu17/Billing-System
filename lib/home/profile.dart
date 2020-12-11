import 'package:billing_system/profile/account.dart';
import 'package:billing_system/profile/company.dart';
import 'package:billing_system/profile/terms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String email;
  const Profile({Key key, this.email}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Center(
          child: Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        bottom: TabBar(
          tabs: [
            Tab(
              child: Text("COMPANY"),
            ),
            Tab(child: Text("ACCOUNT")),
            Tab(
                child: Text(
              "TERMS",
            )),
          ],
          indicatorColor: Colors.white,
          controller: tabController,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          new Company(email: widget.email),
          new Account(email: widget.email),
          new Terms(email: widget.email),
        ],
      ),
    );
  }
}
