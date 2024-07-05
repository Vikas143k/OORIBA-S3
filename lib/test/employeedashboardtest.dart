import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EmployeeDashboard(),
    );
  }
}

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  _EmployeeDashboardState createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  bool isCheckedIn = false;
  DateTime? checkInTime;
  DateTime? checkOutTime;

  void toggleCheckInStatus() {
    setState(() {
      if (isCheckedIn) {
        checkOutTime = DateTime.now();
      } else {
        checkInTime = DateTime.now();
        checkOutTime = null;
      }
      isCheckedIn = !isCheckedIn;
    });
  }

  String formatTime(DateTime? time) {
    if (time == null) return "N/A";
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle logout
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Last login: 3rd July 2024, 10:30 AM',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: toggleCheckInStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCheckedIn ? Colors.green : Colors.orange,
              ),
              child: Text(isCheckedIn ? 'Check-out' : 'Check-in'),
            ),
            const SizedBox(height: 10),
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
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
