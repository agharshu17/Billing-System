import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabasePdf {
  final String email;
  DatabasePdf({this.email});
  bool loading = false;

  var info;
  String companyName = "",
      companyOfficeAddress = "",
      companyFactoryAddress = "",
      companyFssai = "",
      companyGst = "",
      companyTan = "",
      companyOfficeContact = "",
      companyFactoryContact = "",
      companyMobileContact = "",
      companyBankName = "",
      companyAccount = "",
      companyIfsc = "",
      companyTerms = "";

  String partyEmail = "",
      partyAddress = "",
      partyState = "",
      partyStateCode = "",
      partyMobileContact = "",
      partyOfficeContact = "",
      partyFssai = "",
      partyGst = "";

  String agentMobileContact = "";

  String transportName = "", transportVehicle = "";

  String bankName = "", accountNumber = "", ifsc = "", description = "";

  Future<void> companyInfo() async {
    await FirebaseFirestore.instance
        .collection('Company')
        .doc(email)
        .get()
        .then((value) => info = value.data());
    companyName = info['Name'];
    companyOfficeAddress = info['Address']['Office'];
    companyFactoryAddress = info['Address']['Factory'];
    companyOfficeContact = info['Contact']['Office'];
    companyFactoryContact = info['Contact']['Factory'];
    companyMobileContact = info['Contact']['Mobile'];
    companyFssai = info['Tax']['FSSAI No.'];
    companyGst = info['Tax']['GST No.'];
    companyTan = info['Tax']['TAN No.'];
    companyBankName = info['Bank']['Bank Name'];
    companyAccount = info['Bank']['Account No'];
    companyIfsc = info['Bank']['IFSC Code'];
    companyTerms = info['Description'];
    loading = true;
  }

  Future<void> partyInfo(String partyName) async {
    await FirebaseFirestore.instance
        .collection('Company')
        .doc(email)
        .collection('Party Name')
        .doc(partyName)
        .get()
        .then((value) => info = value.data());
    partyEmail = info['Email'];
    partyAddress = info['Address']['Office'];
    partyOfficeContact = info['Contact']['Office'];
    partyMobileContact = info['Contact']['Mobile'];
    partyGst = info['Tax']['GST No.'];
    partyFssai = info['Tax']['FSSAI No.'];
  }

  Future<void> brokerInfo(String brokerName) async {
    await FirebaseFirestore.instance
        .collection('Company')
        .doc(email)
        .collection('Broker')
        .doc(brokerName)
        .get()
        .then((value) => info = value.data());
    agentMobileContact = info['Mobile'];
  }

  void transportInfo(List transport) {
    transportName = transport[0];
    transportVehicle = transport[1];
  }

  Future<void> bankDescription() async {
    await FirebaseFirestore.instance
        .collection('Company')
        .doc(email)
        .get()
        .then((value) => info = value.data());
    bankName = info['Bank']['Bank Name'];
    accountNumber = info['Bank']['Account No'];
    ifsc = info['Bank']['IFSC Code'];
    description = info['Description'];
  }
}
