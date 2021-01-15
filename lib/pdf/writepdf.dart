import 'package:billing_system/pdf/createpdf.dart';
import 'package:billing_system/services/databasepdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:json_table/json_table.dart';

reportView(
    context,
    email,
    partyName,
    brokerName,
    invoice,
    productList,
    taxRate,
    taxRateHalf,
    interstate,
    pan,
    panRate,
    frightRate,
    rate,
    transport,
    otherExpenseName,
    otherExpenseRate) async {
  var value = DatabasePdf(email: email);
  await value.companyInfo();
  await value.partyInfo(partyName);
  await value.brokerInfo(brokerName);
  await value.bankDescription();
  value.transportInfo(transport);
  String cgst = "", igst = "";
  double cgstAmount = 0, igstAmount = 0;

  int k = 0;
  final Document pdf = Document();
  DateTime now = new DateTime.now();
  String date = DateFormat('yMd').format(now);

  double packaging = 0, quantity = 0, amount = 0;

  for (var x in productList) {
    packaging += x['Packaging'];
    quantity += x['Weight'];
    amount += x['Rate'];
  }

  if (taxRateHalf == 0) {
    igst = taxRate.toString();
    igstAmount = amount * taxRate / 100;
  } else if (taxRate == 0) {
    cgst = taxRateHalf.toString();
    cgstAmount = amount * taxRateHalf / 100;
  }

  int toPay =
      (rate['Net'] + frightRate['TotalFright'] + otherExpenseRate).round();
  String toPayWords = NumberToWord().convert('en-in', toPay);

  print(productList);

  pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      //.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        // if (context.pageNumber == 1) {
        //   return null;
        // }
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(),
            child: Text('Bill of Supply',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      footer: (Context context) {
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: Text('This is a Computer generated Invoice.',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => <Widget>[
            Header(
              level: 0,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide.none,
                        top: BorderSide.none,
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('GSTIN: ${value.companyGst}',
                                  style: TextStyle(fontSize: 10)),
                              Text('FSSAI: ${value.companyFssai}',
                                  style: TextStyle(fontSize: 10)),
                              Text('State: Maharashtra',
                                  style: TextStyle(fontSize: 10)),
                              Text('State Code: 27',
                                  style: TextStyle(fontSize: 10)),
                            ],
                          ),
                          Text('TAX INVOICE/ BILL OF SUPPLY',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('STD: 0724', style: TextStyle(fontSize: 10)),
                              Text('Off: ${value.companyOfficeContact}',
                                  style: TextStyle(fontSize: 10)),
                              Text('Fact: ${value.companyFactoryContact}',
                                  style: TextStyle(fontSize: 10)),
                              Text('Mob: ${value.companyMobileContact}',
                                  style: TextStyle(fontSize: 10)),
                            ],
                          ), // Need this to be

                          // PdfLogo()
                        ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide.none,
                        top: BorderSide.none,
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${value.companyName}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                              Text('Off: ${value.companyOfficeAddress}',
                                  style: TextStyle(fontSize: 8)),
                              Text('Fact: ${value.companyFactoryAddress}',
                                  style: TextStyle(fontSize: 8)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('    '),
                              Text(
                                'Invoice No.: $invoice',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10),
                              ),
                              Text('Date: $date',
                                  style: TextStyle(fontSize: 10)),
                            ],
                          ), // Need this to be

                          // PdfLogo()
                        ]),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  // width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Buyer',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10)),
                      Text('Name: $partyName', style: TextStyle(fontSize: 10)),
                      Text('Email: ${value.partyEmail}',
                          style: TextStyle(fontSize: 10)),
                      Text('Address: ${value.partyAddress}',
                          style: TextStyle(fontSize: 10)),
                      Text('Off: ${value.partyOfficeContact}',
                          style: TextStyle(fontSize: 10)),
                      Text('Mobile: ${value.partyMobileContact}',
                          style: TextStyle(fontSize: 10)),
                      Text('State: ', style: TextStyle(fontSize: 10)),
                      Text('State Code: ', style: TextStyle(fontSize: 10)),
                      Text('GSTIN: ${value.partyGst}',
                          style: TextStyle(fontSize: 10)),
                      Text('FSSAI: ${value.partyFssai}',
                          style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Canvassing Agent',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10)),
                    Text('Name: $brokerName', style: TextStyle(fontSize: 10)),
                    Text('Mobile: ${value.agentMobileContact}',
                        style: TextStyle(fontSize: 10)),
                    SizedBox(height: 12),
                    Text('Transportation Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10)),
                    Text('Name: ${value.transportName}',
                        style: TextStyle(fontSize: 10)),
                    Text('Vehicle No.: ${value.transportVehicle}',
                        style: TextStyle(fontSize: 10)),
                    Text(
                        'Fright Rate: ${frightRate['frightRatePerQuintal'].toString()}',
                        style: TextStyle(fontSize: 10)),
                    Text('(per quintal)', style: TextStyle(fontSize: 8)),
                    Text('Advance: ${frightRate['Advance'].toString()}',
                        style: TextStyle(fontSize: 10)),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            Table(
              children: [
                TableRow(
                  decoration: new BoxDecoration(
                      border:
                          Border.symmetric(horizontal: BorderSide(width: .25))),
                  children: [
                    Text('No.', textScaleFactor: .75),
                    Text('Description of Goods', textScaleFactor: .75),
                    Text('HSN', textScaleFactor: .75),
                    Text('Packaging (kg)', textScaleFactor: .75),
                    Text('No. of Bags', textScaleFactor: .75),
                    Text('Quantity (quintals)', textScaleFactor: .75),
                    Text('Rate per quintal', textScaleFactor: .75),
                    Text('Amount (Rs)', textScaleFactor: .75),
                    SizedBox(height: 20),
                  ],
                ),
                for (var i in productList)
                  TableRow(children: [
                    Text('${++k}', textScaleFactor: .75),
                    for (var j in i.values) Text('$j', textScaleFactor: .75),
                    SizedBox(height: 20),
                  ]),
                for (int l = k; l < 6; l++)
                  TableRow(children: [SizedBox(height: 20)]),
                TableRow(
                  decoration: new BoxDecoration(
                      border:
                          Border.symmetric(horizontal: BorderSide(width: .25))),
                  children: [
                    Text(''),
                    Text('Total', textScaleFactor: .75),
                    Text(''),
                    Text('${packaging.toString()}', textScaleFactor: .75),
                    Text('', textScaleFactor: .75),
                    Text('${quantity.toString()}', textScaleFactor: .75),
                    Text('', textScaleFactor: .75),
                    Text('${amount.toString()}', textScaleFactor: .75),
                    SizedBox(height: 20),
                  ],
                ),
              ],
              border: TableBorder.ex(
                  horizontalInside: BorderSide.none,
                  bottom: BorderSide(width: .25),
                  top: BorderSide(width: .25),
                  right: BorderSide(width: .25),
                  left: BorderSide(width: .25),
                  verticalInside: BorderSide(width: .25)),
              columnWidths: {
                0: FlexColumnWidth(0.5),
                1: FlexColumnWidth(4.5),
                2: FlexColumnWidth(2.5),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(2),
                6: FlexColumnWidth(3),
                7: FlexColumnWidth(3.5),
              },
            ),
            SizedBox(
              height: 20,
            ),
            Table(children: [
              TableRow(children: [
                Text('Amount',
                    textScaleFactor: .75,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('SGST  $cgst%', textScaleFactor: .75),
                Text('CGST  $cgst%', textScaleFactor: .75),
                Text('IGST   $igst%', textScaleFactor: .75),
                Text('TCS   ${panRate.toString()}%', textScaleFactor: .75),
                Text('Net Payment',
                    textScaleFactor: .75,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Transport Cost', textScaleFactor: .75),
                Text('Other Expenses - $otherExpenseName',
                    textScaleFactor: .75),
                Text('To Pay',
                    textScaleFactor: .75,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
              ]),
              TableRow(children: [
                Text('${amount.toString()}', textScaleFactor: .75),
                Text('$cgstAmount', textScaleFactor: .75),
                Text('$cgstAmount', textScaleFactor: .75),
                Text('$igstAmount', textScaleFactor: .75),
                Text('${rate['TCS'].toString()}', textScaleFactor: .75),
                Text('${rate['Net'].toString()}', textScaleFactor: .75),
                Text('${frightRate['TotalFright'].toString()}',
                    textScaleFactor: .75),
                Text('${otherExpenseRate.toString()}', textScaleFactor: .75),
                Text('${toPay.toString()}', textScaleFactor: .75),
                SizedBox(height: 20),
              ]),
            ], columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(2),
              6: FlexColumnWidth(1.5),
              7: FlexColumnWidth(1.5),
              8: FlexColumnWidth(2)
            }, border: TableBorder.all(width: 0.25)),
            SizedBox(
              height: 3,
            ),
            Text('Amount Chargeable (in words)', style: TextStyle(fontSize: 8)),
            Text('Indian Rupees ${toPayWords}Only',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),

            SizedBox(
              height: 20,
            ),
            Container(
                child: Row(children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    Text('BANK: ${value.bankName}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10)),
                    Text('Declaration: ${value.description}',
                        style: TextStyle(fontSize: 8)),
                  ]),
                  TableRow(children: [
                    Text('A/C No.: ${value.accountNumber}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10)),
                  ]),
                  TableRow(children: [
                    Text('RTGS/NEFT Code: ${value.ifsc}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10)),
                  ]),
                ],
                columnWidths: {
                  0: FixedColumnWidth(170),
                  1: FixedColumnWidth(313)
                },
                border: TableBorder.ex(
                    horizontalInside: BorderSide.none,
                    bottom: BorderSide(width: .75),
                    top: BorderSide(width: .75),
                    right: BorderSide(width: .75),
                    left: BorderSide(width: .75),
                    verticalInside: BorderSide(width: .75)),
              ),

              // Table(children: [
              //   TableRow(children: [
              //     Text('Declaration: ${value.description}',
              //         maxLines: 5, style: TextStyle(fontSize: 8)),
              //   ]),
              // ], border: TableBorder.all(width: .5))
            ]))
            //   TableRow(
            //     // decoration: new BoxDecoration(
            //     //     border:
            //     //         Border.symmetric(horizontal: BorderSide(width: .25))),
            //     children: [
            //       Text(''),
            //       Text('SGST  $cgst%', textScaleFactor: .75),
            //       Text('$cgstAmount', textScaleFactor: .75),
            //       SizedBox(height: 15),
            //     ],
            //   ),
            //   TableRow(
            //     // decoration: new BoxDecoration(
            //     //     border:
            //     //         Border.symmetric(horizontal: BorderSide(width: .25))),
            //     children: [
            //       Text(''),
            //       Text('CGST  $cgst%', textScaleFactor: .75),
            //       Text('$cgstAmount', textScaleFactor: .75),
            //       SizedBox(height: 15),
            //     ],
            //   ),
            //   TableRow(
            //     // decoration: new BoxDecoration(
            //     //     border:
            //     //         Border.symmetric(horizontal: BorderSide(width: .25))),
            //     children: [
            //       Text(''),
            //       Text('IGST   $igst%', textScaleFactor: .75),
            //       Text('$igstAmount', textScaleFactor: .75),
            //       SizedBox(height: 15),
            //     ],
            //   ),
            //   TableRow(
            //     // decoration: new BoxDecoration(
            //     //     border:
            //     //         Border.symmetric(horizontal: BorderSide(width: .25))),
            //     children: [
            //       Text(''),
            //       Text('TCS   ${panRate.toString()}%', textScaleFactor: .75),
            //       Text('${rate['TCS'].toString()}', textScaleFactor: .75),
            //       SizedBox(height: 15),
            //     ],
            //   ),
            //   TableRow(
            //     // decoration: new BoxDecoration(
            //     //     border:
            //     //         Border.symmetric(horizontal: BorderSide(width: .25))),
            //     children: [
            //       Text(''),
            //       Text('Net Payment',
            //           textScaleFactor: .75,
            //           style: TextStyle(fontWeight: FontWeight.bold)),
            //       Text('${rate['Net'].toString()}', textScaleFactor: .75),
            //       SizedBox(height: 20),
            //     ],
            //   ),
            //   TableRow(
            //     // decoration: new BoxDecoration(
            //     //     border:
            //     //         Border.symmetric(horizontal: BorderSide(width: .25))),
            //     children: [
            //       Text(''),
            //       Text('Transport Cost', textScaleFactor: .75),
            //       Text('${frightRate['TotalFright'].toString()}',
            //           textScaleFactor: .75),
            //       SizedBox(height: 15),
            //     ],
            //   ),
            //   TableRow(
            //     // decoration: new BoxDecoration(
            //     //     border:
            //     //         Border.symmetric(horizontal: BorderSide(width: .25))),
            //     children: [
            //       Text(''),
            //       Text('Other Expenses - $otherExpenseName',
            //           textScaleFactor: .75),
            //       Text('${otherExpenseRate.toString()}', textScaleFactor: .75),
            //       SizedBox(height: 15),
            //     ],
            //   ),
            //   TableRow(
            //     // decoration: new BoxDecoration(
            //     //     border:
            //     //         Border.symmetric(horizontal: BorderSide(width: .25))),
            //     children: [
            //       Text(''),
            //       Text('Total Payment',
            //           textScaleFactor: .75,
            //           style: TextStyle(fontWeight: FontWeight.bold)),
            //       Text(
            //           '${(rate['Net'] + frightRate['TotalFright'] + otherExpenseRate).toString()}',
            //           textScaleFactor: .75),
            //       SizedBox(height: 20),
            //     ],
            //   ),
            // ], columnWidths: {
            //   0: FlexColumnWidth(13.5),
            //   1: FlexColumnWidth(3),
            //   2: FlexColumnWidth(3.5),
            // }

            //   Header(level: 1, text: 'What is Lorem Ipsum?'),
            //   Paragraph(
            //       text:
            //           'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
            //   Paragraph(
            //       text:
            //           'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using "Content here, content here", making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for "lorem ipsum" will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).'),
            //   Header(level: 1, text: 'Where does it come from?'),
            //   Paragraph(
            //       text:
            //           'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
            //   Paragraph(
            //       text:
            //           'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
            //   Padding(padding: const EdgeInsets.all(10)),
            //   Table.fromTextArray(context: context, data: const <List<String>>[
            //     <String>['Year', 'Ipsum', 'Lorem'],
            //     <String>['2000', 'Ipsum 1.0', 'Lorem 1'],
            //     <String>['2001', 'Ipsum 1.1', 'Lorem 2'],
            //     <String>['2002', 'Ipsum 1.2', 'Lorem 3'],
            //     <String>['2003', 'Ipsum 1.3', 'Lorem 4'],
            //     <String>['2004', 'Ipsum 1.4', 'Lorem 5'],
            //     <String>['2004', 'Ipsum 1.5', 'Lorem 6'],
            //     <String>['2006', 'Ipsum 1.6', 'Lorem 7'],
            //     <String>['2007', 'Ipsum 1.7', 'Lorem 8'],
            //     <String>['2008', 'Ipsum 1.7', 'Lorem 9'],
            //   ]),
          ]));
  print(NumberToWord().convert('en-in', 5748));
  //save PDF

  // final String dir = (await getApplicationDocumentsDirectory()).path;
  // final String path = '$dir/report.pdf';
  // final File file = File(path);
  // print("-----------------------------------------------------------");
  // print(path);
  // await file.writeAsBytes(pdf.save());
  // material.Navigator.of(context).push(
  //   material.MaterialPageRoute(
  //     builder: (_) => PdfViewerPage(path: path),
  //   ),
  // );

