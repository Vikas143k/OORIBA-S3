import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ooriba_s3/services/retrieveFromDates_service.dart'; // For formatting date
// import 'date_service.dart'; // Import the service file
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage

class DatePickerButton extends StatefulWidget {
  @override
  _DatePickerButtonState createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  DateTime? _selectedDate;
  Map<String, Map<String, String>> _data = {};

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchData(DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  void _fetchData(String date) async {
    DateService service = DateService();
    Map<String, Map<String, String>> data = await service.getDataByDate(date);
    setState(() {
      _data = data;
    });
  }

  Future<String> getImageUrl(String email) async {
    // Construct the path to the image in Firebase Storage
    String imagePath = 'authImage/$email.jpg';

    try {
      // Get the download URL for the image
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error fetching image for $email: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Page'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: (){_selectDate(context);
            } ,
            child: Text('Select date'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                String email = _data.keys.elementAt(index);
                Map<String, String> emailData = _data[email]!;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(email),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('Check-in: ${emailData['checkIn']}')),
                            Expanded(child: Text('Check-out: ${emailData['checkOut']}')),
                          ],
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Status: ',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: 'present',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.image),
                      onPressed: () async {
                        String imageUrl = await getImageUrl(email);
                        if (imageUrl.isNotEmpty) {
                          // Show image dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Image.network(imageUrl),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Handle error case
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text('Image not found for $email'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
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
