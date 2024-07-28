
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:ooriba_s3/HR/add_employees.dart';
// import 'package:ooriba_s3/HR/employee_details_page.dart';
// import 'package:ooriba_s3/HR/provideAttendance.dart';
// import 'package:ooriba_s3/HR/registered_employees_page.dart';
// import 'package:ooriba_s3/HR/leave_approval.dart';
// import 'package:ooriba_s3/HR/leave_report.dart';
// import 'package:ooriba_s3/services/auth_service.dart';
// import 'package:ooriba_s3/services/registered_service.dart';
// import 'attendance.dart'; // Assuming this file contains DatePickerButton widget
// import 'rejected_employees_page.dart';

// class HRDashboardPage extends StatefulWidget {
//   const HRDashboardPage({super.key});

//   @override
//   _HRDashboardPageState createState() => _HRDashboardPageState();
// }

// class _HRDashboardPageState extends State<HRDashboardPage> {
//   final RegisteredService _registeredService = RegisteredService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('HR Dashboard'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await AuthService().signout(context: context);
//             },
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text(
//                 'HR Dashboard Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.dashboard),
//               title: const Text('Dashboard'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.people),
//               title: const Text('Registered Employees'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _showRegisteredEmployees(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.time_to_leave),
//               title: const Text('Employee Leave Requests'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         LeaveApprovalPage(), // Navigate to LeaveApprovalPage
//                   ),
//                 );
//               },
//             ),
//             //  ListTile(
//             //   leading: const Icon(Icons.time_to_leave),
//             //   title: const Text('Leave Report'),
//             //   onTap: () {
//             //     Navigator.pop(context);
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //         builder: (context) =>
//             //             LeaveReportPage(), // Navigate to LeaveApprovalPage
//             //       ),
//             //     );
//             //   },
//             // ),
//             ListTile(
//               leading: const Icon(Icons.checklist_outlined),
//               title: const Text('Provide Attendance'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ProvideattendancePage()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.access_time),
//               title: const Text('Attendance'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const DatePickerButton()),
//                 );
//               },
//             ),
//             // ListTile(
//             //   leading: const Icon(Icons.time_to_leave),
//             //   title: const Text('Add employee'),
//             //   onTap: () {
//             //     Navigator.pop(context);
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => AddEmployeePage()),
//             //     );
//             //   },
//             // ),

