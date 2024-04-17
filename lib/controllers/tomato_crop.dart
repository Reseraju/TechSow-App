// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// // import 'package:flutter_tflite/flutter_tflite.dart';
// import 'package:image_picker/image_picker.dart';

// class CameraScreen extends StatefulWidget {
//   final String cropName;
//   final List<CameraDescription> cameras;
//   const CameraScreen({Key? key, required this.cameras, required this.cropName})
//       : super(key: key);

//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;
//   Future<void>? _initializeControllerFuture;
//   List<File> capturedImages = [];

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     Tflite.close(); // Dispose TFLite instances
//     super.dispose();
//   }

//   void _initializeCamera([CameraDescription? newCamera]) async {
//     _controller = CameraController(
//         newCamera ?? widget.cameras.first, ResolutionPreset.medium);
//     _initializeControllerFuture = _controller.initialize().then((_) {
//       if (mounted) {
//         setState(() {});
//       }
//     }).catchError((error) {
//       print('Error initializing camera: $error');
//     });
//   }

//   Future<void> _pickImageFromCamera() async {
//     await _initializeControllerFuture;
//     final xFile = await _controller.takePicture();
//     _runModels(File(xFile.path));
//   }

//   Future<void> _pickImageFromGallery() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedImage != null) {
//       _runModels(File(pickedImage.path));
//     }
//   }

//   Future<void> _runModels(File imageFile) async {
//     if (widget.cropName == 'tomato') {
//       await _runNoLeafTomatoModel(imageFile);
//       // await _runTomatoModel(imageFile);
//     } else {
//       print('Unknown crop name: ${widget.cropName}');
//     }
//   }

//   Future<void> _runNoLeafTomatoModel(File imageFile) async {
//     await Tflite.loadModel(
//       model: "assets/model/noLeafModel.tflite",
//       labels: "assets/model/noLeafLabels.txt",
//       isAsset: true,
//       numThreads: 1,
//       useGpuDelegate: false,
//     );

//     final output = await Tflite.runModelOnImage(
//       path: imageFile.path,
//       numResults: 1,
//       threshold: 0.5,
//       imageMean: 127.5,
//       imageStd: 127.5,
//     );

//     if (output != null && output.isNotEmpty) {
//       if (output[0]['label'] == 'Not a leaf') {
//         _showNotLeafResultScreen();
//       } else {
//         await _runTomatoModel(imageFile);
//       }
//     }
//   }

//   void _showNotLeafResultScreen() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: 400,
//           width: 400,
//           color: Colors.black,
//           padding: const EdgeInsets.all(20),
//           child: const Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'This is not a leaf!',
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _runTomatoModel(File imageFile) async {
//     await Tflite.loadModel(
//       model: "assets/model/tomato_model_teachable.tflite",
//       labels: "assets/model/tomato_labels_teachable.txt",
//       isAsset: true,
//       numThreads: 1,
//       useGpuDelegate: false,
//     );

//     final output = await Tflite.runModelOnImage(
//       path: imageFile.path,
//       numResults: 10,
//       threshold: 0.5,
//       imageMean: 127.5,
//       imageStd: 127.5,
//     );

//     if (output != null && output.isNotEmpty) {
//       _showTomatoResultScreen(output[0]['label']);
//     }
//   }

//   void _showTomatoResultScreen(String result) {
//     List<String> symptoms = _getSymptomsForTomatoDisease(result);

//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: 400,
//           width: 400,
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Disease: $result',
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Symptoms:',
//                 style: TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: symptoms.map((symptom) {
//                   return Text(
//                     '- $symptom',
//                     style: const TextStyle(fontSize: 14),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // Handle Learn More button action
//                 },
//                 child: const Text('Learn More'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   List<String> _getSymptomsForTomatoDisease(String disease) {
//     switch (disease) {
//       case 'Tomato Early Blight':
//         return [
//           'Irregular brown spots on leaves',
//           'Yellowing of lower leaves',
//           'Dark lesions on stems'
//         ];
//       case 'Tomato Late Blight':
//         return [
//           'Dark, water-soaked spots on leaves',
//           'White mold on underside of leaves',
//           'Rapid leaf yellowing and wilting'
//         ];
//       case 'Tomato Leaf Mold':
//         return [
//           'Yellow patches on upper leaf surfaces',
//           'Fuzzy white or gray mold on underside of leaves',
//           'Reduced fruit yield'
//         ];
//       default:
//         return [];
//     }
//   }

//   List<String> _getSymptomsForPotatoDisease(String disease) {
//     switch (disease) {
//       case 'Potato___Early_blight':
//         return [
//           'Small, brown spots on leaves',
//           'Yellowing of leaves',
//           'Dark lesions on stems'
//         ];
//       case 'Potato___Late_blight':
//         return [
//           'Dark, water-soaked spots on leaves',
//           'White mold on underside of leaves',
//           'Rapid leaf yellowing and wilting'
//         ];
//       case 'Potato___healthy':
//         return ['No visible symptoms'];
//       default:
//         return [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Column(
//         children: [
//           FutureBuilder<void>(
//             future: _initializeControllerFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 if (_controller.value.isInitialized) {
//                   return CameraPreview(_controller);
//                 } else {
//                   return Center(child: Text('Failed to initialize camera'));
//                 }
//               } else {
//                 return const Center(child: CircularProgressIndicator());
//               }
//             },
//           ),
//           const Spacer(),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     final newCameraIndex =
//                         (_controller.description == widget.cameras.first)
//                             ? 1
//                             : 0;
//                     final newCamera = widget.cameras[newCameraIndex];
//                     _initializeCamera(newCamera);
//                   },
//                   icon: Icon(Icons.switch_camera_rounded, color: Colors.white),
//                 ),
//                 GestureDetector(
//                   onTap: _pickImageFromCamera,
//                   child: Container(
//                     height: 60,
//                     width: 60,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: _pickImageFromGallery,
//                   icon: Icon(Icons.image, color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//           const Spacer(),
//         ],
//       ),
//     );
//   }
// }
