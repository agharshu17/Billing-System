import 'package:flutter/material.dart';

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}

showAlertDialog(BuildContext context, String button1, String button2,
    String title, String description, Function func) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(button1),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
      child: Text(button2),
      onPressed: () {
        func();
      });

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Constants.padding),
    ),
    elevation: 0,
    title: Text(title),
    content: Text(description),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
