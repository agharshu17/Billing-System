import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDF.network(
        widget.getUrl,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.share),
        onPressed: () {
          shareButton();
        },
      ),
    );
  }
}
