import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<void> addEmployee(String name, String phoneNo, File image) async {
    try {
      // Add employee data to Firestore
      DocumentReference docRef = await _firestore.collection('Employee').add({
        'name': name,
        'phoneNo': phoneNo,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Upload image to Firebase Storage
      String fileName = docRef.id;
      await _storage.ref('images/$fileName').putFile(image);

      print('Employee added with ID: ${docRef.id}');
    } catch (e) {
      print('Failed to add employee: $e');
    }
  }

  Future<File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }
}
