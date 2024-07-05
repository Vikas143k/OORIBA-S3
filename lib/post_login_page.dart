import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ooriba_s3/facial/DB/DatabaseHelper.dart';
import 'package:ooriba_s3/facial/RecognitionScreen.dart';
import 'package:ooriba_s3/facial/RegistrationScreen.dart';
import 'package:ooriba_s3/services/auth_service.dart';
import 'package:ooriba_s3/services/geo_service.dart';
import 'package:ooriba_s3/services/retrieveDataByEmail.dart'
    as retrieveDataByEmail;
import 'package:ooriba_s3/services/user.dart';

class PostLoginPage extends StatefulWidget {
  final String email;
  final Map<String, dynamic> userDetails;

  const PostLoginPage(
      {super.key, required this.email, required this.userDetails});

  @override
  _PostLoginPageState createState() => _PostLoginPageState();
}

class _PostLoginPageState extends State<PostLoginPage> {
  bool isPresent = false;
  String? employeeId;
  String? employeeName;
  String? employeePhoneNumber;
  String? dpImageUrl;
  DateTime? lastLoginTime;
  final UserFirestoreService firestoreService = UserFirestoreService();
  late DatabaseHelper dbHelper;
  bool isRegistered = false;
  DateTime? checkInTime;
  DateTime? checkOutTime;
  bool isLoading = true;
  bool isCheckedIn = false;
  final GeoService geoService = GeoService();
  bool isWithinRange = false;
  bool isLoadingForLocation = false;
  Timer? _disableButtonTimer;
  
  

  @override
  void initState() {
    super.initState();
     _startLocationCheckTimer();
    dbHelper = DatabaseHelper();
    fetchEmployeeData();
    _checkIfFaceIsRegistered();
  }
  Future<void> fetchEmployeeData() async {
    await _fetchEmployeeDetails(widget.email);
    await _fetchCheckInStatus(widget.email);
    await _fetchLastLoginTime(widget.email);
    setState(() {
      isLoading = false;
    });
  }
   void _startLocationCheckTimer() {
    _disableButtonTimer = Timer(Duration(minutes: 5), () {
      setState(() {
        isWithinRange = false;
      });
      Fluttertoast.showToast(msg: 'Check-in button disabled after 5 minutes');
    });// Initial check
  }
  
  Future<void> _checkIfFaceIsRegistered() async {
    await dbHelper.init();
    final allRows = await dbHelper.queryAllRows();
    setState(() {
      isRegistered = allRows.isNotEmpty;
    });
  }

  void _checkLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      Position position = await geoService.determinePosition();
      bool withinRange = await geoService.isWithin50m(position);

      setState(() {
        isWithinRange = withinRange;
        isLoading = false;
      });

      Fluttertoast.showToast(
          msg: withinRange
              ? ""
              : "You're not at the location");
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatTime(DateTime? time) {
    if (time == null) return "N/A";
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
  }

  Future<void> _fetchEmployeeDetails(String email) async {
    retrieveDataByEmail.FirestoreService firestoreService =
        retrieveDataByEmail.FirestoreService();
    Map<String, dynamic>? employeeData =
        await firestoreService.getEmployeeByEmail(email, "Regemp");

    if (employeeData != null) {
      setState(() {
        employeeId = employeeData['employeeId'];
        employeeName = employeeData['firstName'];
        employeePhoneNumber = employeeData['phoneNo'];
        dpImageUrl = employeeData['dpImageUrl'];
      });
    } else {
      print('Employee details not found for email: $email');
    }
  }

