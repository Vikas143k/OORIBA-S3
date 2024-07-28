// import 'dart:io';
// import 'package:csv/csv.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MonthlyReportService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<Map<String, dynamic>>> fetchAllEmployeeData() async {
//     try {
//       // Fetch employee data from Regemp collection
//       QuerySnapshot regempSnapshot = await _firestore.collection('Regemp').get();
//       List<QueryDocumentSnapshot> regempDocs = regempSnapshot.docs;

//       // Fetch leave count data from LeaveCount collection
//       QuerySnapshot leaveCountSnapshot = await _firestore.collection('LeaveCount').get();
//       List<QueryDocumentSnapshot> leaveCountDocs = leaveCountSnapshot.docs;

//       // Create a map for leave counts
//       Map<String, int> leaveCounts = {
//         for (var doc in leaveCountDocs) doc.id: doc.get('count')
//       };

//       // Initialize employees map
//       Map<String, Map<String, dynamic>> employees = {
//         for (var doc in regempDocs)
//           doc.get('employeeId'): {
//             'employeeId': doc.get('employeeId') ?? 0,
//             'name': '${doc.get('firstName')} ${doc.get('lastName')}' ?? 0,
//             'location': doc.get('location') ?? 0,
//             'joiningDate': doc.get('joiningDate') ?? 'hgg', // Ensure joining date is fetched as string
//             'phoneNo': doc.get('phoneNo') ?? 0,
//             'workingDays': 0,
//             'leaveCount': leaveCounts[doc.get('employeeId')] ?? 0,
//           }
//       };

//       // Fetch attendance data from Dates collection
//       QuerySnapshot datesSnapshot = await _firestore.collection('Dates').get();
//       List<QueryDocumentSnapshot> datesDocs = datesSnapshot.docs;

//       // Calculate working days
//       for (var doc in datesDocs) {
//         Map<String, dynamic> attendance = doc.data() as Map<String, dynamic>;
//         for (String employeeId in attendance.keys) {
//           if (attendance[employeeId]['checkIn'] != null) {
//             employees[employeeId]?['workingDays'] += 1;
//           }
//         }
//       }

//       return employees.values.toList();
//     } catch (e) {
//       print('Error fetching employee data: $e');
//       return [];
//     }
//   }

//   Future<void> generateCsvReport(String path) async {
//     List<Map<String, dynamic>> data = await fetchAllEmployeeData();
//     List<List<dynamic>> csvData = [
//       ['Employee ID', 'Name', 'Location', 'Joining Date', 'Phone No', 'Working Days', 'Leave Count'],
//       ...data.map((employee) => [
//             employee['employeeId'],
//             employee['name'],
//             employee['location'],
//             '"${employee['joiningDate']}"', // Wrap joining date in quotes
//             employee['phoneNo'],
//             employee['workingDays'],
//             employee['leaveCount'],
//           ])
//     ];

//     String csv = const ListToCsvConverter().convert(csvData);
//     File file = File(path);
//     await file.writeAsString(csv);
//   }
// }
//import 'package:cloud_firestore/cloud_firestore.dart';
//
//class MonthlyReportService {
//  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//  Future<List<Map<String, dynamic>>> fetchAllEmployeeData() async {
//    print("******************************************************************************************");
//    try {
//      print('Fetching employee data from Regemp collection');
//      QuerySnapshot regempSnapshot = await _firestore.collection('Regemp').get();
//      List<QueryDocumentSnapshot> regempDocs = regempSnapshot.docs;
//      print('Fetched ${regempDocs.length} documents from Regemp collection');
//
//      print('Fetching leave count data from LeaveCount collection');
//      QuerySnapshot leaveCountSnapshot = await _firestore.collection('LeaveCount').get();
//      List<QueryDocumentSnapshot> leaveCountDocs = leaveCountSnapshot.docs;
//      print('Fetched ${leaveCountDocs.length} documents from LeaveCount collection');
//
//      // Create a map for leave counts
//      Map<String, int> leaveCounts = {
//        for (var doc in leaveCountDocs) doc.id: doc.get('count')
//      };
//      print('Created leaveCounts map: $leaveCounts');
//
//      // Initialize employees map
//      Map<String, Map<String, dynamic>> employees = {
//        for (var doc in regempDocs)
//          doc.get('employeeId'): {
//            'employeeId': doc.get('employeeId'),
//            'name': '${doc.get('firstName')} ${doc.get('lastName')}',
//            'location': doc.get('location'),
//            'joiningDate': doc.get('joiningDate'), // Use date string as is
//            'phoneNo': doc.get('phoneNo'),
//            'workingDays': 0,
//            'leaveCount': leaveCounts[doc.get('employeeId')] ?? 0,
//          }
//      };
//      print('Initialized employees map with ${employees.length} entries');
//
//      print('Fetching attendance data from Dates collection');
//      QuerySnapshot datesSnapshot = await _firestore.collection('Dates').get();
//      List<QueryDocumentSnapshot> datesDocs = datesSnapshot.docs;
//      print('Fetched ${datesDocs.length} documents from Dates collection');
//
//      // Calculate working days
//      for (var doc in datesDocs) {
//        Map<String, dynamic> attendance = doc.data() as Map<String, dynamic>;
//        for (String employeeId in attendance.keys) {
//          if (attendance[employeeId]['checkIn'] != null) {
//            employees[employeeId]?['workingDays'] += 1;
//          }
//        }
//      }
//      print('Calculated working days for employees');
//
//      return employees.values.toList();
//    } catch (e) {
//      print('Error fetching employee data in monthly report service: $e');
//      return [];
//    }
//  }
//}
//

