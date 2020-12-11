// import 'package:dropdownfield/dropdownfield.dart';
// import 'package:flutter/material.dart';

// class PartyBroker extends StatefulWidget {
//   final String email;

//   const PartyBroker({Key key, this.email}) : super(key: key);

//   @override
//   _PartyBrokerState createState() => _PartyBrokerState();
// }

// class _PartyBrokerState extends State<PartyBroker> {
//   String party;
//   List<String> partyList = ['a', 'b', 'c', 'd'];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: Text(
//             "Billing",
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             DropDownField(
//               onValueChanged: (value) {
//                 party = value;
//               },
//               value: party,
//               required: false,
//               hintText: 'Select Party',
//               labelText: 'Party',
//               items: partyList,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
