import 'dart:io';

import 'package:billing_system/pdf/showDocuments.dart';
import 'package:billing_system/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

class Documents extends StatefulWidget {
  final String email;
  const Documents({Key key, this.email}) : super(key: key);
  @override
  _DocumentsState createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  List showKey = [], showValue = [];
  var urls = {};
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  void getdata() async {
    await FirebaseFirestore.instance
        .collection('Company')
        .doc(widget.email)
        .collection('Storage')
        .doc(widget.email)
        .get()
        .then((value) {
      urls = value.data()['FilePath'];
      List tempKey = [], tempValue = [];
      urls.forEach((key, value) {
        tempKey.add(key);
        tempValue.add(value);
      });
      for (int i = tempKey.length - 1; i >= 0; i--) {
        showKey.add(tempKey[i]);
        showValue.add(tempValue[i]);
      }
      print('-------------------');
      print(tempKey);
    });
    setState(() {
      loading = false;
    });
  }
//     final ref = FirebaseStorage.instance.ref().child('ag@gmail.com');
//     print(ref);
// // no need of the file extension, the name will do fine.
//     // var url = await ref.getDownloadURL();
//     final String dir = (await getApplicationDocumentsDirectory()).path;

//     ref.list(ListOptions(maxResults: 20)).then((result) async {
//       print(result.items);
//       print(result.items.length);
//       int k = 1;
//       for (var i in result.items) {
//         print(i.fullPath);
//         String temp = i.fullPath;
//         urls.add(
//             await FirebaseStorage.instance.ref(i.fullPath).getDownloadURL());
//         // var url = FirebaseStorage.instance.ref(i.fullPath).getDownloadURL();
//         // print(url.toString());
//         // String filePath = "$dir/$k.pdf";
//         // k++;
//         // File _file = File(filePath);
//         // print(filePath);
//         // try {
//         //   await FirebaseStorage.instance.ref(i.fullPath).writeToFile(_file);
//         // } on FirebaseException catch (e) {
//         //   print(e.toString());
//         // }
//       }
//       print('$k');
//       k++;
//     });
//     print(urls);

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : new Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text(
                  "Documents",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            body: ListView.builder(
                itemCount: showKey.length,
                itemBuilder: (context, position) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        return new ShowDocument(
                            email: widget.email,
                            getPath: showKey[position],
                            getUrl: showValue[position]);
                      }));
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          showKey[position],
                          style: TextStyle(fontSize: 17.0),
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
