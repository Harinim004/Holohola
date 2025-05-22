import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'log_sign.dart'; // Import your login page
import 'main.dart'; // Ensure this is your home page

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), _checkUser);
  }

  void _checkUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is logged in, navigate to HomePage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ARCallHomePage()),
      );
    } else {
      // User is not logged in, navigate to LoginPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoomIn(
              duration: const Duration(seconds: 2),
              child: const Icon(
                Icons.phone_android,
                size: 80,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            FadeInDown(
              duration: const Duration(seconds: 2),
              child: const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Bounce(
              duration: const Duration(seconds: 2),
              child: const Text(
                "HOLOHOLA",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Pulse(
              duration: const Duration(seconds: 3),
              infinite: true,
              child: const Text(
                "Connecting the Future...",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
