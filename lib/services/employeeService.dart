import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ooriba_s3/main.dart';
class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
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
    // ,File adhaarImage,
    File dpImage
    // File supportImage
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




        String dpImageUrl = await _uploadFile(
        'employees/${docRef.id}/profile_picture.jpg',
        dpImage,
        );
        await docRef.update({
        'dpImageUrl': dpImageUrl,
        });














      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );

      // Upload image to Firebase Storage
    //   String fileName = docRef.id;
    //   await _storage.ref('images/$fileName').putFile(image);

    //   print('Employee added with ID: ${docRef.id}');
    } 
    catch (e) {
      print('Failed to add employee: $e');
    }
  }

  // Future<File?> pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     return File(pickedFile.path);
  //   } else {
  //     print('No image selected.');
  //     return null;
  //   }
  // }
    Future<String> _uploadFile(String path, File file) async {
    UploadTask uploadTask = _storage.ref().child(path).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
