import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ooriba_s3/services/employeeService.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _dob;
  String? _aadharCopyPath;
  final _phoneNumber = TextEditingController();
  final _firstName = TextEditingController();
  final _middleName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _panNo = TextEditingController();
  final _residentialAddress = TextEditingController();
  final _permanentAddress = TextEditingController();
  final _password = TextEditingController();
  File? dpImage;
  final EmployeeService _employeeService = EmployeeService();

  Future<void> _pickImage(bool isProfilePicture) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isProfilePicture) {
          dpImage = File(pickedFile.path);
        } else {
          // _documentation = File(pickedFile.path);
        }
      });
    }
  }

  void _submitForm() async {
    // final dob=_dob;
    final firstName = _firstName.text;
    final middlenName = _middleName.text;
    final lastName = _lastName.text;
    final email = _email.text;
    final password = _password.text;
    final panNo = _panNo.text;
    final resAdd = _residentialAddress.text;
    final perAdd = _permanentAddress.text;
    final phoneNo = _phoneNumber.text;

    String dob = DateFormat.yMd().format(_dob!);
    await _employeeService.addEmployee(firstName, middlenName, lastName, email,
        password, panNo, resAdd, perAdd, phoneNo, dob, dpImage!,
        context: context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Employee added successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _firstName,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _password,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _phoneNumber,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dob = pickedDate;
                            });
                          }
                        },
                        controller: TextEditingController(
                          text: _dob != null
                              ? "${_dob!.day}/${_dob!.month}/${_dob!.year}"
                              : '',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _panNo,
                        decoration: const InputDecoration(
                          labelText: 'Pan Number',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Pan number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _residentialAddress,
                        decoration: const InputDecoration(
                          labelText: 'Residential Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your residential address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _permanentAddress,
                        decoration: const InputDecoration(
                          labelText: 'Permanent Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your permanent address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          // final adhaarimage = await _employeeService.pickImage();
                          // final String? result = await Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => const AadharCopyUploadPage()),
                          // );
                        },
                        child: Text(_aadharCopyPath == null
                            ? 'Upload Aadhar Copy'
                            : 'Aadhar Copy Uploaded'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _pickImage(true),
                        child: Text('Upload Profile Picture'),
                      ),
                      dpImage == null
                          ? Text('No profile picture selected.')
                          : Image.file(dpImage!,
                              height: 100, width: 100),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // () async{
                          // final supportimage = await _employeeService.pickImage();
                          // },
                        },
                        child: const Text('Upload Supporting Document'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Sign Up'),
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

class AadharCopyUploadPage extends StatelessWidget {
  const AadharCopyUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Aadhar Copy'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement Aadhar copy upload functionality
            Navigator.pop(context, 'path_to_aadhar_copy');
          },
          child: const Text('Upload Aadhar Copy'),
        ),
      ),
    );
  }
}
