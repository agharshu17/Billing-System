import 'package:Billing/pdf/reviewpdf.dart';
import 'package:Billing/pdf/writepdf.dart';
import 'package:Billing/screens/home.dart';
import 'package:Billing/shared/showAlertDialog.dart';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets/document.dart';
import 'package:printing/printing.dart';
import 'package:share/share.dart';

class PDFCreator extends StatefulWidget {
  final String filePath;
  final Document pdf;
  const PDFCreator({Key key, this.filePath, this.pdf}) : super(key: key);
  @override
  _PDFCreatorState createState() => _PDFCreatorState();
}

class _PDFCreatorState extends State<PDFCreator> {
  func() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Home(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    List items = [
      "View",
      "Share",
      "Print",
    ];
    List icons = [
      Icons.visibility,
      Icons.share,
      Icons.print,
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
                          size: 50,
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
              onPressed: () async {
                if (index == 0) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PdfViewerPage(path: widget.filePath),
                    ),
                  );
                } else if (index == 1) {
                  final RenderBox box = context.findRenderObject();

                  if (widget.filePath.isNotEmpty) {
                    await Share.shareFiles([widget.filePath],
                        text: 'Bill',
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size);
                  } else {
                    print('Something went wrong!');
                  }
                } else if (index == 2) {
                  await Printing.layoutPdf(
                      onLayout: (PdfPageFormat format) async =>
                          widget.pdf.save());
                }
              },
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Billing')),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Home',
            onPressed: () {
              showAlertDialog(context, 'Cancel', 'Leave', 'Go To Home',
                  'Are you sure you want to leave this Page?', func);
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
                    left: 100, right: 100, top: 30, bottom: 40),
                child: Center(
                  child: GridView.count(
                    crossAxisCount: 1,
                    children: List.generate(3, (index) {
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
