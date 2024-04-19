import 'package:flutter/material.dart';

class FertilizerCalculatorPage extends StatefulWidget {
  @override
  _FertilizerCalculatorPageState createState() =>
      _FertilizerCalculatorPageState();
}

class _FertilizerCalculatorPageState extends State<FertilizerCalculatorPage> {
  // Define variables for plants, selected plant, NPK values, etc.
  List<String> plants = ["Tomato", "Cucumber", "Spinach", "Cabbage"];
  String selectedPlant = "Tomato";

  // NPK values (initially zero)
  double nitrogen = 0.0;
  double phosphorus = 0.0;
  double potassium = 0.0;

  bool isEditable = false; // Flag to control input field editability

  String selectedUnit = "Acre"; // Default selected unit

  // Threshold values for NPK (for Tomato)
  double thresholdNitrogen = 75.0;
  double thresholdPhosphorus = 40.0;
  double thresholdPotassium = 25.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fertilizer Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fertilizer Calculator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'See relevant information on',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 8),
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
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
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
                Expanded(
                  child: TextField(
                    enabled: isEditable,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
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
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    enabled: isEditable,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
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
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    enabled: isEditable,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
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
            SizedBox(height: 19),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Unit',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: "Acre",
                      groupValue: selectedUnit,
                      onChanged: (value) =>
                          setState(() => selectedUnit = value!),
                    ),
                    Text("Acre"),
                    SizedBox(width: 8),
                    Radio<String>(
                      value: "Hectare",
                      groupValue: selectedUnit,
                      onChanged: (value) =>
                          setState(() => selectedUnit = value!),
                    ),
                    Text("Hectare"),
                    SizedBox(width: 8),
                    Radio<String>(
                      value: "Gunta",
                      groupValue: selectedUnit,
                      onChanged: (value) =>
                          setState(() => selectedUnit = value!),
                    ),
                    Text("Gunta"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Plot size',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Container(
                  width: 120,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Size',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: Center(
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
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle calculate button press
                  if ((nitrogen < thresholdNitrogen &&
                          phosphorus < thresholdPhosphorus) ||
                      (nitrogen < thresholdNitrogen &&
                          potassium < thresholdPotassium) ||
                      (phosphorus < thresholdPhosphorus &&
                          potassium < thresholdPotassium) ||
                      (nitrogen < thresholdNitrogen &&
                          phosphorus < thresholdPhosphorus &&
                          potassium < thresholdPotassium)) {
                    // Show modal bottom sheet for applying FYM and other elements
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Apply FYM @ 20 tha⁻¹ along with AMF, Pseudomonas, Trichoderma and Azoto-bacter each @ 5 kg h⁻¹ as basal dose and cultivate cowpea as a catch crop in these fields.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (nitrogen < thresholdNitrogen ||
                      phosphorus < thresholdPhosphorus ||
                      potassium < thresholdPotassium) {
                    // Show modal bottom sheet
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Nutrient Deficiency',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              if (nitrogen < thresholdNitrogen)
                                Text(
                                  'Nitrogen deficiency',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              if (phosphorus < thresholdPhosphorus)
                                Text(
                                  'Phosphorus deficiency',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              if (potassium < thresholdPotassium)
                                Text(
                                  'Potassium deficiency',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              SizedBox(height: 16),
                              Text(
                                'Fertilizers needed:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              if (nitrogen < thresholdNitrogen)
                                Text(
                                  'Use fertilizers containing nitrogen (N). Examples: Urea, NPK, ammonium nitrate. Consult your agricultural advisor to know the best product and dosage for your soil and crop.\n\n'
                                  'Further recommendations:\n\n'
                                  '- It is recommended to do a soil test before the start of the cropping season to optimize your crop production. Best to apply nitrogen in multiple splits throughout the season.\n\n'
                                  'Do not apply if you are close to harvesting time.',
                                ),
                              if (phosphorus < thresholdPhosphorus)
                                Text(
                                  'Use fertilizers containing phosphorus (P).\n\n'
                                  'Examples: Diammonium phosphate (DAP), Single super phosphate (SSP).\n\n'
                                  '- Consult your agricultural advisor to know the best product and dosage for your soil and crop.\n\n'
                                  'Further recommendations:\n\n'
                                  '- It is recommended to do a soil test before the start of the cropping season to optimize your crop production.',
                                ),
                              if (potassium < thresholdPotassium)
                                Text(
                                  'Use fertilizers containing potassium (K).\n\n'
                                  'Examples: muriate of potash (MOP), potassium nitrate (KNO3).\n\n'
                                  '- Consult your agricultural advisor to know the best product and dosage for your soil and crop.\n\n'
                                  'Further recommendations:\n\n'
                                  '- It\'s recommended to do a soil test before the start of the cropping season to optimize your crop production.\n\n'
                                  '- It\'s best to apply fertilizers during field preparation and at flowering.',
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    // Perform calculation or show a different message
                  }
                },
                child: Text('Calculate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
