// import 'package:flutter/material.dart';
// import 'package:ooriba_s3/services/updateEmployee.dart';

// class SetPage extends StatefulWidget {
//   @override
//   _SetPageState createState() => _SetPageState();
// }

// class _SetPageState extends State<SetPage> {
//   final FirestoreService _firestoreService = FirestoreService();
//   final TextEditingController _firstNameController = TextEditingController();
//   final DateTime _checkIn = DateTime.now();
//   final DateTime _checkOut = DateTime.now().add(Duration(hours: 8));
//   bool _isLoading = false;

//   void _addData() async {
//     String firstName = _firstNameController.text;
//     if (firstName.isNotEmpty) {
//       setState(() {
//         _isLoading = true;
//       });

//       await _firestoreService.addCheckInOutData(firstName, _checkIn, _checkOut,DateTime.now());

//       setState(() {
//         _isLoading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Data added successfully')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a first name')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Set Page'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _firstNameController,
//               decoration: InputDecoration(labelText: 'First Name'),
//             ),
//             SizedBox(height: 20),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _addData,
//                     child: Text('Add Data'),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
