// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_ml_vision/google_ml_vision.dart';

// class UtilScanner{
//   UtilScanner._();
//   static Future<CameraDescription> getCamera(CameraLensDirection CameraLensDirection)async{
//     return await availableCameras().then(
//       (List<CameraDescription> cameras)=>cameras.firstWhere(
//         (CameraDescription cameraDescription)=> cameraDescription.lensDirection==CameraLensDirection)
//       );
//   }
//   static ImageRotation rotationIntToImageRotation(int rotation){
//     switch(rotation){
//       case 0:
//       return ImageRotation.rotation0;
//       case 90:
//       return ImageRotation.rotation90;
//       case 180:
//       return ImageRotation.rotation180;
//       default:
//       assert(rotation==270);
//       return ImageRotation.rotation270;

//     }
//   }
//   static Uint8List concatenatePlanes(List<Plane>planes){
//     final WriteBuffer allBytes=WriteBuffer();

//     for (Plane plane in planes){
//       allBytes.putUint8List(plane.bytes);
//     }
//     return allBytes.done().buffer.asUint8List();
//   }
//   static GoogleVisionImageMetadata buildMetaData(CameraImage image,ImageRotation rotation){
//     return GoogleVisionImageMetadata(
//       size:Size(image.width.toDouble(),image.height.toDouble()),
//       rotation: rotation,
//     rawFormat: image.format.raw,
//     planeData: image.planes.map((Plane plane)
//     {
//       return GoogleVisionImagePlaneMetadata(
//         bytesPerRow:plane.bytesPerRow,
//         height:plane.height,
//         width:plane.width,
//       );
//     }).toList(),
//   );
//   }
//   static Future<dynamic> detect({
//     required CameraImage image,required, required Future<dynamic>Function(GoogleVisionImage Image)detectInImage, required int ImageRotation,}) async
//     {
//       return detectInImage(
//         GoogleVisionImage.fromBytes(
//           concatenatePlanes(image.planes),
//           buildMetaData(image, rotationIntToImageRotation(ImageRotation)
//            )
//           )
//         );
//       }
      
//     }

