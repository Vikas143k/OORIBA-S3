import 'package:flutter/material.dart';
import 'package:ooriba_s3/services/geo_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckInPage extends StatefulWidget {
  @override
  _CheckInPageState createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final GeoService geoService = GeoService();
  bool isWithinRange = false;
  bool isLoading = false;

  void _checkLocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      Position position = await geoService.determinePosition();
      bool withinRange = await geoService.isWithin50m(position);

      setState(() {
        isWithinRange = withinRange;
        isLoading = false;
      });

      Fluttertoast.showToast(
          msg: withinRange
              ? "You're in 50m radius of the location"
              : "You're not in 50m radius from location");
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check-in Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isWithinRange ? () {
                // Check-in logic here
                Fluttertoast.showToast(msg: 'Checked in successfully!');
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isWithinRange ? Colors.orange : Colors.grey,
              ),
              child: Text('Check-in'),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.location_on),
              onPressed: _checkLocation,
            ),
            if (isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CheckInPage(),
  ));
}