//  DateTime now = new DateTime.now();
  final String dir = (await getApplicationDocumentsDirectory()).path;
  // final String path = '$dir/report.pdf';
  String filePath = "$dir/$now-$partyName.pdf";
  String firebasePath = "$now-$partyName.pdf";
  //firebasePath += partyName + '_' + now.toString() + '.pdf';
  File _file = File(filePath);
  await _file.writeAsBytes(pdf.save());
  Reference ref = FirebaseStorage.instance.ref().child('$email/$firebasePath');

  print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
  print(ref);
  print(_file);

  final storageReference = FirebaseStorage.instance.ref().child(email);
  var deleteElementurl = {};
  var deleteValue = "", deleteKey = "";

  await storageReference.listAll().then((result) async {
    print(result.items);
    print(result.items.length);
    if (result.items.length >= 10) {
      var x = result.items.elementAt(0);
      var url = await FirebaseStorage.instance.ref(x.fullPath).getDownloadURL();
      deleteValue = url.toString();
      deleteKey = x.fullPath;
      deleteKey = deleteKey.substring(deleteKey.indexOf('/') + 1);
      deleteKey.trim();
      x.delete().then((value) {
        print("success");
      });
    }
    print(result.items.length);
  });

  UploadTask _uploadTask = ref.putFile(_file);
  TaskSnapshot x = await _uploadTask.then((TaskSnapshot snapshot) {
    print('Upload complete!');
  }).catchError((Object e) {
    print('-----------------');
    print(e); // FirebaseException
  });
  var uploadFileUrl = {};
  var uploadValue = await (await _uploadTask).ref.getDownloadURL();
  var uploadKey = (await _uploadTask).ref.fullPath;
  uploadKey = uploadKey.substring(uploadKey.indexOf("/") + 1);
  uploadKey.trim();
  // print(uploadFileURL);
  print(uploadKey);
  print(deleteKey);
  print(uploadValue);
  print(deleteValue);

  if (deleteValue != "") {
    FirebaseFirestore.instance
        .collection('Company')
        .doc(email)
        .collection('Storage')
        .doc(email)
        .set({
      "FilePath": {
        deleteKey: FieldValue.delete(),
      }
    }, SetOptions(merge: true));
  }
  print('HI-----------');
  FirebaseFirestore.instance
      .collection('Company')
      .doc(email)
      .collection('Storage')
      .doc(email)
      .set({
    "FilePath": {
      uploadKey: uploadValue.toString(),
    }
  }, SetOptions(merge: true));

  material.Navigator.of(context).push(material.MaterialPageRoute<Null>(
      builder: (material.BuildContext context) {
    return new PDFCreator(
        email: email,
        partyName: partyName,
        brokerName: brokerName,
        invoice: invoice,
        productList: productList,
        taxRate: taxRate,
        taxRateHalf: taxRateHalf,
        interstate: interstate,
        pan: pan,
        panRate: panRate,
        frightRate: frightRate,
        otherExpenseName: otherExpenseName,
        otherExpenseRate: otherExpenseRate,
        filePath: filePath,
        pdf: pdf);
  }));

  // var image;
  // await for (var page in Printing.raster(pdf.save())) {
  //   image = page.toImage();
  //   print(image);
  // }

  // AndroidIntent intent = AndroidIntent(
  //   action: 'action_view',
  //   data: 'https://play.google.com/store/apps/details?'
  //       'id=com.google.android.apps.myapp',
  //   arguments: {'authAccount': 'harshitaa2000@gmail.com'},
  // );
  // await intent.launch();

  // android_intent.Intent()
  //   ..setAction(android_action.Action.ACTION_SEND)
  //   ..setPackage("com.whatsapp")
  //   ..putExtra(Extra.EXTRA_TEXT, 'Hi')
  //   ..startActivityForResult().then(
  //     (data) => print(data),
  //     onError: (e) => print(e.toString()),
  //   );

  // android_intent.Intent()
  //   ..setAction(android_action.Action.ACTION_IMAGE_CAPTURE)
  //   ..startActivityForResult()
  //       .then((data) => print(data[0]), // gets you path to image captured
  //           onError: (e) => print(e.toString()));

  // Uri imageUri = Uri.parse(pictureFile.getAbsolutePath());
  //   Intent shareIntent = new Intent();
  //   shareIntent.setAction(Intent.ACTION_SEND);
  //   //Target whatsapp:
  //   shareIntent.setPackage("com.whatsapp");
  //   //Add text and then Image URI
  //   shareIntent.putExtra(Intent.EXTRA_TEXT, picture_text);
  //   shareIntent.putExtra(Intent.EXTRA_STREAM, imageUri);
  //   shareIntent.setType("image/jpeg");
  //   shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

  //   try {
  //       startActivity(shareIntent);
  //   } catch (android.content.ActivityNotFoundException ex) {
  //       ToastHelper.MakeShortText("Whatsapp have not been installed.");
  //   }

  // File testFile = _file;
  // if (!await testFile.exists()) {
  //   await testFile.create(recursive: true);
  //   testFile.writeAsStringSync("test for share documents file");
  // }
  // ShareExtend.share(filePath, "file");

  // List<int> imageBytes = _file.readAsBytesSync();
  // print(imageBytes);
  // String base64Image = base64Encode(imageBytes);

  // void launchWhatsApp(
  //   {@required String phone,
  //   @required String message,
  //   }) async {

  // String message = 'Hi';

  // final material.RenderBox box = context.findRenderObject();
  // Share.shareFiles([filePath],
  //     text: 'Great picture',
  //     sharePositionOrigin: box.localToGlobal(material.Offset.zero) & box.size);

  // FlutterShareMe().shareToWhatsApp(base64Image: base64Image, msg: 'Hi');
  // print('Bye');

  // String url() {
  //   return "whatsapp://send?phone=919552511639&text=$base64Image";
  // }

  // if (await canLaunch(url())) {
  //   await launch(url());
  // } else {
  //   throw 'Could not launch ${url()}';
  // }

// }
}
