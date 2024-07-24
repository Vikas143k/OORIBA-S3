import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:ooriba_s3/facial/ML/Recognition.dart';
import 'package:ooriba_s3/facial/ML/Recognizer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:ooriba_s3/services/auth_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, required String siteManagerId});

  @override
  State<RegistrationScreen> createState() => _HomePageState();
}

class _HomePageState extends State<RegistrationScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late ImagePicker imagePicker;
  File? _image;
  late FaceDetector faceDetector;
  late Recognizer recognizer;
  List<Face> faces = [];
  var image;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();

    final options = FaceDetectorOptions();
    faceDetector = FaceDetector(options: options);
    recognizer = Recognizer();
     fetchApprovedEmployees();
  }

  Future<void> fetchApprovedEmployees() async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('SiteManagerAuth')
          .where('status', isEqualTo: 'approved')
          .where('set',isEqualTo: '1')
          .get();

      for (var doc in querySnapshot.docs) {
        String employeeId = doc.id;
        String imageUrl = doc['imageUrl'];
        await processEmployeeImage(employeeId, imageUrl);
      }
    } catch (e) {
      print('Failed to fetch approved employees: $e');
    }
  }

     Future<void> processEmployeeImage(String employeeId, String imageUrl, ) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$employeeId.jpg');
      final response = await http.get(Uri.parse(imageUrl));
      await tempFile.writeAsBytes(response.bodyBytes);

      _image = tempFile;
      await doFaceDetection2(employeeId);
       await _db.collection('SiteManagerAuth').doc(employeeId).update({
      'set':'0'
    });
    } catch (e) {
      print('Failed to process employee image: $e');
    }
  }
  Future<void> uploadEmployeeImage(String employeeId, File image) async {
    try {
      // Define the storage reference
      Reference storageRef = _storage
          .ref()
          .child('siteManagerAuth')
          .child(employeeId)
          .child('$employeeId.jpg');

      // Upload the image file to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(image);
      await uploadTask.whenComplete(() => null);

      // Get the download URL of the uploaded image
      String downloadURL = await storageRef.getDownloadURL();

      // Save the download URL in Firestore under the SiteManagerAuth collection
      DocumentReference docRef = _db.collection('SiteManagerAuth').doc(employeeId);

      // Check if the document exists, if not, create it
      DocumentSnapshot docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        await docRef.set({
          'imageUrl': downloadURL,
          'status':'requested',
          'set':'0'
        });
      } else {
        await docRef.update({
          'imageUrl': downloadURL,
          'status':'requested',
          'set':'0'
        });
      }

      print('Image uploaded successfully and URL saved in Firestore.');
    } catch (e) {
      print('Failed to upload image: $e');
    }
  }

  Future<void> _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  Future<void> _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  Future<void> doFaceDetection() async {
    if (_image != null) {
      _image = await removeRotation(_image!);

      final bytes = await _image?.readAsBytes();
      image = await decodeImageFromList(bytes!);

      InputImage inputImage = InputImage.fromFile(_image!);
      faces = await faceDetector.processImage(inputImage);

      for (Face face in faces) {
        Rect faceRect = face.boundingBox;
        num left = faceRect.left < 0 ? 0 : faceRect.left;
        num top = faceRect.top < 0 ? 0 : faceRect.top;
        num right = faceRect.right > image.width ? image.width - 1 : faceRect.right;
        num bottom = faceRect.bottom > image.height ? image.height - 1 : faceRect.bottom;
        num width = right - left;
        num height = bottom - top;

        final faceImg = img.decodeImage(bytes);
        final faceImg2 = img.copyCrop(
          faceImg!,
          x: left.toInt(),
          y: top.toInt(),
          width: width.toInt(),
          height: height.toInt(),
        );

        Recognition recognition = recognizer.recognize(faceImg2, faceRect);
        showFaceRegistrationDialogue(Uint8List.fromList(img.encodeBmp(faceImg2)), recognition);
      }

      drawRectangleAroundFaces();
    }
  }
  //   Future<void> doFaceDetection2(employeeId) async {
  //   if (_image != null) {
  //     _image = await removeRotation(_image!);

  //     final bytes = await _image?.readAsBytes();
  //     image = await decodeImageFromList(bytes!);

  //     InputImage inputImage = InputImage.fromFile(_image!);
  //     faces = await faceDetector.processImage(inputImage);

  //     for (Face face in faces) {
  //       Rect faceRect = face.boundingBox;
  //       num left = faceRect.left < 0 ? 0 : faceRect.left;
  //       num top = faceRect.top < 0 ? 0 : faceRect.top;
  //       num right = faceRect.right > image.width ? image.width - 1 : faceRect.right;
  //       num bottom = faceRect.bottom > image.height ? image.height - 1 : faceRect.bottom;
  //       num width = right - left;
  //       num height = bottom - top;

  //       final faceImg = img.decodeImage(bytes);
  //       final faceImg2 = img.copyCrop(
  //         faceImg!,
  //         x: left.toInt(),
  //         y: top.toInt(),
  //         width: width.toInt(),
  //         height: height.toInt(),
  //       );

  //       Recognition recognition = recognizer.recognize(faceImg2, faceRect);
  //       showFaceRegistrationDialogue(Uint8List.fromList(img.encodeBmp(faceImg2)), recognition);
  //     recognizer.registerFaceInDB(employeeId, recognition.embeddings);

  //     }

  //     drawRectangleAroundFaces();
  //   }
  // }
   Future<void> doFaceDetection2(String employeeId) async {
    if (_image != null) {
      _image = await removeRotation(_image!);

      final bytes = await _image?.readAsBytes();
      image = await decodeImageFromList(bytes!);

      InputImage inputImage = InputImage.fromFile(_image!);
      faces = await faceDetector.processImage(inputImage);

      for (Face face in faces) {
        Rect faceRect = face.boundingBox;
        num left = faceRect.left < 0 ? 0 : faceRect.left;
        num top = faceRect.top < 0 ? 0 : faceRect.top;
        num right = faceRect.right > image.width ? image.width - 1 : faceRect.right;
        num bottom = faceRect.bottom > image.height ? image.height - 1 : faceRect.bottom;
        num width = right - left;
        num height = bottom - top;

        final faceImg = img.decodeImage(bytes);
        final faceImg2 = img.copyCrop(
          faceImg!,
          x: left.toInt(),
          y: top.toInt(),
          width: width.toInt(),
          height: height.toInt(),
        );

        Recognition recognition = recognizer.recognize(faceImg2, faceRect);
        recognizer.registerFaceInDB(employeeId, recognition.embeddings);
      }

      drawRectangleAroundFaces();
    }
  }

  Future<File> removeRotation(File inputImage) async {
    final capturedImage = img.decodeImage(await inputImage.readAsBytes());
    final orientedImage = img.bakeOrientation(capturedImage!);
    final rotatedImagePath = inputImage.path;
    await File(rotatedImagePath).writeAsBytes(img.encodeJpg(orientedImage));
    return File(rotatedImagePath);
  }

  TextEditingController textEditingController = TextEditingController();

  void showFaceRegistrationDialogue(Uint8List croppedFace, Recognition recognition) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Face Registration", textAlign: TextAlign.center),
        alignment: Alignment.center,
        content: SizedBox(
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.memory(
                croppedFace,
                width: 200,
                height: 200,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(fillColor: Colors.white, filled: true, hintText: "Enter Employee ID"),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                        uploadEmployeeImage(textEditingController.text,_image!);
                  // recognizer.registerFaceInDB(textEditingController.text, recognition.embeddings);
                  textEditingController.text = "";
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Face Registered"),
                  ));
                  // await AuthService().signout(context: context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: const Size(200, 40)),
                child: const Text("Register"),
              ),
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Future<void> drawRectangleAroundFaces() async {
    final bytes = await _image?.readAsBytes();
    image = await decodeImageFromList(bytes!);
    setState(() {
      image;
      faces;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          image != null
              ? Container(
                  margin: const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 0),
                  child: FittedBox(
                    child: SizedBox(
                      width: image.width.toDouble(),
                      height: image.width.toDouble(),
                      child: CustomPaint(
                        painter: FacePainter(facesList: faces, imageFile: image),
                      ),
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: screenWidth - 100,
                    height: screenWidth - 100,
                  ),
                ),
          Container(height: 50),
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(200))),
                  child: InkWell(
                    onTap: _imgFromGallery,
                    child: SizedBox(
                      width: screenWidth / 2 - 70,
                      height: screenWidth / 2 - 70,
                      child: Icon(Icons.image, color: Colors.blue, size: screenWidth / 7),
                    ),
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(200))),
                  child: InkWell(
                    onTap: _imgFromCamera,
                    child: SizedBox(
                      width: screenWidth / 2 - 70,
                      height: screenWidth / 2 - 70,
                      child: Icon(Icons.camera, color: Colors.blue, size: screenWidth / 7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  List<Face> facesList;
  dynamic imageFile;
  FacePainter({required this.facesList, required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 3;

    for (Face face in facesList) {
      canvas.drawRect(face.boundingBox, p);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// import 'dart:io';
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:ooriba_s3/facial/ML/Recognition.dart';
// import 'package:ooriba_s3/facial/ML/Recognizer.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'package:ooriba_s3/services/auth_service.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;

// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({super.key, required String siteManagerId});

//   @override
//   State<RegistrationScreen> createState() => _HomePageState();
// }

// class _HomePageState extends State<RegistrationScreen> {
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   late ImagePicker imagePicker;
//   File? _image;
//   late FaceDetector faceDetector;
//   late Recognizer recognizer;
//   List<Face> faces = [];
//   var image;

//   @override
//   void initState() {
//     super.initState();
//     imagePicker = ImagePicker();

//     final options = FaceDetectorOptions();
//     faceDetector = FaceDetector(options: options);
//     recognizer = Recognizer();

//     fetchApprovedEmployees();
//   }

//   Future<void> fetchApprovedEmployees() async {
//     try {
//       QuerySnapshot querySnapshot = await _db
//           .collection('SiteManagerAuth')
//           .where('status', isEqualTo: 'approved')
//           .where('set',isEqualTo: '0')
//           .get();

//       for (var doc in querySnapshot.docs) {
//         String employeeId = doc.id;
//         String imageUrl = doc['imageUrl'];
//         await processEmployeeImage(employeeId, imageUrl);
//       }
//     } catch (e) {
//       print('Failed to fetch approved employees: $e');
//     }
//   }

//   Future<void> processEmployeeImage(String employeeId, String imageUrl) async {
//     try {
//       final tempDir = await getTemporaryDirectory();
//       final tempFile = File('${tempDir.path}/$employeeId.jpg');
//       final response = await http.get(Uri.parse(imageUrl));
//       await tempFile.writeAsBytes(response.bodyBytes);

//       _image = tempFile;
//       await doFaceDetection(employeeId);
//        await _db.collection('SiteManagerAuth').doc(employeeId).update({
//       'set':'1'
//     });
//     } catch (e) {
//       print('Failed to process employee image: $e');
//     }
//   }

//   Future<void> doFaceDetection(String employeeId) async {
//     if (_image != null) {
//       _image = await removeRotation(_image!);

//       final bytes = await _image?.readAsBytes();
//       image = await decodeImageFromList(bytes!);

//       InputImage inputImage = InputImage.fromFile(_image!);
//       faces = await faceDetector.processImage(inputImage);

//       for (Face face in faces) {
//         Rect faceRect = face.boundingBox;
//         num left = faceRect.left < 0 ? 0 : faceRect.left;
//         num top = faceRect.top < 0 ? 0 : faceRect.top;
//         num right = faceRect.right > image.width ? image.width - 1 : faceRect.right;
//         num bottom = faceRect.bottom > image.height ? image.height - 1 : faceRect.bottom;
//         num width = right - left;
//         num height = bottom - top;

//         final faceImg = img.decodeImage(bytes);
//         final faceImg2 = img.copyCrop(
//           faceImg!,
//           x: left.toInt(),
//           y: top.toInt(),
//           width: width.toInt(),
//           height: height.toInt(),
//         );

//         Recognition recognition = recognizer.recognize(faceImg2, faceRect);
//         recognizer.registerFaceInDB(employeeId, recognition.embeddings);
//       }

//       drawRectangleAroundFaces();
//     }
//   }

//   Future<void> uploadEmployeeImage(String employeeId, File image) async {
//     try {
//       // Define the storage reference
//       Reference storageRef = _storage
//           .ref()
//           .child('siteManagerAuth')
//           .child(employeeId)
//           .child('$employeeId.jpg');

//       // Upload the image file to Firebase Storage
//       UploadTask uploadTask = storageRef.putFile(image);
//       await uploadTask.whenComplete(() => null);

//       // Get the download URL of the uploaded image
//       String downloadURL = await storageRef.getDownloadURL();

//       // Save the download URL in Firestore under the SiteManagerAuth collection
//       DocumentReference docRef = _db.collection('SiteManagerAuth').doc(employeeId);

//       // Check if the document exists, if not, create it
//       DocumentSnapshot docSnapshot = await docRef.get();
//       if (!docSnapshot.exists) {
//         await docRef.set({
//           'imageUrl': downloadURL,
//           'status': 'requested'
//         });
//       } else {
//         await docRef.update({
//           'imageUrl': downloadURL,
//           'status': 'requested'
//         });
//       }

//       print('Image uploaded successfully and URL saved in Firestore.');
//     } catch (e) {
//       print('Failed to upload image: $e');
//     }
//   }

//   Future<void> _imgFromCamera() async {
//     XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         doFaceDetection(textEditingController.text);
//       });
//     }
//   }

//   Future<void> _imgFromGallery() async {
//     XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         doFaceDetection(textEditingController.text);
//       });
//     }
//   }

//   Future<File> removeRotation(File inputImage) async {
//     final capturedImage = img.decodeImage(await inputImage.readAsBytes());
//     final orientedImage = img.bakeOrientation(capturedImage!);
//     final rotatedImagePath = inputImage.path;
//     await File(rotatedImagePath).writeAsBytes(img.encodeJpg(orientedImage));
//     return File(rotatedImagePath);
//   }

//   TextEditingController textEditingController = TextEditingController();

//   void showFaceRegistrationDialogue(Uint8List croppedFace, Recognition recognition) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Face Registration", textAlign: TextAlign.center),
//         alignment: Alignment.center,
//         content: SizedBox(
//           height: 340,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 20),
//               Image.memory(
//                 croppedFace,
//                 width: 200,
//                 height: 200,
//               ),
//               SizedBox(
//                 width: 200,
//                 child: TextField(
//                   controller: textEditingController,
//                   decoration: const InputDecoration(fillColor: Colors.white, filled: true, hintText: "Enter Employee ID"),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () async {
//                   uploadEmployeeImage(textEditingController.text, _image!);
//                   // recognizer.registerFaceInDB(textEditingController.text, recognition.embeddings);
//                   textEditingController.text = "";
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                     content: Text("Face Registered"),
//                   ));
//                   // await AuthService().signout(context: context);
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: const Size(200, 40)),
//                 child: const Text("Register"),
//               ),
//             ],
//           ),
//         ),
//         contentPadding: EdgeInsets.zero,
//       ),
//     );
//   }

//   Future<void> drawRectangleAroundFaces() async {
//     final bytes = await _image?.readAsBytes();
//     image = await decodeImageFromList(bytes!);
//     setState(() {
//       image;
//       faces;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     // ignore: unused_local_variable
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           image != null
//               ? Container(
//                   margin: const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 0),
//                   child: FittedBox(
//                     child: SizedBox(
//                       width: image.width.toDouble(),
//                       height: image.width.toDouble(),
//                       child: CustomPaint(
//                         painter: FacePainter(facesList: faces, imageFile: image),
//                       ),
//                     ),
//                   ),
//                 )
//               : Container(
//                   margin: const EdgeInsets.only(top: 100),
//                   child: Image.asset(
//                     "assets/images/logo.png",
//                     width: screenWidth - 100,
//                     height: screenWidth - 100,
//                   ),
//                 ),
//           Container(height: 50),
//           Container(
//             margin: const EdgeInsets.only(bottom: 50),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Card(
//                   shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(200))),
//                   child: InkWell(
//                     onTap: _imgFromGallery,
//                     child: SizedBox(
//                       width: screenWidth / 2 - 70,
//                       height: screenWidth / 2 - 70,
//                       child: Icon(Icons.image, color: Colors.blue, size: screenWidth / 7),
//                     ),
//                   ),
//                 ),
//                 Card(
//                   shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(200))),
//                   child: InkWell(
//                     onTap: _imgFromCamera,
//                     child: SizedBox(
//                       width: screenWidth / 2 - 70,
//                       height: screenWidth / 2 - 70,
//                       child: Icon(Icons.camera, color: Colors.blue, size: screenWidth / 7),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FacePainter extends CustomPainter {
//   List<Face> facesList;
//   dynamic imageFile;
//   FacePainter({required this.facesList, required this.imageFile});

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (imageFile != null) {
//       canvas.drawImage(imageFile, Offset.zero, Paint());
//     }

//     Paint p = Paint();
//     p.color = Colors.red;
//     p.style = PaintingStyle.stroke;
//     p.strokeWidth = 3;

//     for (Face face in facesList) {
//       canvas.drawRect(face.boundingBox, p);
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }

