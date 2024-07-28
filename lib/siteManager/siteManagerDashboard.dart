// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:ooriba_s3/facial/DB/DatabaseHelper.dart';
// import 'package:ooriba_s3/facial/RecognitionScreenForSite.dart';
// import 'package:ooriba_s3/facial/RegistrationScreenForSite.dart';
// import 'package:ooriba_s3/services/admin/broadcast_service.dart';
// import 'package:ooriba_s3/services/auth_service.dart';
// import 'package:ooriba_s3/services/employee_location_service.dart';
// import 'package:ooriba_s3/services/geo_service.dart';
// import 'package:ooriba_s3/services/SiteManager/retrieveDataByEmail.dart'
//     as retrieveDataByEmail;
// import 'package:ooriba_s3/services/user.dart';
// import 'package:ooriba_s3/services/location_service.dart';

// class Sitemanagerdashboard extends StatefulWidget {
//   final String phoneNumber;
//   final Map<String, dynamic> userDetails;

//   const Sitemanagerdashboard(
//       {super.key, required this.phoneNumber, required this.userDetails});

//   @override
//   _SitemanagerdashboardState createState() => _SitemanagerdashboardState();
// }

// class _SitemanagerdashboardState extends State<Sitemanagerdashboard> {
//   String? employeeId;
//   String? employeeName;
//   String? employeePhoneNumber;
//   String? dpImageUrl;
//   String? employeeType;
//   DateTime? lastLoginTime;
//   String? siteLocation;
//   final UserFirestoreService firestoreService = UserFirestoreService();
//   late DatabaseHelper dbHelper;
//   bool isRegistered = false;
//   bool isLoading = true;
//   final GeoService geoService = GeoService();
//   bool isWithinRange = false;
//   bool isLoadingForLocation = false;
//   List<Map<String, dynamic>> employeeDetails = [];
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//   final EmployeeLocationService employeeLocationService =
//       EmployeeLocationService();
//   final BroadcastService _broadcastService = BroadcastService();
//   String? broadcastMessage;
//   final LocationService locationService = LocationService();

//   @override
//   void initState() {
//     super.initState();
//     dbHelper = DatabaseHelper();
//     fetchEmployeeData();
//     _checkIfFaceIsRegistered();
//     _checkLocation();
//     _fetchAllEmployees();
//     _fetchMessage();
//   }

//   Future<void> _fetchMessage() async {
//     String? message = await _broadcastService.getCurrentBroadcastMessage();
//     setState(() {
//       message != null
//           ? broadcastMessage = message
//           : broadcastMessage = "No Message";
//       isLoading = false;
//     });
//   }

//   Future<void> fetchEmployeeData() async {
//     await _fetchEmployeeDetails(widget.phoneNumber);
//     await _fetchLastLoginTime(widget.phoneNumber);
//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> _checkIfFaceIsRegistered() async {
//     await dbHelper.init();
//     final allRows = await dbHelper.queryAllRows();
//     setState(() {
//       isRegistered = allRows.isNotEmpty;
//     });
//   }

//   void _checkLocation() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       Position position = await locationService.determinePosition();
//       String Prefix = employeeId!.substring(0, 3);

//       if (Prefix.isEmpty) {
//         setState(() {
//           isLoading = false;
//         });
//         Fluttertoast.showToast(msg: 'Invalid employee ID');
//         return;
//       }

//       Map<String, dynamic> locationDetails =
//           await locationService.getLocationByPrefix(Prefix);

//       if (locationDetails.isNotEmpty) {
//         GeoPoint coordinates = locationDetails['coordinates'];
//         double restrictedRadius =
//             (locationDetails['restricted_radius'] as num).toDouble();

//         print('Location Details: $locationDetails');
//         print('Coordinates: ${coordinates.latitude}, ${coordinates.longitude}');
//         print('Restricted Radius: $restrictedRadius');

//         bool withinRange = await locationService.isWithinRadius(
//             position, restrictedRadius, coordinates);

//         setState(() {
//           isWithinRange = withinRange;
//           isLoading = false;
//         });

//         Fluttertoast.showToast(
//           msg: employeeType != "Off-site"
//               ? (isWithinRange
//                   ? "You are within the location"
//                   : "You are away from the location")
//               : "",
//         );
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         Fluttertoast.showToast(msg: 'Location details not found');
//       }
//     } catch (e) {
//       print(e);
//       Fluttertoast.showToast(msg: 'Error determining location');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   String formatTime(DateTime? time) {
//     if (time == null) return " ";
//     return DateFormat.jm().format(time);
//   }

//   Future<void> _fetchEmployeeDetails(String phoneNumber) async {
//     retrieveDataByEmail.FirestoreService firestoreService =
//         retrieveDataByEmail.FirestoreService();
//     Map<String, dynamic>? employeeData = await firestoreService
//         .getEmployeeByEmailOrPhoneNo(phoneNumber, "Regemp");

