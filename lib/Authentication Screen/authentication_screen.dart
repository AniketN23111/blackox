import 'package:blackox/Constants/ScreenUtility.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                 SizedBox(height: ScreenUtility.screenHeight * 0.03),
                SizedBox(
                  height: ScreenUtility.screenHeight * 0.25,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/Images/BlackOxLogo.png',
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: ScreenUtility.screenHeight * 0.2,
                  width: ScreenUtility.screenWidth * 0.5,
                  child: Image.asset(
                    'assets/Icon/Account.png',
                    fit: BoxFit.fill,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/LoginScreen');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize:
                         Size(ScreenUtility.screenWidth, ScreenUtility.screenHeight * 0.07), // Increase button size
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                 SizedBox(height: ScreenUtility.screenHeight * 0.03),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signUpScreen');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize:
                         Size(ScreenUtility.screenWidth, ScreenUtility.screenHeight * 0.07), // Increase button size
                  ),
                  child: const Text(
                    'Sign UP',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                 SizedBox(height: ScreenUtility.screenHeight * 0.03),
                const Text(
                  'OR',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                 SizedBox(height: ScreenUtility.screenHeight * 0.03),
                SizedBox(
                  height: ScreenUtility.screenHeight*0.05,
                  width: ScreenUtility.screenWidth*0.8,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Image.asset('assets/Icon/googleIcon.png'),
                    label: const Text('Continue with Google'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent
                    ),
                  ),
                ),
                 SizedBox(height: ScreenUtility.screenHeight * 0.03),
                SizedBox(
                  height: ScreenUtility.screenHeight*0.05,
                  width: ScreenUtility.screenWidth*0.8,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Image.asset('assets/Icon/WhatsAppIcon.png'),
                    label: const Text("Continue with WhatsApp"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