//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Log Out'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await AuthService().signout(context: context);
//               },
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 'Dashboard',
//                 style: TextStyle(
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Flexible(
//                     child: _buildDashboardBlock(
//                       context,
//                       'Registered Employees',
//                       Icons.person,
//                       Colors.blue,
//                       _showRegisteredEmployees,
//                     ),
//                   ),
//                   // SizedBox(width: 16.0),
//                   // Expanded(
//                   //   child: _buildDashboardBlock(
//                   //     context,
//                   //     'New Applicants',
//                   //     Icons.person_add,
//                   //     Colors.green,
//                   //     _showNewApplicants,
//                   //   ),
//                   // ),
//                   const SizedBox(width: 16.0),
//                   Flexible(
//                     child: _buildDashboardBlock(
//                       context,
//                       'Rejected Applications',
//                       Icons.person_off,
//                       Colors.red,
//                       _showRejectedApplications,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 'Applicant Details',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             StreamBuilder<QuerySnapshot>(
//               stream:
//                   FirebaseFirestore.instance.collection('Employee').snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('No employees found'));
//                 }

//                 final employees = snapshot.data!.docs;
//                 return Column(
//                   children: employees.map((doc) {
//                     final data = doc.data() as Map<String, dynamic>;
//                     return _buildEmployeeCard(context, data, doc.reference);
//                   }).toList(),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDashboardBlock(BuildContext context, String title, IconData icon,
//       Color color, Function onTap) {
//     return GestureDetector(
//       onTap: () => onTap(context),
//       child: Container(
//         padding: const EdgeInsets.all(16.0),
//         width: 200.0,
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Icon(
//               icon,
//               color: Colors.white,
//               size: 36.0,
//             ),
//             const SizedBox(height: 8.0),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmployeeCard(BuildContext context, Map<String, dynamic> data,
//       DocumentReference docRef) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 CircleAvatar(
//                   radius: 30.0,
//                   backgroundColor: Colors.purple[100],
//                   backgroundImage: data['dpImageUrl'] != null &&
//                           data['dpImageUrl'].isNotEmpty
//                       ? NetworkImage(data['dpImageUrl'])
//                       : null,
//                   child:
//                       data['dpImageUrl'] == null || data['dpImageUrl'].isEmpty
//                           ? Text(
//                               '${data['firstName'][0]}${data['lastName'][0]}',
//                               style: const TextStyle(
//                                 fontSize: 24.0,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : null,
//                 ),
//                 const SizedBox(width: 16.0),
//                 Flexible(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         '${data['firstName']} ${data['lastName']}',
//                         style: const TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4.0),
//                       Text('Phone: ${data['phoneNo']}'),
//                       Text('Email: ${data['email']}'),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(height: 16.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             EmployeeDetailsPage(employeeData: data),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     'View More',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showRegisteredEmployees(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const RegisteredEmployeesPage()),
//     );
//   }

//   // void _showNewApplicants(BuildContext context) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //         title: const Text('New Applicants'),
//   //         content: const Text('List of new applicants...'),
//   //         actions: <Widget>[
//   //           TextButton(
//   //             child: const Text('Close'),
//   //             onPressed: () {
//   //               Navigator.of(context).pop();
//   //             },
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }

//   void _showRejectedApplications(BuildContext context) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => const RejectedEmployeesPage(),
//       ),
//     );
//   }

//   void _showEmployeeDetails(BuildContext context, Map<String, dynamic> data) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EmployeeDetailsPage(employeeData: data),
//       ),
//     );
//   }
// }

// class EditEmployeePage extends StatefulWidget {
//   final Map<String, dynamic> employeeData;

//   const EditEmployeePage({super.key, required this.employeeData});

//   @override
//   _EditEmployeePageState createState() => _EditEmployeePageState();
// }

// class _EditEmployeePageState extends State<EditEmployeePage> {
//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _emailController;
//   late TextEditingController _phoneNoController;
//   late TextEditingController _ageController;

//   @override
//   void initState() {
//     super.initState();
//     _firstNameController =
//         TextEditingController(text: widget.employeeData['firstName']);
//     _lastNameController =
//         TextEditingController(text: widget.employeeData['lastName']);
//     _emailController =
//         TextEditingController(text: widget.employeeData['email']);
//     _phoneNoController =
//         TextEditingController(text: widget.employeeData['phoneNo']);
//     _ageController =
//         TextEditingController(text: widget.employeeData['age'].toString());
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _phoneNoController.dispose();
//     _ageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Employee'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             TextField(
//               controller: _firstNameController,
//               decoration: const InputDecoration(labelText: 'First Name'),
//             ),
//             TextField(
//               controller: _lastNameController,
//               decoration: const InputDecoration(labelText: 'Last Name'),
//             ),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _phoneNoController,
//               decoration: const InputDecoration(labelText: 'Phone Number'),
//             ),
//             TextField(
//               controller: _ageController,
//               decoration: const InputDecoration(labelText: 'Age'),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 Map<String, dynamic> updatedEmployee = {
//                   'firstName': _firstNameController.text,
//                   'lastName': _lastNameController.text,
//                   'email': _emailController.text,
//                   'phoneNo': _phoneNoController.text,
//                   'age': int.parse(_ageController.text),
//                 };
//                 Navigator.pop(context, updatedEmployee);
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }















import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ooriba_s3/HR/employee_details_page.dart';
import 'package:ooriba_s3/HR/provideAttendance.dart';
import 'package:ooriba_s3/HR/registered_employees_page.dart';
import 'package:ooriba_s3/HR/leave_approval.dart';
import 'package:ooriba_s3/HR/leave_report.dart';
import 'package:ooriba_s3/services/auth_service.dart';
import 'package:ooriba_s3/services/registered_service.dart';
import 'attendance.dart'; // Assuming this file contains DatePickerButton widget
import 'rejected_employees_page.dart';

class HRDashboardPage extends StatefulWidget {
  const HRDashboardPage({super.key});

  @override
  _HRDashboardPageState createState() => _HRDashboardPageState();
}

class _HRDashboardPageState extends State<HRDashboardPage> {
  final RegisteredService _registeredService = RegisteredService();


  @override
  // void initState() {
  //   super.initState();
  //   setState(() {}); 
  // }
  final FirebaseFirestore _db=FirebaseFirestore.instance; 
  Future<Map<String, dynamic>?> fetchEmployeeDetails(String employeeId) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Regemp')
        .where('employeeId', isEqualTo: employeeId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assuming there's only one document for the given employeeId
      return querySnapshot.docs.first.data() as Map<String, dynamic>?;
    }
  } catch (e) {
    print('Failed to fetch employee details: $e');
  }
  return null;
}

Future<List<Map<String, dynamic>>> _fetchRequestedEmployees() async {
  List<Map<String, dynamic>> employees = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('SiteManagerAuth')
        .where('status', isEqualTo: 'requested')
        .get();

    for (var doc in querySnapshot.docs) {
      String employeeId = doc.id;
      String imageUrl = doc['imageUrl'];

      // Fetch additional details from Regemp
      var employeeDetails = await fetchEmployeeDetails(employeeId);
      String name = (employeeDetails?['firstName']) ?? '';
      String location=(employeeDetails?['location']) ?? '';
      String phoneNo=(employeeDetails?['phoneNo']) ?? '';

      employees.add({
        'employeeId': employeeId,
        'imageUrl': imageUrl,
        'name': name,
        'location':location,
        'phoneNo':phoneNo
      });
    }
  } catch (e) {
    print('Failed to fetch requested employees: $e');
  }

  return employees;
}