//     if (employeeData != null) {
//       setState(() {
//         employeeId = employeeData['employeeId'];
//         employeeName = employeeData['firstName'];
//         employeePhoneNumber = employeeData['phoneNo'];
//         dpImageUrl = employeeData['dpImageUrl'];
//         siteLocation = employeeData['location'];
//       });
//     } else {
//       print(
//           'Employee details not found for email or Phone Number (retrieving): $phoneNumber');
//     }
//   }

//   Future<void> _fetchLastLoginTime(String phoneNumber) async {
//     try {
//       DocumentSnapshot docSnapshot =
//           await firestoreService.getLastLoginTime(phoneNumber);

//       if (docSnapshot.exists) {
//         Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
//         var lastLoginTimestamp = data['lastLoginTime'];

//         if (lastLoginTimestamp != null) {
//           setState(() {
//             lastLoginTime = (lastLoginTimestamp as Timestamp).toDate();
//           });
//         } else {
//           print('Last login time is null for email: $phoneNumber');
//           await _updateLastLoginTime(phoneNumber);
//         }
//       } else {
//         print('Document not found for email: $phoneNumber');
//         await _createAndSaveLastLoginTime(phoneNumber);
//       }
//     } catch (e) {
//       print('Error fetching last login time: $e');
//       if (e is FirebaseException && e.code == 'not-found') {
//         await _createAndSaveLastLoginTime(phoneNumber);
//       }
//     }
//   }

//   Future<void> _createAndSaveLastLoginTime(String phoneNumber) async {
//     DateTime now = DateTime.now();
//     await firestoreService.createLastLoginTime(phoneNumber, now);
//     setState(() {
//       lastLoginTime = now;
//     });
//   }

//   Future<void> _updateLastLoginTime(String phoneNumber) async {
//     DateTime now = DateTime.now();
//     await firestoreService.saveLastLoginTime(phoneNumber, now);
//     setState(() {
//       lastLoginTime = now;
//     });
//   }

//   Future<void> _saveLastLoginTime() async {
//     DateTime now = DateTime.now();
//     await firestoreService.saveLastLoginTime(widget.phoneNumber, now);
//   }

//   Future<String> getImageUrl(String employeeId) async {
//     String imagePath = 'authImage/$employeeId.jpg';
//     try {
//       final ref = FirebaseStorage.instance.ref().child(imagePath);
//       final url = await ref.getDownloadURL();
//       return url;
//     } catch (e) {
//       print('Error fetching image for $employeeId: $e');
//       return '';
//     }
//   }

//   String formatTimeWithoutSeconds(DateTime? dateTime) {
//     if (dateTime == null) {
//       return 'N/a';
//     }
//     return DateFormat.yMMMMd('en_US').add_Hm().format(dateTime);
//   }

//   void navigateToFaceRecognitionScreen() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => RecognitionScreen(
//                 phoneNumber: widget.phoneNumber,
//                 userDetails: {},
//               )),
//     );
//   }

//   Future<void> _fetchAllEmployees() async {
//     try {
//       List<Map<String, dynamic>> employees =
//           await retrieveDataByEmail.FirestoreService().getAllEmployees();
//       setState(() {
//         employeeDetails = employees
//             .where((employee) => employee['employeeId'] != null)
//             .toList();
//       });
//     } catch (e) {
//       print('Error fetching employee details: $e');
//     }
//   }

//   Future<Map<String, dynamic>> _getCheckInOutData(
//       String employeeId, DateTime date) async {
//     try {
//       return await firestoreService.getCheckInOutDataByEmployeeId(
//           employeeId, date);
//     } catch (e) {
//       print('Error fetching check-in/out data: $e');
//       return {};
//     }
//   }

//   Widget buildEmployeeCard(Map<String, dynamic> employee) {
//     return FutureBuilder<Map<String, dynamic>>(
//       future: _getCheckInOutData(employee['employeeId'], DateTime.now()),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           Map<String, dynamic> checkInOutData = snapshot.data ?? {};
//           DateTime? checkIn = checkInOutData['checkIn'];
//           DateTime? checkOut = checkInOutData['checkOut'];

//           if (checkIn == null) {
//             return SizedBox.shrink(); // Don't show the card if checkIn is null
//           }

