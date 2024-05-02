import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';

class TomatoPreview extends StatefulWidget {
  final String imagePath;
  final FlutterVision vision;
  final imageFile;

  const TomatoPreview(
      {Key? key,
      required this.imageFile,
      required this.vision,
      required this.imagePath})
      : super(key: key);

  @override
  State<TomatoPreview> createState() => _TomatoPreviewState();
}

class _TomatoPreviewState extends State<TomatoPreview> {
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
        labels: 'assets/model/tomato_yolo_labels.txt',
        modelPath: 'assets/model/tomatoYoloModel.tflite',
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
    List<String> symptoms = _getSymptomsForTomatoDisease(disease);
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
  void dispose() async {
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
      appBar: AppBar(title: const Text('Image Preview')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.imageFile != null
              ? Image.file(widget.imageFile!)
              : const SizedBox(),
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

  List<String> _getSymptomsForTomatoDisease(String disease) {
    switch (disease) {
      case 'Bacterial spot':
        return [
          'On leaves, the initial symptom appears as small, round, water-soaked spots that gradually turn dark-brown or black and are surrounded by yellow halo',
          'The center of the leaf spots often falls out resulting in small holes.'
        ];
      case 'Tomato two spotted spider mites leaf':
        return [
          'Pale greenish-yellow spots, usually less than 1/4 inch, with no definite margins, form on the upper sides of leaves. Olive-green to brown velvety mold forms on the lower leaf surface below leaf spots. Leaf spots grow together and turn brown.'
        ];
      case 'Mosaic virus':
        return [
          'The fruit may be distorted, yellow blotches and necrotic spots may occur on both ripe and green fruit and there may be internal browning of the fruit wall. In young plants, the infection reduces the set of fruit and may cause distortions and blemishes. The entire plant may be dwarfed and the flowers discoloured.'
        ];
      case 'Septoria leaf spot':
        return [
          'The first symptoms appear as small, water-soaked, circular spots 1/16 to 1/8" in diameter on the undersides of older leaves. The centers of these spots then turn gray to tan and have a dark-brown margin. The spots are distinctively circular and are often quite numerous.'
        ];
      case 'Yellow virus':
        return [
          'Plants are stunted or dwarfed.',
          'New growth only produced after infection is reduced in size.',
          'Leaflets are rolled upwards and inwards.',
          'Leaves are often bent downwards, stiff, thicker than normal, have a leathery texture, show interveinal chlorosis and arekled.'
        ];
      case 'Mold leaf':
        return [
          'Yellow patches on upper leaf surfaces',
          'Fuzzy white or gray mold on underside of leaves',
          'Reduced fruit yield'
        ];
      case 'Early blight':
        return [
          'Plants infected with early blight develop small black or brown spots, usually about 0.25 to 0.5 inch (6–12 mm) in diameter, on leaves, stems, and fruit. Leaf spots are leathery and often have a concentric ring pattern. They usually appear on older leaves first.'
        ];
      case 'Late blight':
        return [
          'Leaf symptoms of late blight first appear as small, water-soaked areas that rapidly enlarge to form purple-brown, oily-appearing blotches. On the lower side of leaves, rings of grayish white mycelium and spore-forming structures may appear around the blotches.'
        ];
      default:
        return [];
    }
  }
}
