import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HRDashboardPage(),
    );
  }
}

class HRDashboardPage extends StatefulWidget {
  const HRDashboardPage({Key? key}) : super(key: key);

  @override
  _HRDashboardPageState createState() => _HRDashboardPageState();
}

class _HRDashboardPageState extends State<HRDashboardPage> {
  // State variables to keep track of the accepted state of each employee card
  final Map<int, bool> _isAccepted = {};
  List<Employee> employees = [
    Employee(
        name: 'John Doe',
        age: 30,
        phone: '123-456-7890',
        email: 'john.doe@example.com',
        dob: '01/01/1990',
        pan: 'ABCDE1234F',
        residentialAddress: '123 Main St',
        permanentAddress: '456 Main St'),
    Employee(
        name: 'Jane Smith',
        age: 25,
        phone: '987-654-3210',
        email: 'jane.smith@example.com',
        dob: '02/02/1995',
        pan: 'FGHIJ5678K',
        residentialAddress: '789 Main St',
        permanentAddress: '101 Main St'),
    Employee(
        name: 'Alice Johnson',
        age: 28,
        phone: '555-666-7777',
        email: 'alice.johnson@example.com',
        dob: '03/03/1992',
        pan: 'KLMNO1234P',
        residentialAddress: '102 Main St',
        permanentAddress: '103 Main St'),
    Employee(
        name: 'Bob Brown',
        age: 35,
        phone: '111-222-3333',
        email: 'bob.brown@example.com',
        dob: '04/04/1985',
        pan: 'QRSTU5678V',
        residentialAddress: '104 Main St',
        permanentAddress: '105 Main St'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HR Dashboard'),
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
              title: const Text('Employee'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Employee Page
              },
            ),
            ListTile(
              leading: const Icon(Icons.time_to_leave),
              title: const Text('Leave'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Leave Page
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                // Implement log out logic
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
              // padding: const EdgeInsets.all(16.0),
              padding: EdgeInsets.all(2.0),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              // padding: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
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
                  // SizedBox(width: 16.0),
                  SizedBox(width: 2.0),
                  Expanded(
                    child: _buildDashboardBlock(
                      context,
                      'New Applicants',
                      Icons.person_add,
                      Colors.green,
                      _showNewApplicants,
                    ),
                  ),
                  // SizedBox(width: 16.0),
                  SizedBox(width: 2.0),
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
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Employee Details',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Employee cards will be added dynamically here
            for (int i = 0; i < employees.length; i++)
              _buildEmployeeCard(context, i),
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
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
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

  Widget _buildEmployeeCard(BuildContext context, int index) {
    bool isAccepted = _isAccepted[index] ?? false;
    Employee employee = employees[index];

    void _acceptEmployee() {
      // Replace with your actual logic for accepting the employee (e.g., API call, database update)
      print('Employee accepted!');
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  // Placeholder image, replace with actual photo
                   child: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/ooriba-s3-add23.appspot.com/o/image%2Fdp.png?alt=media&token=87f1b3a7-d249-4976-bdf9-5fdaa808bea0',
          ),
                  radius: 30.0,
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      employee.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Age: ${employee.age}', // Example age; replace with actual data
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Phone: ${employee.phone}',
            ),
            Text(
              'Email: ${employee.email}',
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    _showEmployeeDetails(context, index);
                  },
                  child: Text(
                    'View More',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 24.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      _isAccepted[index] = !isAccepted;
                      if (_isAccepted[index]!) {
                        _acceptEmployee();
                      }
                    });
                    if (isAccepted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditEmployeePage(
                            employeeIndex: index,
                            employee: employee,
                          ),
                        ),
                      ).then((updatedEmployee) {
                        if (updatedEmployee != null) {
                          setState(() {
                            employees[index] = updatedEmployee;
                          });
                        }
                      });
                    }
                  },
                  child: Text(
                    isAccepted ? 'Edit' : 'Accept',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 24.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    // Implement reject logic
                  },
                  child: const Text(
                    'Reject',
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registered Employees'),
          content: const Text('Details of registered employees will be shown here.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showNewApplicants(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Applicants'),
          content: const Text('Details of new applicants will be shown here.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showRejectedApplications(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rejected Applications'),
          content: const Text('Details of rejected applications will be shown here.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showEmployeeDetails(BuildContext context, int index) {
    Employee employee = employees[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(employee.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Date of Birth: ${employee.dob}'),
                Text('PAN: ${employee.pan}'),
                Text('Residential Address: ${employee.residentialAddress}'),
                Text('Permanent Address: ${employee.permanentAddress}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            /* Remove the Edit button by commenting it out or deleting this block
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditEmployeePage(
                      employeeIndex: index,
                      employee: employee,
                    ),
                  ),
                ).then((updatedEmployee) {
                  if (updatedEmployee != null) {
                    setState(() {
                      employees[index] = updatedEmployee;
                    });
                  }
                });
              },
              child: const Text('Edit'),
            ),
            */
          ],
        );
      },
    );
  }
}

class Employee {
  String name;
  int age;
  String phone;
  String email;
  String dob;
  String pan;
  String residentialAddress;
  String permanentAddress;

  Employee({
    required this.name,
    required this.age,
    required this.phone,
    required this.email,
    required this.dob,
    required this.pan,
    required this.residentialAddress,
    required this.permanentAddress,
  });
}

class EditEmployeePage extends StatefulWidget {
  final int employeeIndex;
  final Employee employee;

  const EditEmployeePage({
    Key? key,
    required this.employeeIndex,
    required this.employee,
  }) : super(key: key);

  @override
  _EditEmployeePageState createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _panController;
  late TextEditingController _residentialAddressController;
  late TextEditingController _permanentAddressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _ageController = TextEditingController(text: widget.employee.age.toString());
    _phoneController = TextEditingController(text: widget.employee.phone);
    _emailController = TextEditingController(text: widget.employee.email);
    _dobController = TextEditingController(text: widget.employee.dob);
    _panController = TextEditingController(text: widget.employee.pan);
    _residentialAddressController = TextEditingController(text: widget.employee.residentialAddress);
    _permanentAddressController = TextEditingController(text: widget.employee.permanentAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _panController.dispose();
    _residentialAddressController.dispose();
    _permanentAddressController.dispose();
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _dobController,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
              ),
              TextField(
                controller: _panController,
                decoration: const InputDecoration(labelText: 'PAN'),
              ),
              TextField(
                controller: _residentialAddressController,
                decoration: const InputDecoration(labelText: 'Residential Address'),
              ),
              TextField(
                controller: _permanentAddressController,
                decoration: const InputDecoration(labelText: 'Permanent Address'),
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Employee updatedEmployee = Employee(
                        name: _nameController.text,
                        age: int.parse(_ageController.text),
                        phone: _phoneController.text,
                        email: _emailController.text,
                        dob: _dobController.text,
                        pan: _panController.text,
                        residentialAddress: _residentialAddressController.text,
                        permanentAddress: _permanentAddressController.text,
                      );
                      Navigator.of(context).pop(updatedEmployee);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
