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
        // backgroundColor: Colors.transparent,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isConnected
                                ? () => _sendCommand('forward')
                                : null,
                            child:
                                Text('^', style: TextStyle(fontSize: 20)),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            // disabledBackgroundColor:
                            //     Colors.green.withOpacity(0.3),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isConnected
                                ? () => _sendCommand('backward')
                                : null,
                            child: Text('Backward',
                                style: TextStyle(fontSize: 20)),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              backgroundColor:
                                  const Color.fromARGB(255, 106, 207, 110),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // disabledBackgroundColor:
                              //     Colors.green.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                isConnected ? () => _sendCommand('left') : null,
                            child: Text('Left', style: TextStyle(fontSize: 20)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isConnected
                                ? () => _sendCommand('right')
                                : null,
                            child:
                                Text('Right', style: TextStyle(fontSize: 20)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.withOpacity(0.3),
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
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
