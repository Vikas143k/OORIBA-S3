import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ooriba_s3/employee_signup_success.dart';
class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<void> addEmployee(
    String firstName,
    String middlenName,
    String lastName,
    String email,
    String password,
    String panNo,
    String residentialAddress,
    String permanentAddress,
    String phoneNo,
    String dob,
    File adhaarImage,
    File dpImage,
    File supportImage
    ,{required BuildContext context}
    ) async {
    try {
      // Add employee data to Firestore
      DocumentReference docRef = await _firestore.collection('Employee').add({
        'firstName': firstName,
        'middleName':middlenName,
        'lastName':lastName,
        'email':email,
        'password':password,
        'panNo':panNo,
        'residentialAddress':residentialAddress,
        'permanentAddress':permanentAddress,
        'phoneNo': phoneNo,
        'dob':dob,
        'timestamp': FieldValue.serverTimestamp(),
        
      });
        //uploading dp into storage
        String dpImageUrl = await _uploadFile(
        'employees/${docRef.id}/profile_picture.jpg',
        dpImage,
        );
        //uploading aadhaarCard into storage
        String adhaarUrl = await _uploadFile(
        'employees/${docRef.id}/adhaar_card.jpg',
        adhaarImage,
      );
        //uploading Supporting document into storage
        String supportUrl = await _uploadFile(
        'employees/${docRef.id}/support.jpg',
        supportImage,
      );



        await docRef.update({
        'dpImageUrl': dpImageUrl,
        'adhaarUrl':adhaarUrl,
        'supportUrl':supportUrl
        });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmationPage()),
      );
    } 
    catch (e) {
      print('Failed to add employee: $e');
    }
  }

    Future<String> _uploadFile(String path, File file) async {
    UploadTask uploadTask = _storage.ref().child(path).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
