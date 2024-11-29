// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class CameraPage extends StatefulWidget {
//   const CameraPage({super.key});
//
//   @override
//   _CameraPageState createState() => _CameraPageState();
// }
//
// class _CameraPageState extends State<CameraPage> {
//   XFile? _image; // Holds the captured image
//   final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker
//
//   // Function to open the camera
//   Future<void> _openCamera() async {
//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//       if (image != null) {
//         setState(() {
//           _image = image;
//         });
//       }
//     } catch (e) {
//       print('Error opening camera: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Camera Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _image != null
//                 ? Image.file(
//               File(_image!.path),
//               width: 300,
//               height: 300,
//               fit: BoxFit.cover,
//             )
//                 : const Text(
//               'No image captured yet.',
//               style: TextStyle(fontSize: 16.0),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _openCamera,
//               child: const Text('Open Camera'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