import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchAllEmployeeData() async {
    print("******************************************************************************************");
    try {
      print('Fetching employee data from Regemp collection');
      QuerySnapshot regempSnapshot = await _firestore.collection('Regemp').get();
      List<QueryDocumentSnapshot> regempDocs = regempSnapshot.docs;
      print('Fetched ${regempDocs.length} documents from Regemp collection');

      print('Fetching leave count data from LeaveCount collection');
      QuerySnapshot leaveCountSnapshot = await _firestore.collection('LeaveCount').get();
      List<QueryDocumentSnapshot> leaveCountDocs = leaveCountSnapshot.docs;
      print('Fetched ${leaveCountDocs.length} documents from LeaveCount collection');

      print('Fetching location working days from Locations collection');
      QuerySnapshot locationsSnapshot = await _firestore.collection('Locations').get();
      List<QueryDocumentSnapshot> locationsDocs = locationsSnapshot.docs;
      print('Fetched ${locationsDocs.length} documents from Locations collection');

      // Create a map for leave counts
      Map<String, int> leaveCounts = {
        for (var doc in leaveCountDocs) doc.id: doc.get('count')
      };
      print('Created leaveCounts map: $leaveCounts');

      // Create a map for location working days
      Map<String, int> locationWorkingDays = {
        for (var doc in locationsDocs) doc.id: doc.get('working_days')
      };
      print('Created locationWorkingDays map: $locationWorkingDays');

      // Initialize employees map
      Map<String, Map<String, dynamic>> employees = {
        for (var doc in regempDocs)
          doc.get('employeeId'): {
            'employeeId': doc.get('employeeId'),
            'name': '${doc.get('firstName')} ${doc.get('lastName')}',
            'location': doc.get('location'),
            'joiningDate': doc.get('joiningDate'), // Use date string as is
            'phoneNo': doc.get('phoneNo'),
            'workingDays': 0,
            'leaveCount': leaveCounts[doc.get('employeeId')] ?? 0,
            'absent': 0,
            'totalWorkingDays': locationWorkingDays[doc.get('location')] ?? 0,
          }
      };
      print('Initialized employees map with ${employees.length} entries');

      print('Fetching attendance data from Dates collection');
      QuerySnapshot datesSnapshot = await _firestore.collection('Dates').get();
      List<QueryDocumentSnapshot> datesDocs = datesSnapshot.docs;
      print('Fetched ${datesDocs.length} documents from Dates collection');

      // Calculate working days
      for (var doc in datesDocs) {
        Map<String, dynamic> attendance = doc.data() as Map<String, dynamic>;
        for (String employeeId in attendance.keys) {
          if (attendance[employeeId]['checkIn'] != null) {
            employees[employeeId]?['workingDays'] += 1;
          }
        }
      }
      print('Calculated working days for employees');

      // Calculate absent days
      employees.forEach((employeeId, employee) {
        int totalWorkingDays = employee['totalWorkingDays'];
        int checkIns = employee['workingDays'];
        int leaveCount = employee['leaveCount'];
        employee['absent'] = totalWorkingDays - (checkIns + leaveCount);
      });
      print('Calculated absent days for employees');

      return employees.values.toList();
    } catch (e) {
      print('Error fetching employee data in monthly report service: $e');
      return [];
    }
  }
}
