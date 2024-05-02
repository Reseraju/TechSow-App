import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _name = "";
  String _email = "";
  String _imageUrl = "";
  bool _isFetchingData = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isFetchingData = true;
    });
    try {
      // Get current user ID
      final String userId = _auth.currentUser!.uid;

      // Get user document from Firestore
      final DocumentSnapshot? document =
          await _firestore.collection('User').doc(userId).get();

      if (document != null && document.exists) {
        setState(() {
          _name = document['name'];
          _email = document['email'];
          _imageUrl = document['imgUrl'];
        });
      }
    } catch (error) {
      // Handle errors during data fetching
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching user data: $error'),
        ),
      );
    } finally {
      setState(() {
        _isFetchingData = false;
      });
    }
  }

  Future<void> _updateUserProfile(String newName, String newEmail) async {
    await _firestore.collection('User').doc(_auth.currentUser!.uid).update({
      'name': newName,
      'email': newEmail,
    });
    setState(() {
      _name = newName;
      _email = newEmail;
    });
  }

  void _showUpdateDialog() {
    String newName = '';
    String newEmail = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newName = value;
                },
                decoration: InputDecoration(labelText: 'New Name'),
              ),
              SizedBox(height: 10.0),
              TextField(
                onChanged: (value) {
                  newEmail = value;
                },
                decoration: InputDecoration(labelText: 'New Email'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateUserProfile(newName, newEmail);
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 165, 182, 143),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _showUpdateDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile picture section
              _isFetchingData
                  ? CircularProgressIndicator() // Show progress indicator while fetching
                  : _imageUrl?.isNotEmpty ?? false
                      ? CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(_imageUrl!),
                        )
                      : CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              AssetImage('assets/default_profile.png'),
                        ),
              SizedBox(height: 20.0),

              // User name section
              Text(
                _name,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),

              // User email section
              Text(
                _email,
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              SizedBox(height: 20.0),

              // Plant detections section (same as before)
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Plant Detections',
              //       style: TextStyle(fontSize: 18.0),
              //     ),
              //     Text(
              //       '10', // Replace with number of detections
              //       style:
              //           TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              //     ),
              //   ],
              // ),
              Divider(height: 1.0),
              SizedBox(height: 10.0),
              // ...

              // Saved plants section (optional)
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saved Plants',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    '2', // Replace with number of saved plants
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(height: 1.0),
              // ...

              // Settings button
              SizedBox(height: 20.0),
              // ElevatedButton(
              //   onPressed: () {
              //     // Navigate to settings page
              //   },
              //   child: Text('Settings'),
              // ),
              // ...
            ],
          ),
        ),
      ),
    );
  }
}
