import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ooriba_s3/employee_checkin_page.dart';
import 'package:ooriba_s3/HR/hr_dashboard_page.dart';
import 'package:ooriba_s3/services/retrieveDataByEmail.dart';
import 'package:ooriba_s3/employee_signup_success.dart';
import 'package:ooriba_s3/main.dart';
class AuthService {
  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    
    try {

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      await Future.delayed(const Duration(seconds: 1));
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => const SignUpPage()
      //   )
      // );
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmationPage()),
      );
      
    } on FirebaseAuthException catch(e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
       Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }

  }

  Future<void> signin({
    required String email,
    required String password,
    required String role,
    required BuildContext context
  }) async {
   final FirestoreService firestore_Service = FirestoreService();
   Map<String, dynamic>? employeeData = await firestore_Service.searchEmployee(email: email);

    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      await Future.delayed(const Duration(seconds: 1));
      if(role=="employee"){
          String firstName = employeeData != null ? employeeData['firstName'] ?? '' : '';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => EmployeeCheckInPage(empname:firstName,empemail:email)
        )
      );
      }
      else{
              Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>  const HRDashboardPage()
        )
      );
      }

      
    } on FirebaseAuthException catch(e) {
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
    }

  }

  Future<void> signout({
    required BuildContext context
  }) async {
    
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>LoginPage()
        )
      );
  }

  
}