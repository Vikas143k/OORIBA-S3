// import 'package:flutter/material.dart';
// import 'package:ooriba_s3/services/retrieveDataByEmail.dart';
// class EmployeeSearchPage extends StatefulWidget {
//   @override
//   _EmployeeSearchPageState createState() => _EmployeeSearchPageState();
// }

// class _EmployeeSearchPageState extends State<EmployeeSearchPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final FirestoreService _firestoreService = FirestoreService();

//   String _name = '';
//   String _phoneNumber = '';
//   String _imgURL='';

//   void _searchEmployee() async {
//     final email = _emailController.text;
//     if (email.isNotEmpty) {
//       final employeeData = await _firestoreService.getEmployeeByEmail(email);
//       if (employeeData != null) {
//         setState(() {
//           _name = employeeData['firstName'] ?? 'N/A';
//           _phoneNumber = employeeData['phoneNo'] ?? 'N/A';
//           _imgURL=employeeData["dpImageUrl"]?? 'N/A';
//         }); 
//       } else {
//         setState(() {
//           _name = 'Not Found';
//           _phoneNumber = 'Not Found';
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Employee Search')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Enter Email'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _searchEmployee,
//               child: Text('Search'),
//             ),
//             SizedBox(height: 20),
//             if (_name.isNotEmpty)
//               Text('Name: $_name'),
//             if (_phoneNumber.isNotEmpty)
//               Text('Phone Number: $_phoneNumber'),
//             if (_imgURL.isNotEmpty)
//             Image.network(
//            _imgURL,
//           // Add additional parameters if needed, e.g., width, height, fit, etc.
//           // fit: BoxFit.cover,
//             ),
//               Text('IMG: $_imgURL'),
//                 // width: 300,
//           // height: 300,
//           ],
//         ),
//       ),
//     );
//   }
// }