  Future<void> _fetchCheckInStatus(String email) async {
    UserFirestoreService firestoreService = UserFirestoreService();
    DateTime today = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(today);

    try {
      DocumentSnapshot docSnapshot =
          await firestoreService.getCheckInOutData(employeeId!, todayDate);

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic>? employeeData = data[employeeId];

        if (employeeData != null) {
          setState(() {
            isCheckedIn = employeeData['checkIn'] != null &&
                employeeData['checkOut'] == null;
            checkInTime = employeeData['checkIn']?.toDate();
            checkOutTime = employeeData['checkOut']?.toDate();
            isPresent=true;
          });
        }
      } else {
        print('Check-in data not found for date: $todayDate');
      }
    } catch (e) {
      print('Error fetching check-in status: $e');
    }
  }

  Future<void> _fetchLastLoginTime(String email) async {
    try {
      DocumentSnapshot docSnapshot =
          await firestoreService.getLastLoginTime(email);

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        var lastLoginTimestamp = data['lastLoginTime'];

        if (lastLoginTimestamp != null) {
          setState(() {
            lastLoginTime = (lastLoginTimestamp as Timestamp).toDate();
          });
        } else {
          print('Last login time is null for email: $email');
          await _updateLastLoginTime(email);
        }
      } else {
        print('Document not found for email: $email');
        await _createAndSaveLastLoginTime(email);
      }
    } catch (e) {
      print('Error fetching last login time: $e');
      if (e is FirebaseException && e.code == 'not-found') {
        await _createAndSaveLastLoginTime(email);
      }
    }
  }

  Future<void> _createAndSaveLastLoginTime(String email) async {
    DateTime now = DateTime.now();
    await firestoreService.createLastLoginTime(email, now);
    setState(() {
      lastLoginTime = now;
    });
  }

  Future<void> _updateLastLoginTime(String email) async {
    DateTime now = DateTime.now();
    await firestoreService.saveLastLoginTime(email, now);
    setState(() {
      lastLoginTime = now;
    });
  }

  Future<void> _checkIn() async {
    DateTime now = DateTime.now();
    await firestoreService.addCheckInOutData(employeeId!, now, null, now);
    

    setState(() {
      isCheckedIn = true;
      checkInTime = now;
      isPresent=true;
    });
  }


  Future<void> _checkOut() async {
    DateTime now = DateTime.now();
    await firestoreService.addCheckInOutData(
        employeeId!, checkInTime!, now, now);

    setState(() {
      isCheckedIn = false;
      checkOutTime = now;
      isPresent=true;
    });
  }

  Future<void> _saveLastLoginTime() async {
    DateTime now = DateTime.now();
    await firestoreService.saveLastLoginTime(widget.email, now);
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
      return 'N/A';
    }
    // return DateFormat('dd-MM-yyyy   HH:mm').format(dateTime);
    return DateFormat.yMMMMd('en_US').add_Hm().format(dateTime);
  }

  void navigateToFaceRecognitionScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RecognitionScreen(email: widget.email)),
    );

    if (result == true) {
      if (isCheckedIn) {
        _checkOut();
      } else {
        _checkIn();
      }
    }
  }
  

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (dpImageUrl != null)
              CircleAvatar(
                backgroundImage: NetworkImage(dpImageUrl!),
              ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employeeName != null
                    ? 'Welcome, $employeeName-$employeeId'
                    : "Loading"),
                if (lastLoginTime != null)
                  Text(
                    'Last login: ${formatTimeWithoutSeconds(lastLoginTime)}',
                    style: TextStyle(fontSize: 14),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _saveLastLoginTime();
              await AuthService().signout(context: context);
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed:isWithinRange ? () {
                            if (isRegistered) {
                              navigateToFaceRecognitionScreen();
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationScreen()),
                              );
                            }
                          }:null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isCheckedIn ? Colors.green : Colors.orange,
                                padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15)
                          ),
                          child: Text(isCheckedIn ? 'Check-out' : 'Check-in'),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.location_on, size: 40),
                          onPressed: _checkLocation,
                        ),
                        SizedBox(width: 20),
                        isPresent
                            ? FutureBuilder<String>(
                                future: getImageUrl(employeeId!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError ||
                                      !snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Text('No image');
                                  } else {
                                    return InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content:
                                                Image.network(snapshot.data!),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Close'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Image.network(
                                        snapshot.data!,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.fill,
                                      ),
                                    );
                                  }
                                },
                              )
                            : const Icon(Icons.no_accounts, size: 60),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // if (isCheckedIn)
                  //   Text('Checked in at: ${formatTimeWithoutSeconds(checkInTime)}'),
                  // if (checkOutTime != null && !isCheckedIn)
                  //   Text('Checked out at: ${formatTimeWithoutSeconds(checkOutTime)}'),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly, // Adjust as needed
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 70, // Adjust the height as needed
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Last Check-in',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(formatTime(checkInTime)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // Adjust spacing between cards
                      Expanded(
                        child: SizedBox(
                          height: 70, // Adjust the height as needed
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Last Check-out',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(formatTime(checkOutTime)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: const [
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Personal Details'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email: johndoe@example.com'),
                                Text('Phone: +1234567890'),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.bar_chart),
                            title: Text('Performance Statistics'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Completed Projects: 15'),
                                Text('Ongoing Projects: 3'),
                                Text('Performance Rating: 4.8/5'),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.history),
                            title: Text('Recent Activities'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Checked in at 9:00 AM'),
                                Text('Meeting with team at 11:00 AM'),
                                Text('Submitted report at 2:00 PM'),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.calendar_today),
                            title: Text('Upcoming Events'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Project Deadline: 5th July 2024'),
                                Text('Client Meeting: 7th July 2024'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
