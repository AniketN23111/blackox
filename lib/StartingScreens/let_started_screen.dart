import 'package:blackox/Constants/ScreenUtility.dart';
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
             SizedBox(height: ScreenUtility.screenHeight * 0.03),
            Image.asset(
              "assets/Images/BlackOxLogo.png",
              height: ScreenUtility.screenHeight*0.3,
              width: ScreenUtility.screenWidth*0.8,
              fit: BoxFit.fitWidth,
            ),
             SizedBox(height: ScreenUtility.screenHeight * 0.06),
            Image.asset(
              'assets/Images/Bull.png',
              height: ScreenUtility.screenHeight*0.3,
              width: ScreenUtility.screenWidth*0.8,
            ),
            SizedBox(height: ScreenUtility.screenHeight * 0.06),
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
            SizedBox(height: ScreenUtility.screenHeight * 0.04),
           const Text('"Cultivating knowledge starts here"',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
