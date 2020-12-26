import 'package:billing_system/pdf/reviewpdf.dart';
import 'package:billing_system/pdf/writepdf.dart';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets/document.dart';
import 'package:printing/printing.dart';
import 'package:share/share.dart';

class PDFCreator extends StatefulWidget {
  final String partyName,
      brokerName,
      product,
      brand,
      pan,
      otherExpenseName,
      email,
      filePath;
  final double rate,
      taxRate,
      taxRateHalf,
      panRate,
      weight,
      frightRate,
      otherExpenseRate;
  final Document pdf;
  const PDFCreator(
      {Key key,
      this.email,
      this.partyName,
      this.brokerName,
      this.product,
      this.brand,
      this.rate,
      this.weight,
      this.taxRate,
      this.taxRateHalf,
      this.pan,
      this.panRate,
      this.frightRate,
      this.otherExpenseName,
      this.otherExpenseRate,
      this.filePath,
      this.pdf})
      : super(key: key);
  @override
  _PDFCreatorState createState() => _PDFCreatorState();
}

class _PDFCreatorState extends State<PDFCreator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "Billing",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        'View',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                PdfViewerPage(path: widget.filePath),
                          ),
                        );
                      }),
                  RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        'Share',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.blue,
                      onPressed: () async {
                        final RenderBox box = context.findRenderObject();

                        if (widget.filePath.isNotEmpty) {
                          await Share.shareFiles([widget.filePath],
                              text: 'Bill',
                              sharePositionOrigin:
                                  box.localToGlobal(Offset.zero) & box.size);
                        } else {
                          print('Something went wrong!');
                        }
                      }),
                  RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        'Print',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.blue,
                      onPressed: () async {
                        await Printing.layoutPdf(
                            onLayout: (PdfPageFormat format) async =>
                                widget.pdf.save());
                      })
                ]),
          ),
        ));
  }
}
