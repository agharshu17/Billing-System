import 'package:Billing/home/billing.dart';
import 'package:Billing/home/broker.dart';
import 'package:Billing/home/documents.dart';
import 'package:Billing/home/party.dart';
import 'package:Billing/home/product.dart';
import 'package:Billing/home/profile.dart';
import 'package:Billing/home/transportation.dart';
import 'package:Billing/models/user.dart';
import 'package:Billing/profile/account.dart';
import 'package:Billing/profile/company.dart';
import 'package:Billing/profile/terms.dart';
import 'package:Billing/screens/home.dart';
import 'package:Billing/screens/register.dart';
import 'package:Billing/screens/sign-in.dart';
import 'package:Billing/screens/wrapper.dart';
import 'package:Billing/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  return runApp(MyApp());
}

final routes = {
  '/Home': (context) => Home(),
  '/Register': (context) => Register(),
  '/SignIn': (context) => SignIn(),
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamProvider<MyUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
        routes: routes,
      ),
    );
  }
}
