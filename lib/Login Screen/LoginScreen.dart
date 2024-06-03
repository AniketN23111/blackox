import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/Images/BlackOxLogo.png',
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset(
                    'assets/Icon/Account.png',
                    fit: BoxFit.fill,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize:
                        const Size(double.infinity, 60), // Increase button size
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signUpScreen');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize:
                        const Size(double.infinity, 60), // Increase button size
                  ),
                  child: const Text(
                    'Sign UP',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'OR',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 300,
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
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 300,
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
