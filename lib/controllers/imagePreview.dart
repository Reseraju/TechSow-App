import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String imagePath;
  final FlutterVision vision;
  final imageFile;

  const ImagePreviewScreen(
      {Key? key, required this.imageFile, required this.vision, required this.imagePath})
      : super(key: key);

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  late List<Map<String, dynamic>> yoloResults;
  int imageHeight = 1;
  int imageWidth = 1;
  bool isLoaded = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _initializeYoloModel().then((value) {
      setState(() {
        yoloResults = [];
        isLoaded = true;
      });
    }).catchError((error) {
      setState(() {
        isError = true;
      });
      print('Error loading YOLO model: $error');
    });
  }

  Future<void> _initializeYoloModel() async {
    try {
      await widget.vision.loadYoloModel(
        labels: 'assets/model/yolo_labels.txt',
        modelPath: 'assets/model/yolov5n.tflite',
        modelVersion: "yolov5",
        quantization: false,
        numThreads: 2,
        useGpu: true,
      );
      setState(() {
        isLoaded = true;
      });
    } catch (e) {
      setState(() {
        isError = true;
      });
      print('Error loading YOLO model: $e');
    }
  }

  void _showBottomSheet(String disease) {
    List<String> symptoms = _getSymptomsForPotatoDisease(disease);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: double.infinity,
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Disease: $disease',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                ...symptoms
                    .map((symptom) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '- $symptom',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  void dispose() async{
    super.dispose();
    await widget.vision.closeYoloModel();
  }

  // Future<void> loadYoloModel() async {
  //   await widget.vision.loadYoloModel(
  //       labels: 'assets/model/yolo_labels.txt',
  //       modelPath: 'assets/model/yolov5n.tflite',
  //       modelVersion: "yolov5",
  //       quantization: false,
  //       numThreads: 2,
  //       useGpu: true);
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (isError) {
      return const Scaffold(
        body: Center(
          child: Text("Error loading model"),
        ),
      );
    }
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('Image Preview')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.imageFile != null ? Image.file(widget.imageFile!) : const SizedBox(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: yoloOnImage,
                  child: const Text("Detect"),
                )
              ],
            ),
          ),
          ...displayBoxesAroundRecognizedObjects(size),
        ],
      ),
    );
  }

  Future<void> yoloOnImage() async {
    yoloResults.clear();
    Uint8List byte = await widget.imageFile!.readAsBytes();
    final image = await decodeImageFromList(byte);
    imageHeight = image.height;
    imageWidth = image.width;
    final result = await widget.vision.yoloOnImage(
        bytesList: byte,
        imageHeight: image.height,
        imageWidth: image.width,
        iouThreshold: 0.8,
        confThreshold: 0.4,
        classThreshold: 0.5);
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
      String disease = result.first[
          'tag']; // Assuming the first detected object represents the disease
      _showBottomSheet(disease);
    }
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];

    double factorX = screen.width / (imageWidth);
    double imgRatio = imageWidth / imageHeight;
    double newWidth = imageWidth * factorX;
    double newHeight = newWidth / imgRatio;
    double factorY = newHeight / (imageHeight);

    double pady = (screen.height - newHeight) / 2;

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);
    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY + pady,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }


  List<String> _getSymptomsForPotatoDisease(String disease) {
    switch (disease) {
      case 'Healthy':
        return [
          'Healthy potato leaf!'
        ];
      case 'Early-Blight':
        return [
          'Early blight is primarily a disease of stressed or senescing plants. Symptoms appear first on the oldest foliage. Affected leaves develop circular to angular dark brown lesions 0.12 to 0.16 inch (3–4 mm) in diameter. Concentric rings often form in lesions to produce characteristic target-board effect.'
        ];
      case 'Late-Blight':
        return [
          'The first symptoms of late blight in the field are small, light to dark green, circular to irregular-shaped water-soaked spots (Figure 1). These lesions usually appear first on the lower leaves. Lesions often begin to develop near the leaf tips or edges, where dew is retained the longest.'
        ];
      default:
        return [];
    }
  }
}

