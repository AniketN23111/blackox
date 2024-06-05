import 'package:blackox/Constants/screen_utility.dart';
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
              height: Screen_utility.screenHeight*0.3,
              width: Screen_utility.screenWidth*0.8,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 90),
            Image.asset(
              'assets/Images/Bull.png',
              height: Screen_utility.screenHeight*0.3,
              width: Screen_utility.screenWidth*0.8,
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
