import 'package:blackox/HomeScreen/homeScreen.dart';
import 'package:blackox/StartingScreens/startingScreen.dart';
import 'package:flutter/material.dart';

class LetStartedScreen extends StatelessWidget {
  const LetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Image.asset(
              "assets/Images/BlackOxLogo.png",
              height: 200.0,
              width: 300.0,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 90),
            Image.asset(
              'assets/Images/Bull.png',
              height: 300,
              width: 500,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/startingScreen');
              },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black),
              child: const Text("Let Started",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              ),
            ),
           const Text('"Cultivating knowledge starts here"',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
