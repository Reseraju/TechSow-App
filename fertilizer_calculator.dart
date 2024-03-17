import 'package:flutter/material.dart';

class FertilizerCalculatorPage extends StatefulWidget {
  @override
  _FertilizerCalculatorPageState createState() => _FertilizerCalculatorPageState();
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
                  items: plants.map((plant) => DropdownMenuItem<String>(
                    value: plant,
                    child: Text(plant),
                  )).toList(),
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
                Flexible(
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
                Flexible(
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
                Flexible(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Radio<String>(
                      value: "Acre",
                      groupValue: selectedUnit,
                      onChanged: (value) => setState(() => selectedUnit = value!),
                    ),
                    Text("Acre"),
                    SizedBox(width: 8),
                    Radio<String>(
                      value: "Hectare",
                      groupValue: selectedUnit,
                      onChanged: (value) => setState(() => selectedUnit = value!),
                    ),
                    Text("Hectare"),
                    SizedBox(width: 8),
                    Radio<String>(
                      value: "Gunta",
                      groupValue: selectedUnit,
                      onChanged: (value) => setState(() => selectedUnit = value!),
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
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Size',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Flexible(
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
