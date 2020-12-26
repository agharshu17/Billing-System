import 'package:billing_system/pdf/createpdf.dart';
import 'package:billing_system/pdf/reviewpdf.dart';
import 'package:android_intent/android_intent.dart';
import 'package:android_intent/flag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:intent/extra.dart';
import 'package:share/share.dart';
// import 'package:intent/extra.dart';
import 'package:printing/printing.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;
import 'dart:convert';

reportView(
    context,
    email,
    partyName,
    brokerName,
    product,
    brand,
    rate,
    weight,
    taxRate,
    taxRateHalf,
    pan,
    panRate,
    frightRate,
    otherExpenseName,
    otherExpenseRate) async {
  final Document pdf = Document();

  pdf.addPage(MultiPage(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(),
            child: Text('Report',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      footer: (Context context) {
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => <Widget>[
            Header(
                level: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Report', textScaleFactor: 2),
                      PdfLogo()
                    ])),
            Header(level: 1, text: 'What is Lorem Ipsum?'),
            Paragraph(
                text:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
            Paragraph(
                text:
                    'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using "Content here, content here", making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for "lorem ipsum" will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).'),
            Header(level: 1, text: 'Where does it come from?'),
            Paragraph(
                text:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
            Paragraph(
                text:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
            Padding(padding: const EdgeInsets.all(10)),
            Table.fromTextArray(context: context, data: const <List<String>>[
              <String>['Year', 'Ipsum', 'Lorem'],
              <String>['2000', 'Ipsum 1.0', 'Lorem 1'],
              <String>['2001', 'Ipsum 1.1', 'Lorem 2'],
              <String>['2002', 'Ipsum 1.2', 'Lorem 3'],
              <String>['2003', 'Ipsum 1.3', 'Lorem 4'],
              <String>['2004', 'Ipsum 1.4', 'Lorem 5'],
              <String>['2004', 'Ipsum 1.5', 'Lorem 6'],
              <String>['2006', 'Ipsum 1.6', 'Lorem 7'],
              <String>['2007', 'Ipsum 1.7', 'Lorem 8'],
              <String>['2008', 'Ipsum 1.7', 'Lorem 9'],
            ]),
          ]));
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

  DateTime now = new DateTime.now();
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
        product: product,
        brand: brand,
        rate: rate,
        weight: weight,
        taxRate: taxRate,
        taxRateHalf: taxRateHalf,
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
