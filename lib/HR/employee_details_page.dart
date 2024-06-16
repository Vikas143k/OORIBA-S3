import 'package:flutter/material.dart';
import 'package:ooriba_s3/services/display_service.dart';
// Ensure the correct path is used

class EmployeeDetailsPage extends StatefulWidget {
  final Map<String, dynamic> employeeData;

  EmployeeDetailsPage({required this.employeeData});

  @override
  _EmployeeDetailsPageState createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  late Map<String, dynamic> employeeData;
  bool isEditing = false;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    employeeData = Map<String, dynamic>.from(widget.employeeData);
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveDetails() async {
    try {
      print(
          'Saving data: ${employeeData['id']} -> $employeeData'); // Log the data being saved
      await _firestoreService.saveEmployeeData(
          employeeData['id'], employeeData);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Employee details updated successfully')));
      setState(() {
        isEditing = false;
      });
    } catch (e) {
      print('Error saving employee data: $e'); // Log the error
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update employee details: $e')));
    }
  }

  Widget _buildDetailRow(String label, String value, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: isEditing
                ? TextField(
                    controller: TextEditingController(text: value),
                    onChanged: (newValue) {
                      employeeData[key] = newValue;
                    },
                  )
                : Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${employeeData['firstName']} ${employeeData['lastName']}'),
        actions: <Widget>[
          if (!isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _toggleEdit,
            )
          else
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveDetails,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildDetailRow(
                  'First Name', employeeData['firstName'] ?? '', 'firstName'),
              _buildDetailRow('Middle Name', employeeData['middleName'] ?? '',
                  'middleName'),
              _buildDetailRow(
                  'Last Name', employeeData['lastName'] ?? '', 'lastName'),
              _buildDetailRow('Email', employeeData['email'] ?? '', 'email'),
              _buildDetailRow(
                  'Phone Number', employeeData['phoneNo'] ?? '', 'phoneNo'),
              _buildDetailRow(
                  'Date of Birth', employeeData['dob'] ?? '', 'dob'),
              _buildDetailRow('Permanent Address',
                  employeeData['permanentAddress'] ?? '', 'permanentAddress'),
              _buildDetailRow(
                  'Residential Address',
                  employeeData['residentialAddress'] ?? '',
                  'residentialAddress'),
              _buildDetailRow(
                  'Adhaar URL', employeeData['adhaarUrl'] ?? '', 'adhaarUrl'),
              _buildDetailRow('DP Image URL', employeeData['dpImageUrl'] ?? '',
                  'dpImageUrl'),
              _buildDetailRow('Support URL', employeeData['supportUrl'] ?? '',
                  'supportUrl'),
              // Add more details as needed
            ],
          ),
        ),
      ),
    );
  }
}
