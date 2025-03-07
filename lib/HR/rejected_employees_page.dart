import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RejectedEmployeesPage extends StatelessWidget {
  const RejectedEmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejected Employees'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('RejectedEmp').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.requireData;
          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              final doc = data.docs[index];
              final firstName = doc['firstName'];
              final lastName = doc['lastName'];
              final phone = doc['phoneNo'];
              final email = doc.id; // Assuming document ID is the email
              final reason = doc['reason']; // Fetch the reason field

              return RejectedEmployeeCard(
                firstName: firstName,
                lastName: lastName,
                phone: phone,
                email: email,
                reason: reason, // Pass the reason to the card
              );
            },
          );
        },
      ),
    );
  }
}

class RejectedEmployeeCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String reason;

  const RejectedEmployeeCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.reason, // Add reason parameter
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple[100],
          child: Text(
            firstName[0],
            style: const TextStyle(color: Colors.black),
          ),
        ),
        title: Text('$firstName $lastName'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone: $phone'),
            Text('Email: $email'),
            Text('Reason: $reason'), // Display the reason field
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Add your onPressed code here!
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RejectedEmployeeDetailsPage(
                  firstName: firstName,
                  lastName: lastName,
                  phone: phone,
                  email: email,
                  reason: reason,
                ),
              ),
            );
          },
          child: const Text('View More'),
        ),
      ),
    );
  }
}

class RejectedEmployeeDetailsPage extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String reason;

  const RejectedEmployeeDetailsPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First Name: $firstName',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Last Name: $lastName',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Phone: $phone', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('Email: $email', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('Reason for Rejection: $reason',
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
