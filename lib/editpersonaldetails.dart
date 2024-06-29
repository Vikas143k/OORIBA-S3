import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPersonalDetailsPage extends StatefulWidget {
  final String email;
  final Map<String, dynamic> userDetails;

  const EditPersonalDetailsPage({Key? key, required this.email, required this.userDetails}) : super(key: key);

  @override
  _EditPersonalDetailsPageState createState() => _EditPersonalDetailsPageState();
}

class _EditPersonalDetailsPageState extends State<EditPersonalDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumber = TextEditingController();
  final _firstName = TextEditingController();
  final _middleName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _residentialAddress = TextEditingController();
  final _permanentAddress = TextEditingController();
  final _password = TextEditingController();
  File? dpImage, supportImage, adhaarImage;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the existing user details
    _firstName.text = widget.userDetails['firstName'] ?? '';
    _middleName.text = widget.userDetails['middleName'] ?? '';
    _lastName.text = widget.userDetails['lastName'] ?? '';
    _email.text = widget.email;
    _residentialAddress.text = widget.userDetails['residentialAddress'] ?? '';
    _permanentAddress.text = widget.userDetails['permanentAddress'] ?? '';
    _phoneNumber.text = widget.userDetails['phoneNumber'] ?? '';
  }

  Future<void> _pickImage(int x) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (x == 2) {
          dpImage = File(pickedFile.path);
        }
        if (x == 1) {
          adhaarImage = File(pickedFile.path);
        }
        if (x == 3) {
          supportImage = File(pickedFile.path);
        }
      });
    }
  }

  void _submitForm() async {
    final firstName = _firstName.text;
    final middleName = _middleName.text;
    final lastName = _lastName.text;
    final email = _email.text;
    final password = _password.text;
    final resAdd = _residentialAddress.text;
    final perAdd = _permanentAddress.text;
    final phoneNo = _phoneNumber.text;

    // Call your update employee service here with the updated details
    // await _employeeService.updateEmployee(...);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Details updated successfully')),
    );
    Navigator.pop(context); // Go back to the previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Personal Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400, // Limit the width for larger screens
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Edit Personal Details',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _firstName,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _middleName,
                        decoration: const InputDecoration(
                          labelText: 'Middle Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _lastName,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _password,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _residentialAddress,
                        decoration: const InputDecoration(
                          labelText: 'Residential Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _permanentAddress,
                        decoration: const InputDecoration(
                          labelText: 'Permanent Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _phoneNumber,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _pickImage(2),
                        child: const Text('Upload DP Image'),
                      ),
                      const SizedBox(height: 10),
                      dpImage == null ? const Text('No image selected.') : Image.file(dpImage!),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _pickImage(1),
                        child: const Text('Upload Aadhaar Image'),
                      ),
                      const SizedBox(height: 10),
                      adhaarImage == null ? const Text('No image selected.') : Image.file(adhaarImage!),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _pickImage(3),
                        child: const Text('Upload Supporting Image'),
                      ),
                      const SizedBox(height: 10),
                      supportImage == null ? const Text('No image selected.') : Image.file(supportImage!),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
