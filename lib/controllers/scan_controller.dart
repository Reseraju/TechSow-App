// import 'dart:developer';

// import 'package:camera/camera.dart';
// import 'package:flutter_tflite/flutter_tflite.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ScanController extends GetxController {
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     initCamera();
//     initTflite();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     cameraController.dispose();
//     Tflite.close();
//   }

//   late CameraController cameraController;
//   late List<CameraDescription> cameras;

//   var isCameraInitialized = false.obs;
//   var cameraCount = 0;

//   initCamera() async {
//     if (await Permission.camera.request().isGranted) {
//       cameras = await availableCameras();

//       cameraController = CameraController(
//         cameras[0],
//         ResolutionPreset.max,
//       );
//       await cameraController.initialize().then((value) {
//         cameraController.startImageStream((image) {
//           cameraCount++;
//           if (cameraCount % 10 == 0) {
//             cameraCount = 0;
//             objectDetector(image);
//           }
//           update();
//         });
//       });
//       isCameraInitialized(true);
//       update();
//     } else {
//       print("Permission Denied");
//     }
//   }

//   initTflite() async {
//     await Tflite.loadModel(
//         model: "assets/model/model_unquant.tflite",
//         labels: "assets/model/labels.txt",
//         isAsset: true,
//         numThreads: 1,
//         useGpuDelegate: false);
//   }

//   objectDetector(CameraImage image) async {
//     var detector = await Tflite.runModelOnFrame(
//       bytesList: image.planes.map((e) {
//         return e.bytes;
//       }).toList(),
//       asynch: true,
//       imageHeight: image.height,
//       imageWidth: image.width,
//       imageMean: 127.5,
//       imageStd: 127.5,
//       numResults: 1,
//       rotation: 90,
//       threshold: 0.4,
//     );

//     if (detector != null) {
//       log("Result is $detector");
//     }
//   }
// }