import 'package:billing_system/party/editexistingparty.dart';
import 'package:billing_system/screens/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  String selectedResult;
  String email;
  final List<dynamic> listExample;
  Search(this.listExample, this.email);
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    print('-----------');
    print(selectedResult);
    return new EditExistingParty(
      name: selectedResult,
      email: email,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> suggestionList = [];
    if (query.isNotEmpty) {
      suggestionList = [];
      suggestionList.addAll(listExample.where(
          (element) => element.toLowerCase().contains(query.toLowerCase())));
      print(suggestionList);
    }
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestionList[index]),
            onTap: () {
              selectedResult = suggestionList[index];
              showResults(context);
            },
          );
        });
  }
}

class ExistingParty extends StatefulWidget {
  final String email;
  const ExistingParty({Key key, this.email}) : super(key: key);
  @override
  _ExistingPartyState createState() => _ExistingPartyState();
}

class _ExistingPartyState extends State<ExistingParty> {
  var values, name;
  var stringvalues;
  @override
  void initState() {
    // TODO: implement initState

    values = [];
    stringvalues = [];
    super.initState();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Delete"),
      onPressed: () {
        FirebaseFirestore.instance
            .collection('Company')
            .doc(widget.email)
            .collection('Party Name')
            .doc(name)
            .delete()
            .then((value) => print('success'));
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete the Party"),
      content: Text("Are you sure you want to delete the party?"),
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

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Company')
          .doc(widget.email)
          .collection('Party Name')
          .snapshots(),
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            values = [];
            stringvalues = [];
            snapshot.data.docs.forEach((doc) {
              values.add(doc.data()['Name']);
              stringvalues.add(doc.data()['Name'].toString());
              print(values);
            });
            return values != null
                ? new Scaffold(
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(40),
                      child: AppBar(
                        leading: Container(),
                        title: Text(
                          'Search by Clicking the Icon',
                          style: TextStyle(fontSize: 15, color: Colors.white60),
                        ),
                        actions: <Widget>[
                          IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                showSearch(
                                    context: context,
                                    delegate:
                                        Search(stringvalues, widget.email));
                              })
                        ],
                      ),
                    ),
                    body: ListView.builder(
                        itemCount: values.length,
                        itemBuilder: (context, position) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute<Null>(
                                      builder: (BuildContext context) {
                                return new EditExistingParty(
                                  name: values[position].toString(),
                                  email: widget.email,
                                );
                              }));
                            },
                            onLongPress: () {
                              name = values[position].toString();
                              showAlertDialog(context);
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  values[position].toString(),
                                  style: TextStyle(fontSize: 22.0),
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : Center(
                    child: Container(
                    width: 300,
                    child: Text(
                      'Error!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'acumin-pro',
                        fontSize: 22,
                      ),
                    ),
                  ));
        }
      },
    );
  }
}
