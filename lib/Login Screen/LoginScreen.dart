import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          SizedBox(
            height: 200,
            width:  double.infinity,
            child: Image.asset('assets/Images/BlackOxLogo.png',
              fit: BoxFit.fill,),
          ),
           SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.asset('assets/Icon/Account.png',
            fit: BoxFit.fill,),
          ),
        ],
      ),
    );
  }
}
