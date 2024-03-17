import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FertilizerCalculatorPage extends StatefulWidget {
  @override
  _FertilizerCalculatorPageState createState() =>
      _FertilizerCalculatorPageState();
}

class _FertilizerCalculatorPageState extends State<FertilizerCalculatorPage> {
  // Define variables for plants, selected plant, NPK values, etc.
  List<String> plants = ["Tomato", "Potato", "Spinach", "Cabbage"];
  String selectedPlant = "Tomato";

  // NPK values (initially zero)
  double nitrogen = 0.0;
  double phosphorus = 0.0;
  double potassium = 0.0;

  bool isEditable = false; // Flag to control input field editability

  String selectedUnit = "Acre"; // Default selected unit

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Threshold NPK values
  late double thresholdNitrogen = 0.0;
  late double thresholdPhosphorus = 0.0;
  late double thresholdPotassium = 0.0;

  @override
  void initState() {
    super.initState();
    fetchThresholdValues();
  }

  // Method to fetch threshold NPK values from Firestore
  Future<void> fetchThresholdValues() async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('crops')
          .doc(selectedPlant.toLowerCase())
          .get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        thresholdNitrogen = data['nitrogen_threshold'];
        thresholdPhosphorus = data['phosphorus_threshold'];
        thresholdPotassium = data['potassium_threshold'];
      });
    } catch (e) {
      print('Error fetching threshold values: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fertilizer Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fertilizer Calculator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'See relevant information on',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedPlant,
                  items: plants
                      .map((plant) => DropdownMenuItem<String>(
                            value: plant,
                            child: Text(plant),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPlant = value!;
                      fetchThresholdValues(); // Fetch threshold values when plant is changed
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nutrient quantities',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: Icon(isEditable ? Icons.edit : Icons.edit_off),
                  onPressed: () {
                    setState(() {
                      isEditable = !isEditable;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextField(
                    enabled: isEditable,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'N',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        nitrogen = double.parse(value);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: TextField(
                    enabled: isEditable,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'P',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        phosphorus = double.parse(value);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: TextField(
                    enabled: isEditable,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'K',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        potassium = double.parse(value);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 19),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Unit',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Radio<String>(
                      value: "Acre",
                      groupValue: selectedUnit,
                      onChanged: (value) =>
                          setState(() => selectedUnit = value!),
                    ),
                    const Text("Acre"),
                    const SizedBox(width: 8),
                    Radio<String>(
                      value: "Hectare",
                      groupValue: selectedUnit,
                      onChanged: (value) =>
                          setState(() => selectedUnit = value!),
                    ),
                    const Text("Hectare"),
                    const SizedBox(width: 8),
                    Radio<String>(
                      value: "Gunta",
                      groupValue: selectedUnit,
                      onChanged: (value) =>
                          setState(() => selectedUnit = value!),
                    ),
                    const Text("Gunta"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Plot size',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Container(
                  width: 120,
                  child: Row(
                    children: [
                      const Flexible(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Size',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: const Center(
                            child: Text(
                              'Unit',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle calculate button press
                  calculateAndDisplay();
                },
                child: const Text('Calculate'),
              ),
            ),
            const SizedBox(height: 16),
            // Display calculated NPK values
            Text(
              'Required adjustments:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nitrogen: ${calculateAdjustment(nitrogen, thresholdNitrogen)}',
            ),
            Text(
              'Phosphorus: ${calculateAdjustment(phosphorus, thresholdPhosphorus)}',
            ),
            Text(
              'Potassium: ${calculateAdjustment(potassium, thresholdPotassium)}',
            ),
          ],
        ),
      ),
    );
  }

  void calculateAndDisplay() {
    // Calculate the adjustment needed for nitrogen
    String nitrogenAdjustment =
        calculateAdjustment(nitrogen, thresholdNitrogen);

    // Calculate the adjustment needed for phosphorus
    String phosphorusAdjustment =
        calculateAdjustment(phosphorus, thresholdPhosphorus);

    // Calculate the adjustment needed for potassium
    String potassiumAdjustment =
        calculateAdjustment(potassium, thresholdPotassium);

    // Show the adjustments in a dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adjustments'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nitrogen: $nitrogenAdjustment'),
              Text('Phosphorus: $phosphorusAdjustment'),
              Text('Potassium: $potassiumAdjustment'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Method to calculate adjustment needed
  String calculateAdjustment(double userValue, double thresholdValue) {
    if (userValue > thresholdValue) {
      return 'Reduce by ${userValue - thresholdValue}';
    } else if (userValue < thresholdValue) {
      return 'Add ${thresholdValue - userValue}';
    } else {
      return 'No adjustment needed';
    }
  }
}
