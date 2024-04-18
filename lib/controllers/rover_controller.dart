import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RoverControlPage extends StatefulWidget {
  @override
  _RoverControlPageState createState() => _RoverControlPageState();
}

class _RoverControlPageState extends State<RoverControlPage> {

  final String _serverUrl = 'http://192.168.1.100'; // Replace with your ESP32's IP address
  bool isConnected = false; // Track connection status
  bool isRunning = false; // Track rover running state

  void _sendCommand(String command) async{
    final url = Uri.parse('$_serverUrl/move?cmd=$command');
    await http.get(url);
    print('Sending command: $command');
  }

  void _toggleStartStop() {
    setState(() {
      isRunning = !isRunning;
      if (isRunning && !isConnected) {
        // Show a warning if trying to start without connection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please connect to the rover before starting'),
          ),
        );
      } else if (isRunning) {
        _sendCommand('start');
      } else {
        _sendCommand('stop');
      }
    });
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
            // Connection status indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //     isConnected
                //         ? Icons.bluetooth_connected
                //         : Icons.bluetooth_disabled,
                //     size: 30,
                //     color: Colors.blue),
                // SizedBox(width: 10),
                // Text(isConnected ? 'Connected' : 'Disconnected',
                //     style: TextStyle(fontSize: 18, color: Colors.blue)),
              ],
            ),
            SizedBox(height: 30),

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
                      onPressed: isConnected
                          ? () => _sendCommand('forward')
                          : null,
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
                          onPressed: isConnected ? () => _sendCommand('left') : null,
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
                          onPressed: isConnected ? () => _sendCommand('right') : null,
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
                      onPressed: isConnected
                          ? () => _sendCommand('backward')
                          : null,
                      child: Text('v', style: TextStyle(fontSize: 20)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Start/Stop button
                    ElevatedButton(
                      onPressed: () => _toggleStartStop(),
                      child: Text(isRunning ? 'Stop' : 'Start', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRunning ? Colors.red : Colors.green,
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
