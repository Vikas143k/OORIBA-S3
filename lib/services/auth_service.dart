
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:ooriba_s3/HR/hr_dashboard_page.dart';
// import 'package:ooriba_s3/employee_checkin_page.dart';
// import 'package:ooriba_s3/employee_signup_success.dart';
// import 'package:ooriba_s3/facial/HomeScreen.dart';
// import 'package:ooriba_s3/main.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
  
//   Future<void> signup({
//     required String email,
//     required String password,
//     required BuildContext context,
//   }) async {
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       await Future.delayed(const Duration(seconds: 1));
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ConfirmationPage()),
//       );
//     } on FirebaseAuthException catch (e) {
//       String message = '';
//       if (e.code == 'weak-password') {
//         message = 'The password provided is too weak.';
//       } else if (e.code == 'email-already-in-use') {
//         message = 'An account already exists with that email.';
//       }
//       Fluttertoast.showToast(
//         msg: message,
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.SNACKBAR,
//         backgroundColor: Colors.black54,
//         textColor: Colors.white,
//         fontSize: 14.0,
//       );
//     }
//   }
//   //   Future<bool> signin({
// //     required String email,
// //     required String password,
// //     required String role,
// //     required BuildContext context,
// //   }) async {
// //     final FirestoreService firestore_Service = FirestoreService();
// //     Map<String, dynamic>? employeeData = await firestore_Service.searchEmployee(email: email);

// //     try {
// //       await FirebaseAuth.instance.signInWithEmailAndPassword(
// //         email: email,
// //         password: password,
// //       );

// //       await Future.delayed(const Duration(seconds: 1));
// //       if (role == "employee") {
// //         String firstName = employeeData != null ? employeeData['firstName'] ?? '' : '';
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(
// //             builder: (BuildContext context) => EmployeeCheckInPage(empname: firstName, empemail: email),
// //           ),
// //         );
// //       } else {
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(
// //             builder: (BuildContext context) => const HRDashboardPage(),
// //           ),
// //         );
// //       }
// //       return true;
// //     } on FirebaseAuthException catch (e) {
// //       String message = '';
// //       if (e.code == 'invalid-email') {
// //         message = 'No user found for that email.';
// //       } else if (e.code == 'invalid-credential') {
// //         message = 'Wrong password provided for that user.';
// //       }
// //       Fluttertoast.showToast(
// //         msg: message,
// //         toastLength: Toast.LENGTH_LONG,
// //         gravity: ToastGravity.SNACKBAR,
// //         backgroundColor: Colors.black54,
// //         textColor: Colors.white,
// //         fontSize: 14.0,
// //       );
// //       return false;
// //     }

//   Future<bool> signin({
//     required String email,
//     required String password,
//     required BuildContext context,
//   }) async {
//     try {
//       // Fetch the document from the Firestore collection "Regemp"
//       DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
//           await FirebaseFirestore.instance
//               .collection('Regemp')
//               .doc(email)
//               .get();

//       // Check if the document exists
//       if (!documentSnapshot.exists) {
//         Fluttertoast.showToast(
//           msg: 'No user found for that email.',
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.SNACKBAR,
//           backgroundColor: Colors.black54,
//           textColor: Colors.white,
//           fontSize: 14.0,
//         );
//         return false;
//       }

//       // Retrieve the role from the document
//       String role = documentSnapshot.data()?['role'] ?? '';

//       // Sign in with Firebase Authentication
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Navigate to the appropriate page based on the role
//       await Future.delayed(const Duration(seconds: 1));
//       if (role == "Standard") {
//         String firstName = documentSnapshot.data()?['firstName'] ?? '';
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (BuildContext context) =>
//                 HomeScreen(email: email),
//           ),
//           // MaterialPageRoute(
//           //   builder: (BuildContext context) =>
//           //       EmployeeCheckInPage(empname: firstName, empemail: email),
//           // ),
//         );
//         return true;
//       } else if (role == "HR") {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (BuildContext context) => const HRDashboardPage(),
//           ),
//         );
//         return false;
//       } else {
//         Fluttertoast.showToast(
//           msg: 'Invalid role assigned to the user.',
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.SNACKBAR,
//           backgroundColor: Colors.black54,
//           textColor: Colors.white,
//           fontSize: 14.0,
//         );
//         return false;
//       }
//       return true;
//     } on FirebaseAuthException catch (e) {
//       String message = '';
//       if (e.code == 'invalid-email') {
//         message = 'No user found for that email.';
//       } else if (e.code == 'invalid-credential') {
//         message = 'Wrong password provided for that user.';
//       }
//       Fluttertoast.showToast(
//         msg: message,
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.SNACKBAR,
//         backgroundColor: Colors.black54,
//         textColor: Colors.white,
//         fontSize: 14.0,
//       );
//       return false;
//     }
//   }

//   Future<void> signout({
//     required BuildContext context,
//   }) async {
//     await FirebaseAuth.instance.signOut();
//     await Future.delayed(const Duration(seconds: 1));
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (BuildContext context) => LoginPage(),
//       ),
//     );
//   }

//   getUserSession() {}
// }

// Future<void> saveUserSession(String? uid) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('userUid', uid ?? '');
//   }

//   Future<String?> getUserSession() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('userUid');
//   }

//   Future<void> clearUserSession() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('userUid');
//   }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ooriba_s3/HR/hr_dashboard_page.dart';
import 'package:ooriba_s3/main.dart';
import 'package:ooriba_s3/post_login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Fetch the document from the Firestore collection "Regemp"
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('Regemp')
              .doc(email)
              .get();

      // Check if the document exists
      if (!documentSnapshot.exists) {
        Fluttertoast.showToast(
          msg: 'No user found for that email.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        return false;
      }

      // Retrieve the role from the document
      String role = documentSnapshot.data()?['role'] ?? '';

      // Sign in with Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await saveUserSession(email, role);

      // Navigate to the appropriate page based on the role
      await Future.delayed(const Duration(seconds: 1));
      if (role == "Standard") {
        String firstName = documentSnapshot.data()?['firstName'] ?? '';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>  PostLoginPage(email: email, userDetails: const {}),
          ),
        );
        return true;
      } else if (role == "HR") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HRDashboardPage(),
          ),
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: 'Invalid role assigned to the user.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        return false;
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return false;
    }
  }

  Future<void> signout({
    required BuildContext context,
  }) async {
    await FirebaseAuth.instance.signOut();
    await clearUserSession();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginPage(),
      ),
    );
  }

  Future<String?> getUserSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<String?> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  Future<void> saveUserSession(String email, String role) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('role', role);
  }

  Future<void> clearUserSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('role');
  }
}



