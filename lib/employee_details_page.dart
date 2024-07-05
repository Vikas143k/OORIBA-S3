import 'package:flutter/material.dart';

class EmployeeDetailsPage extends StatelessWidget {
  final Map<String, dynamic> employeeData;

  EmployeeDetailsPage({required this.employeeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${employeeData['firstName']} ${employeeData['lastName']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildDetailRow('First Name', employeeData['firstName']),
              _buildDetailRow('Last Name', employeeData['lastName']),
              _buildDetailRow('Email', employeeData['email']),
              _buildDetailRow('Phone Number', employeeData['phoneNo']),
              _buildDetailRow('Age', employeeData['age'].toString()),
              _buildDetailRow('Date of Birth', employeeData['dob']),
              _buildDetailRow(
                  'Permanent Address', employeeData['permanentAddress']),
              _buildDetailRow(
                  'Residential Address', employeeData['residentialAddress']),
              // Add more details as needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
