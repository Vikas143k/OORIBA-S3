import 'package:flutter/material.dart';

class EmployeeCheckInPage extends StatefulWidget {
  final String email;

  EmployeeCheckInPage(this.email);

  @override
  // ignore: library_private_types_in_public_api
  _EmployeeCheckInPageState createState() => _EmployeeCheckInPageState();
}

class CheckInOutRecord {
  final DateTime date;
  bool isCheckedIn;
  DateTime? checkInTime;
  DateTime? checkOutTime;

  CheckInOutRecord(
      {required this.date,
      this.isCheckedIn = false,
      this.checkInTime,
      this.checkOutTime});
}

class _EmployeeCheckInPageState extends State<EmployeeCheckInPage> {
  late List<CheckInOutRecord> checkInOutRecords;
   late String email;
  @override
  void initState() {
    super.initState();
    email = widget.email;
    checkInOutRecords = _generateCheckInOutRecords();
  }

  List<CheckInOutRecord> _generateCheckInOutRecords() {
    // Generate records for the last 7 days
    List<CheckInOutRecord> records = [];
    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime date = now.subtract(Duration(days: i));
      // Dummy logic to alternate check-in and check-out for demonstration
      bool isCheckedIn = i.isEven;
      DateTime? checkInTime = isCheckedIn ? date.add(Duration(hours: 9)) : null;
      DateTime? checkOutTime =
          isCheckedIn ? null : date.add(Duration(hours: 18));

      records.add(CheckInOutRecord(
          date: date,
          isCheckedIn: isCheckedIn,
          checkInTime: checkInTime,
          checkOutTime: checkOutTime));
    }
    return records;
  }

  void _toggleCheckInOut(int index) {
    setState(() {
      checkInOutRecords[index].isCheckedIn =
          !checkInOutRecords[index].isCheckedIn;
      if (checkInOutRecords[index].isCheckedIn) {
        checkInOutRecords[index].checkInTime = DateTime.now();
        checkInOutRecords[index].checkOutTime = null;
      } else {
        checkInOutRecords[index].checkOutTime = DateTime.now();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Check In/Out -$email'),
      ),
      body: ListView.builder(
        itemCount: checkInOutRecords.length,
        itemBuilder: (context, index) {
          return CheckInOutCard(
              record: checkInOutRecords[index],
              onToggle: () => _toggleCheckInOut(index));
        },
      ),
    );
  }
}

class CheckInOutCard extends StatelessWidget {
  final CheckInOutRecord record;
  final VoidCallback onToggle;

  const CheckInOutCard({Key? key, required this.record, required this.onToggle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor = record.isCheckedIn ? Colors.green : Colors.red;
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${record.date.day}/${record.date.month}/${record.date.year}',
              style: TextStyle(
                  color: statusColor), // Set color based on check-in/out status
            ),
            const SizedBox(height: 8),
            Text(
                'Status: ${record.isCheckedIn ? 'Checked In' : 'Checked Out'}'),
            const SizedBox(height: 8),
            Text('Check In Time: ${record.checkInTime ?? 'N/A'}'),
            Text('Check Out Time: ${record.checkOutTime ?? 'N/A'}'),
            const SizedBox(height: 8),
            Switch(
              value: record.isCheckedIn,
              onChanged: (_) => onToggle(),
            ),
          ],
        ),
      ),
    );
  }
}

