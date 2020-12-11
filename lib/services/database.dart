import 'package:billing_system/screens/account_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Database {
  storecompanyinfo(name, factoryAddress, officeAddress, factoryContact,
      officeContact, mobileContact, email, fssai, gst, tan, context) {
    print("entered database");
    FirebaseFirestore.instance.collection("Company").doc(email).set({
      "Name": name,
      "Address": {"Office": officeAddress, "Factory": factoryAddress},
      "Contact": {
        "Mobile": mobileContact,
        "Office": officeContact,
        "Factory": factoryContact
      },
      "Email": email,
      "Tax": {"GST No.": gst, "FSSAI No.": fssai, "TAN No.": tan}
    }, SetOptions(merge: true)).then((value) {
      Navigator.of(context).pop();

      Navigator.of(context)
          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return new AccountRegister(
          email: email,
        );
      }));
    }).catchError((e) {
      print(e);
    });
  }
}
