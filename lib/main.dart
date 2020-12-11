import 'package:billing_system/home/billing.dart';
import 'package:billing_system/home/broker.dart';
import 'package:billing_system/home/documents.dart';
import 'package:billing_system/home/party.dart';
import 'package:billing_system/home/product.dart';
import 'package:billing_system/home/profile.dart';
import 'package:billing_system/home/transportation.dart';
import 'package:billing_system/profile/account.dart';
import 'package:billing_system/profile/company.dart';
import 'package:billing_system/profile/terms.dart';
import 'package:billing_system/screens/home.dart';
import 'package:billing_system/screens/register.dart';
import 'package:billing_system/screens/sign-in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MyApp myApp;
  if (FirebaseAuth.instance.currentUser != null) {
    myApp = MyApp(initialRoute: '/Home');
  } else {
    myApp = MyApp(initialRoute: '/SignIn');
  }
  return runApp(myApp);
}

final routes = {
  '/Home': (context) => Home(),
  '/Register': (context) => Register(),
  '/SignIn': (context) => SignIn(),
  '/': (context) => SignIn(),
  '/Account': (context) => Account(),
  '/Terms': (context) => Terms(),
  '/Billing': (context) => Billing(),
  '/Broker': (context) => Broker(),
  '/Documents': (context) => Documents(),
  '/Party': (context) => Party(),
  '/Product': (context) => Product(),
  '/Transportation': (context) => Transportation(),
  '/Profile': (context) => Profile(),
};

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({Key key, this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      initialRoute: initialRoute,
      routes: routes,
    );
  }
}
