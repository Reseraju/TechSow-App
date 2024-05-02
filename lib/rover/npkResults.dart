import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NPKResultsPage extends StatefulWidget {
  @override
  _NPKResultsPageState createState() => _NPKResultsPageState();
}

class _NPKResultsPageState extends State<NPKResultsPage> {
  DatabaseReference _database = FirebaseDatabase.instance.ref('crop/');
  Map<String, dynamic> _npkData = {
    'nitrogen': '',
    'phosphorus': '',
    'potassium': '',
  };

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the method to fetch data
  }

  Future<void> fetchData() async {
    _database.child('crop').child('tomato').onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        setState(() {
          _npkData = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        });
      }
    });
  }

  Future<void> writeData() async {
    _database.child('crop').child('tomato').onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        setState(() {
          _npkData = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String nitrogen = _npkData['nitrogen'] ?? '';
    String phosphorus = _npkData['phosphorus'] ?? '';
    String potassium = _npkData['potassium'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('NPK Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nitrogen: $nitrogen',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Phosphorus: $phosphorus',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Potassium: $potassium',
              style: const TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
