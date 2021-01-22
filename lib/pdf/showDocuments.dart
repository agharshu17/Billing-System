import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:printing/printing.dart';
import 'package:share/share.dart';

class ShowDocument extends StatefulWidget {
  final String email, getPath, getUrl;
  const ShowDocument({Key key, this.email, this.getPath, this.getUrl})
      : super(key: key);
  @override
  _ShowDocumentState createState() => _ShowDocumentState();
}

class _ShowDocumentState extends State<ShowDocument> {
  shareButton() async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    String filePath = "$dir/bill.pdf";
    File _file = File(filePath);
    print(filePath);
    try {
      await FirebaseStorage.instance
          .ref('${widget.email}/${widget.getPath}')
          .writeToFile(_file);
    } on FirebaseException catch (e) {
      print(e.toString());
    }

    final RenderBox box = context.findRenderObject();

    if (filePath.isNotEmpty) {
      await Share.shareFiles([filePath],
          text: 'Bill',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      print('Something went wrong!');
    }
  }

  printFile() async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    String filePath = "$dir/bill.pdf";
    File _file = File(filePath);
    print(filePath);
    try {
      await FirebaseStorage.instance
          .ref('${widget.email}/${widget.getPath}')
          .writeToFile(_file);
    } on FirebaseException catch (e) {
      print(e.toString());
    }
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => _file.readAsBytes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PDF.network(
          widget.getUrl,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22),
          backgroundColor: Colors.blue,
          visible: true,
          curve: Curves.bounceIn,
          children: [
            // FAB 1
            SpeedDialChild(
                child: Icon(Icons.share),
                backgroundColor: Colors.blue,
                onTap: () {
                  setState(() {
                    shareButton();
                  });
                },
                label: 'Share',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.blue),
            // FAB 2
            SpeedDialChild(
                child: Icon(Icons.print),
                backgroundColor: Colors.blue,
                onTap: () {
                  printFile();
                },
                label: 'Print',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.blue)
          ],
        ));
  }
}