//           return Card(
//             child: ListTile(
//               title: Text(
//                   '${employee['firstName'][0].toUpperCase()}${employee['firstName'].substring(1).toLowerCase()} ${employee['lastName'][0].toUpperCase()}${employee['lastName'].substring(1).toLowerCase()} : ${employee['employeeId'] ?? "No ID"}'),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                       'Check-In: ${checkIn != null ? formatTime(checkIn) : 'N/A'}'),
//                   Text(
//                       'Check-Out: ${checkOut != null ? formatTime(checkOut) : 'N/A'}'),
//                 ],
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           titleSpacing: 0,
//           leading: Builder(
//             builder: (BuildContext context) {
//               return IconButton(
//                 icon: Icon(Icons.menu),
//                 onPressed: () {
//                   Scaffold.of(context).openDrawer();
//                 },
//               );
//             },
//           ),
//           title: Row(
//             children: [
//               SizedBox(width: 0),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       employeeName != null && siteLocation != null
//                           ? 'Site Manager - $siteLocation'
//                           : "Loading Site Manager",
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                       softWrap: false,
//                     ),
//                     if (lastLoginTime != null)
//                       Text(
//                         'Last login: ${formatTimeWithoutSeconds(lastLoginTime)}',
//                         style: TextStyle(fontSize: 14),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                         softWrap: false,
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             // IconButton(
//             //   icon: const Icon(Icons.refresh_outlined),
//             //   onPressed: () async {
//             //      if (navigatorKey.currentState != null) {
//             //         navigatorKey.currentState!.pushReplacement(
//             //           MaterialPageRoute(builder: (context) => Sitemanagerdashboard(phoneNumber:widget.phoneNumber, userDetails: {})),
//             //         );
//             //       } else {
//             //         print('Navigator state is null.');
//             //       }
//             //   },
//             // ),
//             IconButton(
//               icon: const Icon(Icons.logout),
//               onPressed: () async {
//                 await _saveLastLoginTime();
//                 await AuthService().signout(context: context);
//               },
//             ),
//           ],
//         ),
//         drawer: Drawer(
//           child: ListView(
//             children: [
//               UserAccountsDrawerHeader(
//                 accountName: Text(employeeName ?? 'Loading...'),
//                 accountEmail: Text(employeePhoneNumber ?? 'Loading...'),
//                 currentAccountPicture: CircleAvatar(
//                   backgroundImage:
//                       dpImageUrl != null ? NetworkImage(dpImageUrl!) : null,
//                   child: dpImageUrl == null ? Icon(Icons.person) : null,
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.emoji_emotions_outlined),
//                 title: Text('Profile'),
//                 onTap: () {
//                   // Handle Profile tap
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.app_registration_outlined),
//                 title: Text('Register'),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           RegistrationScreen(siteManagerId: employeeId!),
//                     ),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.event_available),
//                 title: Text('Attendance'),
//                 onTap: () {
//                   // Handle Attendance tap
//                 },
//                 //),
//                 //ListTile(
//                 //  leading: Icon(Icons.settings),
//                 //  title: Text('Settings'),
//                 //  onTap: () {
//                 //    // Handle Settings tap
//                 //  },
//               ),
//               ListTile(
//                 leading: Icon(Icons.logout),
//                 title: Text('Logout'),
//                 onTap: () async {
//                   await _saveLastLoginTime();
//                   await AuthService().signout(context: context);
//                 },
//               ),
//             ],
//           ),
//         ),
//         body: isLoading
//             ? Center(child: CircularProgressIndicator())
//             : Column(
//                 children: [
//                   // if (!isRegistered)
//                   //   Padding(
//                   //     padding: const EdgeInsets.all(16.0),
//                   //     child: ElevatedButton(
//                   //       onPressed: () {
//                   //         Navigator.push(
//                   //           context,
//                   //           MaterialPageRoute(
//                   //               builder: (context) =>
//                   //                   RegistrationScreen(siteManagerId: employeeId!)),
//                   //         );
//                   //       },
//                   //       child: Text('Register Face'),
//                   //     )
//                   //   ),
//                   if (isWithinRange)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 20.0),
//                       child: Center(
//                         child: ElevatedButton(
//                           onPressed: isWithinRange
//                               ? () {
//                                   navigateToFaceRecognitionScreen();
//                                 }
//                               : null,
//                           child: const Text('Attendance'),
//                         ),
//                       ),
//                     ),
//                   Expanded(
//                     child: ListView(
//                       children: [
//                         const Divider(
//                           color: Colors.blue,
//                           thickness: 2.0,
//                         ),
//                         const Card(
//                           elevation: 5,
//                           color: Color.fromARGB(255, 222, 200, 174),
//                           child: ListTile(
//                             leading: Icon(Icons.calendar_today),
//                             title: Text(
//                               'Upcoming Events',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 20),
//                             ),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Weekly Meeting at: 3 PM'),
//                                 Text('Holiday: 20th July 2024'),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Card(
//                           elevation: 5,
//                           color: Color.fromARGB(255, 222, 200, 174),
//                           child: ListTile(
//                             leading: Icon(Icons.message),
//                             title: const Text(
//                               'Global Communication',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 25),
//                             ),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(broadcastMessage!),
//                               ],
//                             ),
//                           ),
//                         ),

//                         // const Padding(
//                         //   padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
//                         //   child: Text(
//                         //     'History',
//                         //     style: TextStyle(
//                         //       fontSize: 20,
//                         //       fontWeight: FontWeight.bold,
//                         //     ),
//                         //   ),
//                         // ),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(
//                               vertical: 20.0, horizontal: 16.0),
//                           child: Center(
//                             child: Text(
//                               'Attendance for the Day',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemCount: employeeDetails.length,
//                           itemBuilder: (context, index) {
//                             return buildEmployeeCard(employeeDetails[index]);
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ));
//   }
// }


















// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:ooriba_s3/facial/DB/DatabaseHelper.dart';
// import 'package:ooriba_s3/facial/RecognitionScreenForSite.dart';
// import 'package:ooriba_s3/facial/RegistrationScreenForSite.dart';
// import 'package:ooriba_s3/services/auth_service.dart';
// import 'package:ooriba_s3/services/geo_service.dart';
// import 'package:ooriba_s3/services/SiteManager/retrieveDataByEmail.dart'
//     as retrieveDataByEmail;
// import 'package:ooriba_s3/services/user.dart';

// class Sitemanagerdashboard extends StatefulWidget {
//   final String phoneNumber;
//   final Map<String, dynamic> userDetails;

//   const Sitemanagerdashboard(
//       {super.key, required this.phoneNumber, required this.userDetails});

//   @override
//   _SitemanagerdashboardState createState() => _SitemanagerdashboardState();
// }

// class _SitemanagerdashboardState extends State<Sitemanagerdashboard> {
//   String? employeeId;
//   String? employeeName;
//   String? employeePhoneNumber;
//   String? dpImageUrl;
//   DateTime? lastLoginTime;
//   String? siteLocation;
//   final UserFirestoreService firestoreService = UserFirestoreService();
//   late DatabaseHelper dbHelper;
//   bool isRegistered = false;
//   bool isLoading = true;
//   final GeoService geoService = GeoService();
//   bool isWithinRange = false;
//   bool isLoadingForLocation = false;
//   List<Map<String, dynamic>> employeeDetails = [];

//   @override
//   void initState() {
//     super.initState();
//     dbHelper = DatabaseHelper();
//     fetchEmployeeData();
//     _checkIfFaceIsRegistered();
//     _checkLocation();
//     _fetchAllEmployees();
//   }

//   Future<void> fetchEmployeeData() async {
//     await _fetchEmployeeDetails(widget.phoneNumber);
//     await _fetchLastLoginTime(widget.phoneNumber);
//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> _checkIfFaceIsRegistered() async {
//     await dbHelper.init();
//     final allRows = await dbHelper.queryAllRows();
//     setState(() {
//       isRegistered = allRows.isNotEmpty;
//     });
//   }

//   void _checkLocation() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       Position position = await geoService.determinePosition();
//       bool withinRange = await geoService.isWithin50m(position);

//       setState(() {
//         isWithinRange = withinRange;
//         isLoading = false;
//       });

//       Fluttertoast.showToast(
//           msg: withinRange
//               ? "You are at the location"
//               : "You are not at the location");
//     } catch (e) {
//       print(e);
//       Fluttertoast.showToast(msg: 'Error: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   String formatTime(DateTime? time) {
//     if (time == null) return " ";
//     return DateFormat.jm().format(time);
//   }

//   Future<void> _fetchEmployeeDetails(String phoneNumber) async {
//     retrieveDataByEmail.FirestoreService firestoreService =
//         retrieveDataByEmail.FirestoreService();
//     Map<String, dynamic>? employeeData = await firestoreService
//         .getEmployeeByEmailOrPhoneNo(phoneNumber, "Regemp");

//     if (employeeData != null) {
//       setState(() {
//         employeeId = employeeData['employeeId'];
//         employeeName = employeeData['firstName'];
//         employeePhoneNumber = employeeData['phoneNo'];
//         dpImageUrl = employeeData['dpImageUrl'];
//          siteLocation=employeeData['location'];
//       });
//     } else {
//       print(
//           'Employee details not found for email or Phone Number (retriving): $phoneNumber');
//     }
//   }

//   Future<void> _fetchLastLoginTime(String phoneNumber) async {
//     try {
//       DocumentSnapshot docSnapshot =
//           await firestoreService.getLastLoginTime(phoneNumber);

//       if (docSnapshot.exists) {
//         Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
//         var lastLoginTimestamp = data['lastLoginTime'];

//         if (lastLoginTimestamp != null) {
//           setState(() {
//             lastLoginTime = (lastLoginTimestamp as Timestamp).toDate();
//           });
//         } else {
//           print('Last login time is null for email: $phoneNumber');
//           await _updateLastLoginTime(phoneNumber);
//         }
//       } else {
//         print('Document not found for email: $phoneNumber');
//         await _createAndSaveLastLoginTime(phoneNumber);
//       }
//     } catch (e) {
//       print('Error fetching last login time: $e');
//       if (e is FirebaseException && e.code == 'not-found') {
//         await _createAndSaveLastLoginTime(phoneNumber);
//       }
//     }
//   }

//   Future<void> _createAndSaveLastLoginTime(String phoneNumber) async {
//     DateTime now = DateTime.now();
//     await firestoreService.createLastLoginTime(phoneNumber, now);
//     setState(() {
//       lastLoginTime = now;
//     });
//   }

//   Future<void> _updateLastLoginTime(String phoneNumber) async {
//     DateTime now = DateTime.now();
//     await firestoreService.saveLastLoginTime(phoneNumber, now);
//     setState(() {
//       lastLoginTime = now;
//     });
//   }

//   Future<void> _saveLastLoginTime() async {
//     DateTime now = DateTime.now();
//     await firestoreService.saveLastLoginTime(widget.phoneNumber, now);
//   }

