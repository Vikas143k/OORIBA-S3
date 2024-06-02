import 'package:flutter/material.dart';
import 'package:ooriba_s3/services/hrDashboardService.dart';


class DataDisplayScreen extends StatefulWidget {
  @override
  _DataDisplayScreenState createState() => _DataDisplayScreenState();
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {
  FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    var data = await _firestoreService.getData();
    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Data'),
      ),
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                var item = _data[index];
                return ListTile(
                  title: Text(item['firstName']),
                  subtitle: Text('Phone: ${item['lastName']}'),
                  trailing: Text('Number: ${item['dob']}'),
                );
              },
            ),
    );
  }
}
