import 'package:billing_system/models/profile_var.dart';
import 'package:billing_system/models/user.dart';
import 'package:billing_system/screens/account_register.dart';
import 'package:billing_system/screens/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Database {
  final String email;
  Database({this.email});
  //collection reference
  final CollectionReference company =
      FirebaseFirestore.instance.collection('Company');

  Future storecompanyinfo(name, factoryAddress, officeAddress, factoryContact,
      officeContact, mobileContact, fssai, gst, tan, context) async {
    print("entered database");
    await company.doc(email).set({
      "Name": name,
      "Address": {"Office": officeAddress, "Factory": factoryAddress},
      "Contact": {
        "Mobile": mobileContact,
        "Office": officeContact,
        "Factory": factoryContact
      },
      "Email": email,
      "Tax": {"GST No.": gst, "FSSAI No.": fssai, "TAN No.": tan}
    }, SetOptions(merge: true));
  }

  Future storebankinfo(accountNumber, bankName, ifsc) async {
    await company.doc(email).set({
      "Bank": {
        "Account No": accountNumber,
        "Bank Name": bankName,
        "IFSC Code": ifsc
      }
    }, SetOptions(merge: true));
  }

  Future storetermsinfo(terms) async {
    await company.doc(email).set({
      "Description": terms,
    }, SetOptions(merge: true));
  }

  Future updateAccount(account, bankName, ifsc) async {
    await company.doc(email).update({
      "Bank": {"Account No": account, "Bank Name": bankName, "IFSC Code": ifsc}
    }).catchError((e) {
      print(e);
    });
  }

  Future updateCompany(name, factoryAddress, officeAddress, factoryContact,
      officeContact, mobileContact, fssai, gst, tan) async {
    await company.doc(email).update({
      "Name": name,
      "Address": {"Office": officeAddress, "Factory": factoryAddress},
      "Contact": {
        "Mobile": mobileContact,
        "Office": officeContact,
        "Factory": factoryContact
      },
      "Email": email,
      "Tax": {"GST No.": gst, "FSSAI No.": fssai, "TAN No.": tan}
    }).catchError((e) {
      print(e);
    });
  }

  Future createNewParty(name, emailParty, officeAddress, officeContact,
      mobileContact, fssai, gst) async {
    company.doc(email).collection('Party Name').doc(name).set({
      "Name": name,
      "Address": {
        "Office": officeAddress,
      },
      "Contact": {
        "Mobile": mobileContact,
        "Office": officeContact,
      },
      "Email": emailParty,
      "Tax": {
        "GST No.": gst,
        "FSSAI No.": fssai,
      },
    }, SetOptions(merge: true));
  }

  Future deleteParty(name) async {
    await company.doc(email).collection('Party Name').doc(name).delete();
  }

  Future createNewBroker(name, mobile_contact) async {
    await company.doc(email).collection('Broker').doc(name).set({
      "Name": name,
      "Mobile": mobile_contact,
    }, SetOptions(merge: true));
  }

  Future deleteBroker(name) async {
    await company.doc(email).collection('Broker').doc(name).delete();
  }

  Future createNewProduct(name, brand, hsn) async {
    await company.doc(email).collection('Product').doc(name).set({
      "Name": name,
      "Brand": {hsn: brand},
    }, SetOptions(merge: true));
  }

  Future editProduct(name, brandlist) async {
    // await company
    //     .doc(email)
    //     .collection('Product')
    //     .doc(name)
    //     .update({"Name": name, "Brand": FieldValue.arrayRemove(brandremove)});
    await company.doc(email).collection('Product').doc(name).set({
      "Name": name,
      "Brand": {for (var b in brandlist.entries) b.key: b.value}
    });
  }

  Future deleteProduct(name) async {
    await company.doc(email).collection('Product').doc(name).delete();
  }

  Future createNewTransport(name, vehicle) async {
    await company.doc(email).collection('Transport').doc(name).set({
      "Name": name,
      "Vehicle No": FieldValue.arrayUnion([vehicle]),
    }, SetOptions(merge: true));
  }

  Future editTransport(name, brandremove, brandlist) async {
    await company.doc(email).collection('Transport').doc(name).update(
        {"Name": name, "Vehicle No": FieldValue.arrayRemove(brandremove)});
    await company
        .doc(email)
        .collection('Transport')
        .doc(name)
        .update({"Name": name, "Vehicle No": FieldValue.arrayUnion(brandlist)});
  }

  Future deleteTransport(name) async {
    await company.doc(email).collection('Transport').doc(name).delete();
  }

//   List<profileCompany> _profileCompanyListfromSnapshot(QuerySnapshot snapshot) {
//     return snapshot.docs.map((doc) {
//       return profileCompany(
//         name: doc.data()['Name'] ?? '',
//       );
//     });
//   }

//   //get company stream
//   Stream<QuerySnapshot> get company_doc {
//     return company.snapshots();
//   }
}
