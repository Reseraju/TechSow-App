import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class NPKPage extends StatefulWidget {
  @override
  _NPKPageState createState() => _NPKPageState();
}

class _NPKPageState extends State<NPKPage> {
  late DatabaseReference _databaseReference;
  Map<String, dynamic> _npkValues = {};
  String? _selectedCrop;
  String _nitrogenStatus = '';
  String _phosphorusStatus = '';
  String _potassiumStatus = '';
  String _fertilizer = '';

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    FirebaseApp app = await Firebase.initializeApp();
    _databaseReference = FirebaseDatabase.instanceFor(
      app: app,
      databaseURL:
          'https://techsow-5d67d.asia-southeast1.firebasedatabase.app/',
    ).ref().child('NPK');

    _fetchNPKValues();
  }

  void _fetchNPKValues() {
    _databaseReference.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        setState(() {
          _npkValues = Map<String, dynamic>.from(event.snapshot.value as Map);
        });
      }
    }).catchError((error) {
      print('Error fetching NPK values: $error');
    });
  }

  void _calculateDeficiencies() {
    if (_selectedCrop == 'Tomato') {
      // Ideal NPK values for tomato: N (30-60), P (30-90), K (60-150)
      if (_npkValues['nitrogen']! < 30) {
        _nitrogenStatus = 'Deficient';
      } else {
        _nitrogenStatus = 'Sufficient';
      }

      if (_npkValues['phosphorus']! < 30) {
        _phosphorusStatus = 'Deficient';
      } else {
        _phosphorusStatus = 'Sufficient';
      }

      if (_npkValues['potassium']! < 60) {
        _potassiumStatus = 'Deficient';
      } else {
        _potassiumStatus = 'Sufficient';
      }

      // Provide fertilizer recommendation
      if (_nitrogenStatus == 'Deficient' ||
          _phosphorusStatus == 'Deficient' ||
          _potassiumStatus == 'Deficient') {
        _fertilizer = 'Apply a balanced NPK fertilizer (e.g., 10-10-10)';
      } else {
        _fertilizer = 'No fertilizer needed';
      }
    } else if (_selectedCrop == 'Potato') {
      // Ideal NPK values for potato: N (80-160), P (40-100), K (120-300)
      if (_npkValues['nitrogen']! < 80) {
        _nitrogenStatus = 'Deficient';
      } else {
        _nitrogenStatus = 'Sufficient';
      }

      if (_npkValues['phosphorus']! < 40) {
        _phosphorusStatus = 'Deficient';
      } else {
        _phosphorusStatus = 'Sufficient';
      }

      if (_npkValues['potassium']! < 120) {
        _potassiumStatus = 'Deficient';
      } else {
        _potassiumStatus = 'Sufficient';
      }

      // Provide fertilizer recommendation
      if (_nitrogenStatus == 'Deficient' ||
          _phosphorusStatus == 'Deficient' ||
          _potassiumStatus == 'Deficient') {
        _fertilizer = 'Apply a high NPK fertilizer (e.g., 15-15-15)';
      } else {
        _fertilizer = 'No fertilizer needed';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NPK Analyzer'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 165, 182, 143),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NPK Values',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Nitrogen',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${_npkValues['nitrogen'] ?? ''}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Phosphorus',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${_npkValues['phosphorus'] ?? ''}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Potassium',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${_npkValues['potassium'] ?? ''}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Select Crop',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedCrop,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCrop = newValue;
                  _calculateDeficiencies();
                });
              },
              items: <String>['Tomato', 'Potato']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            if (_selectedCrop != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deficiencies',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildDeficiencyTile('Nitrogen', _nitrogenStatus),
                  _buildDeficiencyTile('Phosphorus', _phosphorusStatus),
                  _buildDeficiencyTile('Potassium', _potassiumStatus),
                  SizedBox(height: 16),
                  Text(
                    'Fertilizer Recommendation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _fertilizer,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeficiencyTile(String nutrient, String status) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              '$nutrient:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 16,
                  color: status == 'Deficient' ? Colors.red : Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
