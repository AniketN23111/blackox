import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Splash Screen Example"),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text("Using Timer Method"),
      ),
    );
  }
}