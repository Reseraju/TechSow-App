import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:techsow/controllers/camera_screen.dart';

class ChooseCrop extends StatefulWidget {
  final List<CameraDescription> cameras;

  const ChooseCrop({Key? key, required this.cameras}) : super(key: key);

  @override
  State<ChooseCrop> createState() => _ChooseCropState();
}

class _ChooseCropState extends State<ChooseCrop> {
  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  initializeCamera() async {
    cameras = await availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Crop'),
        iconTheme: const IconThemeData(color: Colors.black),
        // backgroundColor: Colors.transparent,
        backgroundColor: Color.fromARGB(255, 165, 182, 143),
        elevation: 3,
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Select A Crop to detect disease',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    navigateToCameraScreen(context, 'tomato');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 198, 183, 182), // Change the background color here
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/tomato_icon.png', // Add the path to your tomato image asset
                        height: 80,
                        width: 80,
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      const Text(
                        'Tomato',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    navigateToCameraScreen(context, 'potato');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 198, 183, 182), // Change the background color here
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/potato_icon.png', // Add the path to your potato image asset
                        height: 80,
                        width: 80,
                      ),
                      const SizedBox(width: 30),
                      const Text(
                        'Potato',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void navigateToCameraScreen(BuildContext context, String cropName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CameraScreen(
            cameras: cameras,
            cropName: cropName,
          );
        },
      ),
    );
  }
}
