import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveLastLoginTime(String email, DateTime lastLoginTime) async {
    await _db.collection('Users').doc(email).update({
      'lastLoginTime': lastLoginTime,
    });
  }

  Future<DocumentSnapshot> getLastLoginTime(String email) async {
    return await _db.collection('Users').doc(email).get();
  }

  Future<void> createLastLoginTime(String email, DateTime lastLoginTime) async {
    await _db.collection('Users').doc(email).set({
      'lastLoginTime': lastLoginTime,
    });
  }

  Future<DocumentSnapshot> getCheckInOutData(String emmployeeId, String date) async {
    return await _db.collection('Dates').doc(date).get();
  }

  Future<void> addCheckInOutData(String employeeId, DateTime checkInTime, DateTime? checkOutTime, DateTime timestamp) async {
    String date = DateFormat('yyyy-MM-dd').format(timestamp);
    DocumentReference docRef = _db.collection('Dates').doc(date);
    Map<String, dynamic> data = {
      'checkIn': checkInTime,
      'checkOut': checkOutTime,
    };
    await docRef.set({
      employeeId: data,
    }, SetOptions(merge: true));
  }
}
