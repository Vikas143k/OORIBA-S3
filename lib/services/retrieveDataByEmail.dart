// // firestore_service.dart
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   Future<Map<String, dynamic>?> getEmployeeByEmail(String email, String database) async {
//     try {
//       QuerySnapshot snapshot = await _db
//           .collection(database)
//           .where('email', isEqualTo: email).where('role',isEqualTo: 'Standard')
//           .limit(1)
//           .get();

//       if (snapshot.docs.isNotEmpty) {
//         return snapshot.docs.first.data() as Map<String, dynamic>;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   Future<Map<String, dynamic>?> searchEmployee({required String email}) async {
//     if (email.isNotEmpty) {
//       final employeeData = await getEmployeeByEmail(email,"Regemp");
//       return employeeData;
//     }
//     return null;
//   }
//    Future<List<Map<String, dynamic>>> getAllEmployees() async {
//     try {
//       QuerySnapshot snapshot = await _db.collection('Regemp').get();
//       return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//     } catch (e) {
//       print(e);
//       return [];}
// }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getEmployeeByEmailOrPhoneNo(String emailOrPhoneNo, String database) async {
    try {
      // Query for email
      QuerySnapshot emailSnapshot = await _db
          .collection(database)
          .where('email', isEqualTo: emailOrPhoneNo)
          .where('role', isEqualTo: 'Standard')
          .limit(1)
          .get();

      // If no results found by email, query for phoneNo
      if (emailSnapshot.docs.isEmpty) {
        QuerySnapshot phoneNoSnapshot = await _db
            .collection(database)
            .where('phoneNo', isEqualTo: emailOrPhoneNo)
            .where('role', isEqualTo: 'Standard')
            .limit(1)
            .get();

        if (phoneNoSnapshot.docs.isNotEmpty) {
          return phoneNoSnapshot.docs.first.data() as Map<String, dynamic>;
        }
      } else {
        return emailSnapshot.docs.first.data() as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> searchEmployee({required String emailOrPhoneNo}) async {
    if (emailOrPhoneNo.isNotEmpty) {
      final employeeData = await getEmployeeByEmailOrPhoneNo(emailOrPhoneNo, "Regemp");
      return employeeData;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllEmployees() async {
    try {
      QuerySnapshot snapshot = await _db.collection('Regemp').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
