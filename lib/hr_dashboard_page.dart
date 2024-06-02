import 'package:flutter/material.dart';

class HRDashboardPage extends StatefulWidget {
  const HRDashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HRDashboardPageState createState() => _HRDashboardPageState();
}
class _HRDashboardPageState extends State<HRDashboardPage> {
  // State variables to keep track of the accepted state of each employee card
  final Map<int, bool> _isAccepted = {};
  List<Employee> employees = [
    Employee(name: 'John Doe', age: 30, phone: '123-456-7890', email: 'john.doe@example.com'),
    Employee(name: 'Jane Smith', age: 25, phone: '987-654-3210', email: 'jane.smith@example.com'),
    Employee(name: 'Alice Johnson', age: 28, phone: '555-666-7777', email: 'alice.johnson@example.com'),
    Employee(name: 'Bob Brown', age: 35, phone: '111-222-3333', email: 'bob.brown@example.com'),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: <Widget>[
                _buildDashboardBlock(
                  context,
                  'Registered Employees',
                  Icons.person,
                  Colors.blue,
                  _showRegisteredEmployees,
                ),
                _buildDashboardBlock(
                  context,
                  'New Applicants',
                  Icons.person_add,
                  Colors.green,
                  _showNewApplicants,
                ),
                _buildDashboardBlock(
                  context,
                  'Rejected Applications',
                  Icons.person_off,
                  Colors.red,
                  _showRejectedApplications,
                ),
              ],
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
            for (int i = 0; i < employees.length; i++) _buildEmployeeCard(context, i),
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
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisteredEmployeesPage()),
    );
  }

  void _showNewApplicants(BuildContext context) {
    // Implement navigation to new applicants page
  }

  void _showRejectedApplications(BuildContext context) {
    // Implement navigation to rejected applications page
  }
}

class RegisteredEmployeesPage extends StatelessWidget {
  const RegisteredEmployeesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Employees'),
      ),
      body: ListView.builder(
        itemCount: 10, // Example itemCount; replace with actual data
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Employee ${index + 1}'),
            onTap: () {
              // Implement navigation to employee details page
            },
          );
        },
      ),
    );
  }
}

class EditEmployeePage extends StatefulWidget {
  final int employeeIndex;
  final Employee employee;

  EditEmployeePage({
    required this.employeeIndex,
    required this.employee,
  });

  @override
  _EditEmployeePageState createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _ageController = TextEditingController(text: widget.employee.age.toString());
    _phoneController = TextEditingController(text: widget.employee.phone);
    _emailController = TextEditingController(text: widget.employee.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveEmployeeDetails() {
    Employee updatedEmployee = Employee(
      name: _nameController.text,
      age: int.parse(_ageController.text),
      phone: _phoneController.text,
      email: _emailController.text,
    );
    Navigator.pop(context, updatedEmployee);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Age',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _saveEmployeeDetails,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class Employee {
  String name;
  int age;
  String phone;
  String email;

  Employee({
    required this.name,
    required this.age,
    required this.phone,
    required this.email,
  });
}