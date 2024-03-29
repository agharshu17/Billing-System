import 'package:Billing/billing/party_broker.dart';
import 'package:Billing/home/billing.dart';
import 'package:Billing/home/broker.dart';
import 'package:Billing/home/documents.dart';
import 'package:Billing/home/party.dart';
import 'package:Billing/home/product.dart';
import 'package:Billing/home/profile.dart';
import 'package:Billing/home/transportation.dart';
import 'package:Billing/services/auth.dart';
import 'package:Billing/shared/showAlertDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var info;
  final AuthService _authService = AuthService();
  var email;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = FirebaseAuth.instance.currentUser.email;
  }

  @override
  Widget build(BuildContext context) {
    List items = [
      "Party",
      "Broker",
      "Product",
      "Transport",
      "Billing",
      "Documents"
    ];
    List icons = [
      Icons.group,
      Icons.person_outline,
      Icons.shopping_cart,
      Icons.local_shipping,
      Icons.receipt,
      Icons.source
    ];
    Container myArticles(int index) {
      return Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            child: FlatButton(
              child: Card(
                color: Colors.black,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          icons[index],
                          color: Colors.blue,
                          size: 70,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 200,
                          height: 30,
                          child: Text(
                            items[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onPressed: () {
                if (index == 0) {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new Party(
                      email: email,
                    );
                  }));
                } else if (index == 1) {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new Broker(
                      email: email,
                    );
                  }));
                } else if (index == 2) {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new Product(
                      email: email,
                    );
                  }));
                } else if (index == 3) {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new Transportation(
                      email: email,
                    );
                  }));
                } else if (index == 4) {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new PartyBroker(
                      email: email,
                    );
                  }));
                } else if (index == 5) {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new Documents(
                      email: email,
                    );
                  }));
                }
              },
            ),
          ),
        ),
      );
    }

    func() async {
      await _authService.signOut();
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Center(child: Text('Home')),
        leading: IconButton(
          icon: const Icon(Icons.account_box),
          tooltip: 'Sign Out',
          onPressed: () async {
            await showAlertDialog(context, 'Cancel', 'Leave', 'Sign Out',
                'Are you sure you want to Leave this Page?', func);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile',
            onPressed: () {
              print(email);
              //Profile page
              Navigator.of(context).push(
                  MaterialPageRoute<Null>(builder: (BuildContext context) {
                return Profile(
                  email: email,
                );
              }));
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 20),
                child: Center(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(6, (index) {
                      return myArticles(index);
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
