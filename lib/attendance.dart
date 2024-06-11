import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;

  @override
  void initState() {
    super.initState();
    _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  }

  DateTime? _selectedDate;
  List<Map<String, dynamic>> _selectedDateAttendance = [];

  final List<Map<String, dynamic>> _attendanceData = [
    {
      'date': DateTime(2024, 6, 6),
      'name': 'John Doe',
      'checkIn': '09:00 AM',
      'checkOut': '05:00 PM',
      'isPresent': true,
    },
    {
      'date': DateTime(2024, 6, 6),
      'name': 'Jane Smith',
      'checkIn': '09:15 AM',
      'checkOut': '05:15 PM',
      'isPresent': true,
    },
    {
      'date': DateTime(2024, 6, 5),
      'name': 'Alice Johnson',
      'checkIn': null,
      'checkOut': null,
      'isPresent': false,
    },
  ];

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _showAttendance();
      });
    }
  }

  void _showAttendance() {
    if (_selectedDate != null) {
      setState(() {
        _selectedDateAttendance = _attendanceData.where((record) {
          return record['date'] == _selectedDate;
        }).toList();
      });

      if (_selectedDateAttendance.isEmpty) {
        _showSnackBar(
          'No attendance records found for ${DateFormat.yMMMd().format(_selectedDate!)}',
        );
      }
    } else {
      _showSnackBar('Please select a date first');
    }
  }

  Future<void> _downloadAttendance() async {
    List<List<String>> csvData = [
      ['Date', 'Name', 'Check-in', 'Check-out', 'Status']
    ];

    for (var record in _selectedDateAttendance) {
      csvData.add([
        DateFormat.yMMMd().format(record['date']),
        record['name'],
        record['checkIn'] ?? '--',
        record['checkOut'] ?? '--',
        record['isPresent'] ? 'Present' : 'Absent'
      ]);
    }

    String csvString = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/attendance_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
    final file = File(path);
    await file.writeAsString(csvString);

    _showSnackBar('Attendance data saved to $path');

    await _sendEmailWithAttendance(csvString);
  }

  Future<void> _sendEmailWithAttendance(String csvData) async {
    const serviceId = 'service_rnb0kpj';
    const templateId = 'template_s65l2jh';
    const userId = 'o-cXww5hhjiX8a7lj';
    const email = 'rimilrosetharakan@gmail.com'; // HR's email address

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'to_email': email,
            'subject': 'Attendance Report',
            'message': 'Please find the attached attendance report.',
            'attachment':
                'data:text/csv;base64,${base64Encode(utf8.encode(csvData))}',
          }
        }));

    if (response.statusCode == 200) {
      _showSnackBar('Email sent to HR successfully.');
    } else {
      _showSnackBar('Failed to send email.');
    }
  }

  void _showSnackBar(String message) {
    Future.delayed(Duration.zero, () {
      if (_scaffoldMessengerKey.currentState != null) {
        _scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(content: Text(message)),
        );
      } else {
        debugPrint('ScaffoldMessengerState is null');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        title: const Text('Attendance Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadAttendance,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedDateAttendance.length,
              itemBuilder: (context, index) {
                final record = _selectedDateAttendance[index];
                final status = record['isPresent'] ? 'Present' : 'Absent';
                final checkIn = record['checkIn'] ?? '--';
                final checkOut = record['checkOut'] ?? '--';

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(record['name']),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Status: $status',
                            style: TextStyle(
                                color: record['isPresent']
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ),
                        Flexible(
                          child: Text('Check-in: $checkIn'),
                        ),
                        Flexible(
                          child: Text('Check-out: $checkOut'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AttendancePage(),
  ));
}