//   Future<String> getImageUrl(String employeeId) async {
//     String imagePath = 'authImage/$employeeId.jpg';
//     try {
//       final ref = FirebaseStorage.instance.ref().child(imagePath);
//       final url = await ref.getDownloadURL();
//       return url;
//     } catch (e) {
//       print('Error fetching image for $employeeId: $e');
//       return '';
//     }
//   }

//   String formatTimeWithoutSeconds(DateTime? dateTime) {
//     if (dateTime == null) {
//       return 'N/a';
//     }
//     return DateFormat.yMMMMd('en_US').add_Hm().format(dateTime);
//   }

//   void navigateToFaceRecognitionScreen() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => RecognitionScreen(phoneNumber:widget.phoneNumber , userDetails: {})),
//     );
//   }

//   Future<void> _fetchAllEmployees() async {
//     try {
//       List<Map<String, dynamic>> employees =
//           await retrieveDataByEmail.FirestoreService().getAllEmployees();
//       setState(() {
//         employeeDetails = employees;
//       });
//     } catch (e) {
//       print('Error fetching employee details: $e');
//     }
//   }

//   Future<Map<String, dynamic>> _getCheckInOutData(
//       String employeeId, DateTime date) async {
//     try {
//       return await firestoreService.getCheckInOutDataByEmployeeId(
//           employeeId, date);
//     } catch (e) {
//       print('Error fetching check-in/out data: $e');
//       return {};
//     }
//   }

//   Widget buildEmployeeCard(Map<String, dynamic> employee) {
//     return Card(
//       child: ListTile(
//         title: Text(employee['firstName']+" "+employee['lastName']+"--"+ (employee['employeeId'] ?? "No ID")),
//         subtitle: FutureBuilder<Map<String, dynamic>>(
//           future: employee['employeeId'] != null
//               ? _getCheckInOutData(employee['employeeId'], DateTime.now())
//               : Future.value({}), // Return empty map if employeeId is null
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else {
//               Map<String, dynamic> checkInOutData = snapshot.data ?? {};
//               DateTime? checkIn = checkInOutData['checkIn'];
//               DateTime? checkOut = checkInOutData['checkOut'];
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                       'Check-In: ${checkIn != null ? formatTime(checkIn) : 'N/A'}'),
//                   Text(
//                       'Check-Out: ${checkOut != null ? formatTime(checkOut) : 'N/A'}'),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 0,
//         leading: Builder(
//           builder: (BuildContext context) {
//             return IconButton(
//               icon: Icon(Icons.menu),
//               onPressed: () {
//                 Scaffold.of(context).openDrawer();
//               },
//             );
//           },
//         ),
//         title: Row(
//           children: [

//             SizedBox(width: 8),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     employeeName != null && siteLocation!=null
//                         ? 'Site Manager-${siteLocation}'
//                         : "Loading in Site",
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                     softWrap: false,
//                   ),
//                   if (lastLoginTime != null)
//                     Text(
//                       'Last login: ${formatTimeWithoutSeconds(lastLoginTime)}',
//                       style: TextStyle(fontSize: 14),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                       softWrap: false,
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await _saveLastLoginTime();
//               await AuthService().signout(context: context);
//             },
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             UserAccountsDrawerHeader(
//               accountName: Text(employeeName ?? 'Loading...'),
//               accountEmail: Text(employeePhoneNumber ?? 'Loading...'),
//               currentAccountPicture: CircleAvatar(
//                 backgroundImage:
//                     dpImageUrl != null ? NetworkImage(dpImageUrl!) : null,
//                 child: dpImageUrl == null ? Icon(Icons.person) : null,
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.emoji_emotions_outlined),
//               title: Text('Profile'),
//               onTap: () {
//                 // Handle Dashboard tap
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.app_registration_outlined),
//               title: Text('Register'),
//               onTap: () async {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const RegistrationScreen(
//                       siteManagerId: '',
//                     ),
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.event_available),
//               title: Text('Attendance'),
//               onTap: () {
//                 // Handle Attendance tap
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text('Settings'),
//               onTap: () {
//                 // Handle Settings tap
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Logout'),
//               onTap: () async {
//                 await _saveLastLoginTime();
//                 await AuthService().signout(context: context);
//               },
//             ),
//           ],
//         ),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 // ListTile(
//                 //   title: Text(employeeName ?? 'Loading...'),
//                 //   subtitle: Text(employeePhoneNumber ?? 'Loading...'),
//                 //   leading: dpImageUrl != null
//                 //       ? CircleAvatar(
//                 //           backgroundImage: NetworkImage(dpImageUrl!),
//                 //         )
//                 //       : CircleAvatar(
//                 //           child: Icon(Icons.person),
//                 //         ),
//                 // ),
//                 if (!isRegistered)
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 RegistrationScreen(siteManagerId: employeeId!)),
//                       );
//                     },
//                     child: Text('Register Face'),
//                   ),
//                 if (isRegistered && isWithinRange)
//                   Padding(
//       padding: const EdgeInsets.only(top: 40.0,bottom: 40), // Add top padding as needed
//       child: Center(
//         child: ElevatedButton(
//           onPressed: isWithinRange ? () {
//             navigateToFaceRecognitionScreen();
//           } : null,
//           child: const Text('Recognize'),
//         ),
//       ),
//     ),
//                 Divider(), // Add a divider line
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     'History',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: employeeDetails.length,
//                     itemBuilder: (context, index) {
//                       return buildEmployeeCard(employeeDetails[index]);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ooriba_s3/facial/DB/DatabaseHelper.dart';
import 'package:ooriba_s3/facial/RecognitionScreenForSite.dart';
import 'package:ooriba_s3/facial/RegistrationScreenForSite.dart';
import 'package:ooriba_s3/services/admin/broadcast_service.dart';
import 'package:ooriba_s3/services/auth_service.dart';
import 'package:ooriba_s3/services/employee_location_service.dart';
import 'package:ooriba_s3/services/geo_service.dart';
import 'package:ooriba_s3/services/SiteManager/retrieveDataByEmail.dart'
    as retrieveDataByEmail;
