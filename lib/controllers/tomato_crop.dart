import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techsow/controllers/tomato_imagePreview.dart';

late List<CameraDescription> _cameras;
late CameraController _controller;
late Future<void> _initializeControllerFuture;

class TomatoCropCameraApp extends StatefulWidget {
  
  const TomatoCropCameraApp({Key? key,}) : super(key: key);

  @override
  State<TomatoCropCameraApp> createState() => _TomatoCropModelState();
}

class _TomatoCropModelState extends State<TomatoCropCameraApp> {
  late FlutterVision vision; // Initialize the FlutterVision instance
  File? imageFile;

  @override
  void initState() {
    super.initState();
    vision = FlutterVision(); // Initialize FlutterVision
    _initializeControllerFuture = _initializeCamera(); // Initialize cameras and controller
  }

  
  
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.max);
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() async {
    super.dispose();
    await _controller.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TomatoPreview(imagePath: pickedFile.path, vision: vision, imageFile: imageFile,),
          ),
        );
      }
    } catch (e) {
      print("Error picking image from camera: $e");
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TomatoPreview(imagePath: pickedFile.path, vision: vision, imageFile: imageFile,),
          ),
        );
      }
    } catch (e) {
      print("Error picking image from gallery: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (_controller.value.isInitialized) {
                  return CameraPreview(_controller);
                } else {
                  return Center(child: Text('Failed to initialize camera'));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () async {
                    final newCameraIndex =
                        (_controller.description == _cameras.first)
                            ? 1
                            : 0;
                    _controller = CameraController(_cameras[newCameraIndex], ResolutionPreset.max);
                    await _controller.initialize();
                    setState(() {});
                  },
                  icon: Icon(Icons.switch_camera_rounded, color: Colors.white),
                ),
                GestureDetector(
                  onTap: _pickImageFromCamera,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.black),
                  ),
                ),
                IconButton(
                  onPressed: _pickImageFromGallery,
                  icon: Icon(Icons.image, color: Colors.white),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}