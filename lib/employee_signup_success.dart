import 'package:flutter/material.dart';
import 'package:ooriba_s3/facial/RegistrationScreen.dart';
import 'package:ooriba_s3/main.dart';

class ConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 100,
              ),
              SizedBox(height: 30),
              Text(
                'Signed up successfully',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Please wait for HR approval',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                   Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue, backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'HOME',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                   Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegistrationScreen()),
      );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue, backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Go to Registration',
                  style: TextStyle(fontSize: 20),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  //  Widget _navigateToRegistration(BuildContext context) {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: const Color(0xff0D6EFD),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(14),
  //       ),
  //       minimumSize: const Size(double.infinity, 60),
  //       elevation: 0,
  //     ),
  //     onPressed: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => RegistrationScreen()),
  //       );
  //     },
  //     child: const Text("Go to Registration"),
  //   );
  // }
}