Future<void> _approveEmployee(String employeeId) async {
    await _db.collection('SiteManagerAuth').doc(employeeId).update({
      'status': 'approved',
      'set':'1'
    });
  }

 void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Image.network(imageUrl),
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HR Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signout(context: context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'HR Dashboard Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Registered Employees'),
              onTap: () {
                Navigator.pop(context);
                _showRegisteredEmployees(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.time_to_leave),
              title: const Text('Employee Leave Requests'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LeaveApprovalPage(), // Navigate to LeaveApprovalPage
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.checklist_outlined),
              title: const Text('Provide Attendance'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProvideattendancePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Attendance'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DatePickerButton()),
                );
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () async {
                Navigator.pop(context);
                await AuthService().signout(context: context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: _buildDashboardBlock(
                      context,
                      'Registered Employees',
                      Icons.person,
                      Colors.blue,
                      _showRegisteredEmployees,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: _buildDashboardBlock(
                      context,
                      'Rejected Applications',
                      Icons.person_off,
                      Colors.red,
                      _showRejectedApplications,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Applicant Details/ Face Registration',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
             FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchRequestedEmployees(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text(''));
                } else {
                  List<Map<String, dynamic>> employees = snapshot.data!;
                  return Column(
                    children: employees.map((data) {
                      String employeeId = data['employeeId'] ?? '';
                      String imageUrl = data['imageUrl'] ?? '';
                      String status = "Face registration request";
                       String name = data['name'] ?? 'Unknown';
                       String location=data['location'];
                       String phoneNo=data['phoneNo'];
                       
                     return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: InkWell(
                    onTap: () {
                      if (imageUrl.isNotEmpty) {
                        _showImageDialog(context, imageUrl);
                      }
                    },
                    child: imageUrl.isNotEmpty
                        ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.image_not_supported, size: 50),
                  ),
                  title: Text("$name:$employeeId", style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),),
                  subtitle: Text('Location: $location\nPhone:$phoneNo\n$status'),
                  
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await _approveEmployee(employeeId);
                      setState(() {}); // Refresh the UI
                    },
                    child: const Text('Approve'),
                  ),
                ),
              );
            }).toList(),
                  );
                }
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Employee').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No employees found'));
                }

                final employees = snapshot.data!.docs;
                return Column(
                  children: employees.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return _buildEmployeeCard(context, data, doc.reference);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardBlock(BuildContext context, String title, IconData icon,
      Color color, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: 200.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
              size: 36.0,
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, Map<String, dynamic> data,
      DocumentReference docRef) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.purple[100],
                  backgroundImage: data['dpImageUrl'] != null &&
                          data['dpImageUrl'].isNotEmpty
                      ? NetworkImage(data['dpImageUrl'])
                      : null,
                  child:
                      data['dpImageUrl'] == null || data['dpImageUrl'].isEmpty
                          ? Text(
                              '${data['firstName'][0]}${data['lastName'][0]}',
                              style: const TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                              ),
                            )
                          : null,
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${data['firstName']} ${data['lastName']}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text('Phone: ${data['phoneNo']}'),
                    Text('Email: ${data['email']}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EmployeeDetailsPage(employeeData: data),
                      ),
                    );
                  },
                  child: const Text(
                    'View More',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRegisteredEmployees(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisteredEmployeesPage()),
    );
  }


  void _showRejectedApplications(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RejectedEmployeesPage(),
      ),
    );
  }

  void _showEmployeeDetails(BuildContext context, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeDetailsPage(employeeData: data),
      ),
    );
  }
}

class EditEmployeePage extends StatefulWidget {
  final Map<String, dynamic> employeeData;

  const EditEmployeePage({super.key, required this.employeeData});

  @override
  _EditEmployeePageState createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNoController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.employeeData['firstName']);
    _lastNameController =
        TextEditingController(text: widget.employeeData['lastName']);
    _emailController =
        TextEditingController(text: widget.employeeData['email']);
    _phoneNoController =
        TextEditingController(text: widget.employeeData['phoneNo']);
    _ageController =
        TextEditingController(text: widget.employeeData['age'].toString());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneNoController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> updatedEmployee = {
                  'firstName': _firstNameController.text,
                  'lastName': _lastNameController.text,
                  'email': _emailController.text,
                  'phoneNo': _phoneNoController.text,
                  'age': int.parse(_ageController.text),
                };
                Navigator.pop(context, updatedEmployee);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}