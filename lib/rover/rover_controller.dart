import 'dart:io';
import 'package:flutter/material.dart';

class RoverControlPage extends StatefulWidget {
  @override
  _RoverControlPageState createState() => _RoverControlPageState();
}

class _RoverControlPageState extends State<RoverControlPage> {
  String _serverIp = '192.168.185.190'; // Default ESP32 IP address
  int _serverPort = 59430; // Default ESP32 port number
  bool isConnected = false; // Track connection status

  RawDatagramSocket? _socket; // Socket for UDP communication

  @override
  void initState() {
    super.initState();
    _initUdpConnection();
  }

  Future<void> _initUdpConnection() async {
    try {
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      setState(() {
        isConnected = true;
      });
    } catch (e) {
      print('Failed to bind UDP socket: $e');
    }
  }

  void _sendCommand(String command) {
    if (_socket != null) {
      final data = command.codeUnits;
      _socket!.send(data, InternetAddress(_serverIp), _serverPort);
      print('Sending command: $command');
    }
  }

  @override
  void dispose() {
    _socket?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rover Control'),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Color.fromARGB(255, 165, 182, 143),
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Connection settings
            TextField(
              decoration: InputDecoration(labelText: 'Server IP'),
              onChanged: (value) => _serverIp = value,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Server Port'),
              keyboardType: TextInputType.number,
              onChanged: (value) => _serverPort = int.parse(value),
            ),
            SizedBox(height: 20),

            // Rover controls
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Forward button
                    ElevatedButton(
                      onPressed: isConnected ? () => _sendCommand('f') : null,
                      child: Text('^', style: TextStyle(fontSize: 20)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Left and Right buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: isConnected ? () => _sendCommand('l') : null,
                          child: Text('<', style: TextStyle(fontSize: 20)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: isConnected ? () => _sendCommand('r') : null,
                          child: Text('>', style: TextStyle(fontSize: 20)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.withOpacity(0.3),
                            padding: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Backward button
                    ElevatedButton(
                      onPressed: isConnected ? () => _sendCommand('b') : null,
                      child: Text('v', style: TextStyle(fontSize: 20)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Stop button
                    ElevatedButton(
                      onPressed: isConnected ? () => _sendCommand('s') : null,
                      child: Text('Stop', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}