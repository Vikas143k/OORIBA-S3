// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   Future<List<Map<String, dynamic>>> getData() async {
//     try {
//       QuerySnapshot snapshot = await _db.collection('Employee').get();
//       return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//     } catch (e) {
//       print(e);
//       return [];
//     }
//   }
// }