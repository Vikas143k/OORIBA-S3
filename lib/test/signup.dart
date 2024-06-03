// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:ooriba_s3/services/employeeService.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Employee App',
//       home: EmployeeForm(),
//     );
//   }
// }

// class EmployeeForm extends StatefulWidget {
//   @override
//   _EmployeeFormState createState() => _EmployeeFormState();
// }

// class _EmployeeFormState extends State<EmployeeForm> {
//   final _nameController = TextEditingController();
//   final _phoneNoController = TextEditingController();
//   final EmployeeService _employeeService = EmployeeService();

//   void _submitForm() async {
//     final name = _nameController.text;
//     final phoneNo = _phoneNoController.text;

//     // Pick image
//     final image = await _employeeService.pickImage();
//     if (image != null) {
//       // Upload data
//       await _employeeService.addEmployee(name, phoneNo, image);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Employee added successfully')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Employee'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             TextField(
//               controller: _phoneNoController,
//               decoration: InputDecoration(labelText: 'Phone Number'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _submitForm,
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
