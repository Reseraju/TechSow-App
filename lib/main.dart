import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:techsow/controllers/potato_crop.dart';
import 'package:techsow/controllers/rover_controller.dart';
import 'package:techsow/screens/home.dart';
import 'package:techsow/screens/profile.dart';
import 'package:techsow/screens/welcome_screen.dart';
import 'package:techsow/theme/theme.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key,}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightMode,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return const WelcomeScreen();
            }
          }),
      routes: {
        '/home': (context) => HomePage(),
        '/rover': (context) =>
            RoverControlPage(), // Define the IoT app development page route
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
