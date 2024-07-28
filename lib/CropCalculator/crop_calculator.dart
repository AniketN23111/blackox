import 'package:flutter/material.dart';
class CropCalculator extends StatefulWidget {
  const CropCalculator({super.key});

  @override
  State<CropCalculator> createState() => _CropCalculatorState();
}

class _CropCalculatorState extends State<CropCalculator> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Calculator")),
    );
  }
}