import 'package:ooriba_s3/services/location_service.dart';
import 'package:ooriba_s3/services/user.dart';

class Sitemanagerdashboard extends StatefulWidget {
  final String phoneNumber;
  final Map<String, dynamic> userDetails;

  const Sitemanagerdashboard(
      {super.key, required this.phoneNumber, required this.userDetails});

  @override
  _SitemanagerdashboardState createState() => _SitemanagerdashboardState();
}

class _SitemanagerdashboardState extends State<Sitemanagerdashboard> {
  String? employeeId;
  String? employeeName;
  String? employeePhoneNumber;
    String? employeeType;
  String? dpImageUrl;
  DateTime? lastLoginTime;
  String? siteLocation;
  final UserFirestoreService firestoreService = UserFirestoreService();
  late DatabaseHelper dbHelper;
  bool isRegistered = false;
  bool isLoading = true;
  final GeoService geoService = GeoService();
  bool isWithinRange = false;
  bool isLoadingForLocation = false;
  List<Map<String, dynamic>> employeeDetails = [];
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final EmployeeLocationService employeeLocationService =
      EmployeeLocationService();
  final BroadcastService _broadcastService = BroadcastService();
  String? broadcastMessage;
  final LocationService locationService = LocationService();

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
     _fetchMessage();
    fetchEmployeeData();
    _checkIfFaceIsRegistered();
    _checkLocation();
    _fetchAllEmployees();
   
  }

  Future<void> _fetchMessage() async {
    String? message = await _broadcastService.getCurrentBroadcastMessage();
    setState(() {
      message != null
          ? broadcastMessage = message
          : broadcastMessage = null;
      isLoading = false;
    });
  }

  Future<void> fetchEmployeeData() async {
    await _fetchEmployeeDetails(widget.phoneNumber);
    await _fetchLastLoginTime(widget.phoneNumber);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _checkIfFaceIsRegistered() async {
    await dbHelper.init();
    final allRows = await dbHelper.queryAllRows();
    setState(() {
      isRegistered = allRows.isNotEmpty;
    });
  }

  // void _checkLocation() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     Position position = await geoService.determinePosition();
  //     bool withinRange = await geoService.isWithin50m(position);

  //     setState(() {
  //       isWithinRange = withinRange;
  //       isLoading = false;
  //     });

  //     Fluttertoast.showToast(
  //         msg: withinRange
  //             ? "You are at the location"
  //             : "You are not at the location");
  //   } catch (e) {
  //     print(e);
  //     Fluttertoast.showToast(msg: 'Error: $e');
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }


  void _checkLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      Position position = await locationService.determinePosition();
      String Prefix = employeeId!.substring(0, 3);

      if (Prefix.isEmpty) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'Invalid employee ID');
        return;
      }

      Map<String, dynamic> locationDetails =
          await locationService.getLocationByPrefix(Prefix);

      if (locationDetails.isNotEmpty) {
        GeoPoint coordinates = locationDetails['coordinates'];
        double restrictedRadius =
            (locationDetails['restricted_radius'] as num).toDouble();

        print('Location Details: $locationDetails');
        print('Coordinates: ${coordinates.latitude}, ${coordinates.longitude}');
        print('Restricted Radius: $restrictedRadius');

        bool withinRange = await locationService.isWithinRadius(
            position, restrictedRadius, coordinates);

        setState(() {
          isWithinRange = withinRange;
          isLoading = false;
        });

        Fluttertoast.showToast(
          msg: employeeType != "Off-site"
              ? (isWithinRange
                  ? "You are within the location"
                  : "You are away from the location")
              : "",
        );
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'Location details not found');
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Error determining location');
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatTime(DateTime? time) {
    if (time == null) return " ";
    return DateFormat.jm().format(time);
  }

  Future<void> _fetchEmployeeDetails(String phoneNumber) async {
    retrieveDataByEmail.FirestoreService firestoreService =
        retrieveDataByEmail.FirestoreService();
    Map<String, dynamic>? employeeData = await firestoreService
        .getEmployeeByEmailOrPhoneNo(phoneNumber, "Regemp");

    if (employeeData != null) {
      setState(() {
        employeeId = employeeData['employeeId'];
        employeeName = employeeData['firstName'];
        employeePhoneNumber = employeeData['phoneNo'];
        dpImageUrl = employeeData['dpImageUrl'];
        siteLocation = employeeData['location'];
      });
    } else {
      print(
          'Employee details not found for email or Phone Number (retrieving): $phoneNumber');
    }
  }

  Future<void> _fetchLastLoginTime(String phoneNumber) async {
    try {
      DocumentSnapshot docSnapshot =
          await firestoreService.getLastLoginTime(phoneNumber);

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        var lastLoginTimestamp = data['lastLoginTime'];

        if (lastLoginTimestamp != null) {
          setState(() {
            lastLoginTime = (lastLoginTimestamp as Timestamp).toDate();
          });
        } else {
          print('Last login time is null for email: $phoneNumber');
          await _updateLastLoginTime(phoneNumber);
        }
      } else {
        print('Document not found for email: $phoneNumber');
        await _createAndSaveLastLoginTime(phoneNumber);
      }
    } catch (e) {
      print('Error fetching last login time: $e');
      if (e is FirebaseException && e.code == 'not-found') {
        await _createAndSaveLastLoginTime(phoneNumber);
      }
    }
  }

  Future<void> _createAndSaveLastLoginTime(String phoneNumber) async {
    DateTime now = DateTime.now();
    await firestoreService.createLastLoginTime(phoneNumber, now);
    setState(() {
      lastLoginTime = now;
    });
  }

  Future<void> _updateLastLoginTime(String phoneNumber) async {
    DateTime now = DateTime.now();
    await firestoreService.saveLastLoginTime(phoneNumber, now);
    setState(() {
      lastLoginTime = now;
    });
  }

  Future<void> _saveLastLoginTime() async {
    DateTime now = DateTime.now();
    await firestoreService.saveLastLoginTime(widget.phoneNumber, now);
  }

  Future<String> getImageUrl(String employeeId) async {
    String imagePath = 'authImage/$employeeId.jpg';
    try {
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error fetching image for $employeeId: $e');
      return '';
    }
  }

  String formatTimeWithoutSeconds(DateTime? dateTime) {
    if (dateTime == null) {
      return 'N/a';
    }
    return DateFormat.yMMMMd('en_US').add_Hm().format(dateTime);
  }

  void navigateToFaceRecognitionScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RecognitionScreen(
                phoneNumber: widget.phoneNumber,
                userDetails: {},
              )),
    );
  }

  Future<void> _fetchAllEmployees() async {
    try {
      List<Map<String, dynamic>> employees =
          await retrieveDataByEmail.FirestoreService().getAllEmployees();
      setState(() {
        employeeDetails = employees
            .where((employee) => employee['employeeId'] != null)
            .toList();
      });
    } catch (e) {
      print('Error fetching employee details: $e');
    }
  }

  Future<Map<String, dynamic>> _getCheckInOutData(
      String employeeId, DateTime date) async {
    try {
      return await firestoreService.getCheckInOutDataByEmployeeId(
          employeeId, date);
    } catch (e) {
      print('Error fetching check-in/out data: $e');
      return {};
    }
  }

  Widget buildEmployeeCard(Map<String, dynamic> employee) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getCheckInOutData(employee['employeeId'], DateTime.now()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, dynamic> checkInOutData = snapshot.data ?? {};
          DateTime? checkIn = checkInOutData['checkIn'];
          DateTime? checkOut = checkInOutData['checkOut'];

          if (checkIn == null) {
            return SizedBox.shrink(); // Don't show the card if checkIn is null
          }

          return Card(
            child: ListTile(
              title: Text(
                  '${employee['firstName'][0].toUpperCase()}${employee['firstName'].substring(1).toLowerCase()} ${employee['lastName'][0].toUpperCase()}${employee['lastName'].substring(1).toLowerCase()} : ${employee['employeeId'] ?? "No ID"}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Check-In: ${checkIn != null ? formatTime(checkIn) : 'N/A'}'),
                  Text(
                      'Check-Out: ${checkOut != null ? formatTime(checkOut) : 'N/A'}'),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: Row(
            children: [
              SizedBox(width: 0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employeeName != null && siteLocation != null
                          ? 'Site Manager - $siteLocation'
                          : "Loading Site Manager",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    if (lastLoginTime != null)
                      Text(
                        'Last login: ${formatTimeWithoutSeconds(lastLoginTime)}',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.refresh_outlined),
            //   onPressed: () async {
            //      if (navigatorKey.currentState != null) {
            //         navigatorKey.currentState!.pushReplacement(
            //           MaterialPageRoute(builder: (context) => Sitemanagerdashboard(phoneNumber:widget.phoneNumber, userDetails: {})),
            //         );
            //       } else {
            //         print('Navigator state is null.');
            //       }
            //   },
            // ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _saveLastLoginTime();
                await AuthService().signout(context: context);
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(employeeName ?? 'Loading...'),
                accountEmail: Text(employeePhoneNumber ?? 'Loading...'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      dpImageUrl != null ? NetworkImage(dpImageUrl!) : null,
                  child: dpImageUrl == null ? Icon(Icons.person) : null,
                ),
              ),
              ListTile(
                leading: Icon(Icons.emoji_emotions_outlined),
                title: Text('Profile'),
                onTap: () {
                  // Handle Profile tap
                },
              ),
              ListTile(
                leading: Icon(Icons.app_registration_outlined),
                title: Text('Register'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RegistrationScreen(siteManagerId: employeeId!, location: siteLocation!,),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.event_available),
                title: Text('Attendance'),
                onTap: () {
                  // Handle Attendance tap
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Handle Settings tap
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () async {
                  await _saveLastLoginTime();
                  await AuthService().signout(context: context);
                },
              ),
            ],
          ),
        ),
        // body: isLoading
        //     ? Center(child: CircularProgressIndicator())
        //     : Column(
        //         children: [
        //           if (!isRegistered)
        //             ElevatedButton(
        //               onPressed: () {
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                       builder: (context) =>
        //                           RegistrationScreen(siteManagerId: employeeId!)),
        //                 );
        //               },
        //               child: Text('Register Face'),
        //             ),
        //           if (isRegistered && isWithinRange)
        //             Padding(
        //               padding: const EdgeInsets.only(top: 40.0, bottom: 40), // Add top padding as needed
        //               child: Center(
        //                 child: ElevatedButton(
        //                   onPressed: isWithinRange
        //                       ? () {
        //                           navigateToFaceRecognitionScreen();
        //                         }
        //                       : null,
        //                   child: const Text('Recognize'),
        //                 ),
        //               ),
        //             ),
        //              Expanded(
        //               child: ListView(
        //                 children: const [
        //                   Divider(
        //                     color: Colors.blue,
        //                     thickness: 2.0,
        //                   ),
        //                   Card(
        //                     child: ListTile(
        //                       leading: Icon(Icons.calendar_today),
        //                       title: Text('Upcoming Events'),
        //                       subtitle: Column(
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         children: [
        //                           Text('Weekly Meeting at: 4 PM'),
        //                           Text('Holiday: 15th July 2024'),
        //                           Text('Leave: 12th July 2024'),
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                   Card(
        //                     child: ListTile(
        //                       leading: Icon(Icons.history),
        //                       title: Text('Recent Activities'),
        //                       subtitle: Column(
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         children: [
        //                           Text('Meeting with team at 11:00 AM'),
        //                           Text('Submitted report at 2:00 PM'),
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),

        //           // const Divider(), // Add a divider line
        //           const Padding(
        //             // padding: const EdgeInsets.all(60.0),
        //             padding: EdgeInsets.only(top:60),
        //             child: Text(
        //               'History',
        //               style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           ),
        //           Expanded(
        //             child: ListView.builder(
        //               itemCount: employeeDetails.length,
        //               itemBuilder: (context, index) {
        //                 return buildEmployeeCard(employeeDetails[index]);
        //               },
        //             ),
        //           ),
        //         ],
        //       ),

        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // if (!isRegistered)
                  //   Padding(
                  //     padding: const EdgeInsets.all(16.0),
                  //     child: ElevatedButton(
                  //       onPressed: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) =>
                  //                   RegistrationScreen(siteManagerId: employeeId!)),
                  //         );
                  //       },
                  //       child: Text('Register Face'),
                  //     ),
                  //   ),
                  if (isWithinRange)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: isWithinRange
                              ? () {
                                  navigateToFaceRecognitionScreen();
                                }
                              : null,
                          child: const Text('Attendance'),
                        ),
                      ),
                    ),
                  Expanded(
                    child: ListView(
                      children: [
                        const Divider(
                          color: Colors.blue,
                          thickness: 2.0,
                        ),
                        const Card(
                          elevation: 5,
                          color: Color.fromARGB(255, 222, 200, 174),
                          child: ListTile(
                            leading: Icon(Icons.calendar_today),
                            title: Text(
                              'Upcoming Events',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Weekly Meeting at: 3 PM'),
                                Text('Holiday: 20th July 2024'),
                              ],
                            ),
                          ),
                        ),
                        if(broadcastMessage!=null)
                        Card(
                          elevation: 5,
                          color: Color.fromARGB(255, 222, 200, 174),
                          child: ListTile(
                            leading: Icon(Icons.message),
                            title: const Text(
                              'Global Communication',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(broadcastMessage ?? "No message"),
                              ],
                            ),
                          ),
                        ),

                        // const Padding(
                        //   padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                        //   child: Text(
                        //     'History',
                        //     style: TextStyle(
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 16.0),
                          child: Center(
                            child: Text(
                              'Attendance for the Day',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: employeeDetails.length,
                          itemBuilder: (context, index) {
                            return buildEmployeeCard(employeeDetails[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ));
  }
}









