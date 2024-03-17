import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:techsow/screens/choose_crop.dart';
import 'package:techsow/screens/fertilizer_calculator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //WeatherFactory wf = new WeatherFactory("WEATHER_API_KEY");

  int index = 0;

  late List<CameraDescription> cameras;

  String selectedCrop = 'Tomato'; // Default selected crop
  final Map<String, String> cropSuggestions = {
    'Tomato': 'Here are some suggestions for your tomato crop...',
    'Potato': 'Here are some suggestions for your Potato crop...',
    // Add more crop suggestions here
  };

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  initializeCamera() async {
    cameras = await availableCameras();
  }

  void navigateToChooseCropScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ChooseCrop(cameras: cameras); // Pass cameras to CameraScreen
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: const Text('Techsow'),
        iconTheme: const IconThemeData(color: Colors.black),
        // backgroundColor: Colors.transparent,
        backgroundColor: Color.fromARGB(255, 165, 182, 143),
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,

      //body
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Select Crop',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCropSelectionButton(
                        'assets/images/tomato.jpg', 'Tomato'),
                    _buildCropSelectionButton(
                        'assets/images/cassava.jpg', 'Potato'),
                    // Add more crop selection buttons here
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Heal Your Crop',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (selectedCrop ==
                        'Tomato') // Display text for tomato crop
                      const Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'Avoid overhead watering by using drip or furrow irrigation. Remove and dispose of all diseased plant material. Prune plants to promote air circulation. Spraying with a copper fungicide will give fairly good control of the bacterial disease.',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    if (selectedCrop ==
                        'Potato') // Display text for potato crop
                      const Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'Keep the soil moist but not soggy. Don\'t plant potatoes and tomatoes near each other -- they are affected by the same diseases. Remove infected or diseased plants from the garden. Remove potato debris from the garden after harvest.',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    // Add a default case if needed
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  color: Colors.green.withOpacity(0.3),
                  padding: const EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width - 32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("clicked");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FertilizerCalculatorPage(),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset('assets/images/fertilizer_count.png',
                                width: 80, height: 80),
                            const SizedBox(height: 20),
                            const Text(
                              'Calculate Fertilizer Count',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      GestureDetector(
                        onTap: () {
                          print("clicked another");
                        },
                        child: Column(
                          children: [
                            Image.asset('assets/images/cultivation_tips.jpeg',
                                width: 80, height: 80),
                            const SizedBox(height: 20),
                            const Text(
                              'Cultivation Tips',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  // Handle take picture button tap
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/scanCrop.png',
                        width: 400,
                        height: 115,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 200, // Adjust width as needed
                        height: 53,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle take picture button press
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChooseCrop(
                                      cameras:
                                          cameras); // Pass cameras to ChooseCrop
                                },
                              ),
                            );
                          },
                          child: const Text('Take Picture'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
      // add a container

      // Bottom Navbar
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: _getBackgroundColor(11),
        backgroundColor: Color.fromARGB(255, 165, 182, 143),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.scanner_sharp),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon:
                Image.asset('assets/images/remote.jpg', width: 32, height: 32),
            label: 'Rover',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        showUnselectedLabels: true,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
            if (index == 1) {
              navigateToChooseCropScreen();
            }
            if (index == 2) {
              // Navigate to the IoT app development page
              Navigator.pushNamed(context, '/rover');
            }
            if (index == 3) {
              Navigator.pushNamed(
                context,
                '/profile',
              );
            }
          });
        },
      ),
    );
  }

  // Helper functions for color and icon
  Color _getBackgroundColor(double temperature) {
    if (temperature >= 30.0) {
      return Colors.orangeAccent;
    } else if (temperature >= 20.0) {
      return Colors.yellowAccent;
    } else if (temperature >= 10.0) {
      return Color.fromARGB(255, 165, 182, 143);
    } else {
      return Colors.blueAccent;
    }
  }

  Widget _buildCropSelectionButton(String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCrop = label;
        });
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
        ),
        child: CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(imagePath),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
