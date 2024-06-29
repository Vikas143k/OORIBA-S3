// import 'package:flutter/material.dart';
// import 'package:ooriba_s3/HR/registered_employees_page.dart';
// import 'package:ooriba_s3/facial/RecognitionScreen.dart';
// import 'package:ooriba_s3/editpersonaldetails.dart';
// import 'package:ooriba_s3/services/auth_service.dart'; // Import the new page

// class PostLoginPage extends StatelessWidget {
//   final String email;
//   final Map<String, dynamic> userDetails;

//   const PostLoginPage({Key? key, required this.email, required this.userDetails}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ooriba-S3'),
//          actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthService().signout(context: context);
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RecognitionScreen(email: email)),
//                 );
//               },
//               child: const Text('Go to Face Recognition Page'),
//             ),
//             const SizedBox(height: 20),
            
//             const SizedBox(height: 20),
//             // ElevatedButton(
//             //   onPressed: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //         builder: (context) => EditPersonalDetailsPage(
//             //           email: email,
//             //           userDetails: userDetails,
//             //         ),
//             //       ),
//             //     );
//             //   },
//             //   child: const Text('Edit Personal Details'),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:ooriba_s3/editpersonaldetails.dart';
import 'package:ooriba_s3/employee_checkin_page.dart';
import 'package:ooriba_s3/facial/DB/DatabaseHelper.dart';
import 'package:ooriba_s3/facial/HomeScreen.dart';
import 'package:ooriba_s3/facial/RecognitionScreen.dart';
import 'package:ooriba_s3/facial/RegistrationScreen.dart';
import 'package:ooriba_s3/services/auth_service.dart';
import 'package:ooriba_s3/services/retrieveDataByEmail.dart';

class PostLoginPage extends StatefulWidget {
  final String email;
  final Map<String, dynamic> userDetails;

  const PostLoginPage({Key? key, required this.email, required this.userDetails}) : super(key: key);

  @override
  _PostLoginPageState createState() => _PostLoginPageState();
}
class _PostLoginPageState extends State<PostLoginPage> {
  final FirestoreService firestore_Service = FirestoreService();
  late DatabaseHelper dbHelper;
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    _checkIfFaceIsRegistered();
  }

  Future<void> _checkIfFaceIsRegistered() async {
    await dbHelper.init();
    final allRows = await dbHelper.queryAllRows();
    setState(() {
      isRegistered = allRows.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ooriba-S3'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signout(context: context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => RecognitionScreen(email: widget.email)),
            //     );
            //   },
            //   child: const Text('Go to Face Recognition Page'),
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (isRegistered) {
                  Map<String, dynamic>? employeeData = await firestore_Service.searchEmployee(email: widget.email);
                  String firstName = employeeData != null ? employeeData['firstName'] ?? '' : '';
                   Navigator.push(
                          context,
                          MaterialPageRoute(
            builder: (BuildContext context) =>
                HomeScreen(email:widget.email),
          ),
                        );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationScreen()),
                  );
                }
              },
              child: Text(isRegistered ? 'Attendance' : 'Register for Facial Authentication'),
            ),
            const SizedBox(height: 20),
            //  ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => EditPersonalDetailsPage(
            //           email:widget.email,
            //         ),
            //       ),
            //     );
            //   },
            //   child: const Text('Edit Personal Details'),
            // ),
          ],
        ),
      ),
    );
  }
}
