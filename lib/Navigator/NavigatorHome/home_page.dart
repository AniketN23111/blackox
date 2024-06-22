import 'package:flutter/material.dart';
import 'package:blackox/Constants/screen_utility.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRectangularButton(
                    'assets/Icon/Calculator.png', context,
                    width: ScreenUtility.screenWidth * 0.28,
                    height: ScreenUtility.screenHeight * 0.15),
                _buildRectangularButton('assets/Icon/plus_icon.png', context,
                    width: ScreenUtility.screenWidth * 0.28,
                    height: ScreenUtility.screenHeight * 0.15),
                _buildRectangularButton(
                    'assets/Icon/Satellite_icon.png', context,
                    width: ScreenUtility.screenWidth * 0.28,
                    height: ScreenUtility.screenHeight * 0.15),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRectangularButtonText(
                        'assets/Icon/plus_icon.png', 'Crop Add', context,
                        width: ScreenUtility.screenWidth * 0.2,
                        height: ScreenUtility.screenHeight * 0.12),
                    _buildRectangularButtonText(
                        'assets/Icon/Calculator.png', 'Crop Calculator', context,
                        width: ScreenUtility.screenWidth * 0.2,
                        height: ScreenUtility.screenHeight * 0.12),
                    _buildRectangularButtonText(
                        'assets/Icon/Emblem_of_India.png', 'Government Schema', context,
                        width: ScreenUtility.screenWidth * 0.2,
                        height: ScreenUtility.screenHeight * 0.12),
                    _buildRectangularButtonText(
                        'assets/Icon/tractor_icon.png', 'Farmers Community', context,
                        width: ScreenUtility.screenWidth * 0.2,
                        height: ScreenUtility.screenHeight * 0.12),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRectangularButtonText(
                        'assets/Icon/agriculture_icon.png', 'Advisor Community', context,
                        width: ScreenUtility.screenWidth * 0.2,
                        height: ScreenUtility.screenHeight * 0.12),
                    _buildRectangularButtonText(
                        'assets/Icon/exporters_icon.png', 'Exporters', context,
                        width: ScreenUtility.screenWidth * 0.2,
                        height: ScreenUtility.screenHeight * 0.12),
                    _buildRectangularButtonText(
                        'assets/Icon/drone_icon.png', 'Agri Startup', context,
                        width: ScreenUtility.screenWidth * 0.2,
                        height: ScreenUtility.screenHeight * 0.12),
                    _buildRectangularButtonText(
                        'assets/Icon/businessIcon.png', 'Business', context,
                        width: ScreenUtility.screenWidth * 0.2,
                        height: ScreenUtility.screenHeight * 0.12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRectangularButton(
      String imagePath, BuildContext context,
      {double width = 15, double height = 15}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: () {
            // Handle button tap
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Button pressed')));
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFFB799FF),
            minimumSize: Size(width, height),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Center(
            child: Image.asset(imagePath,
                width: 60, height: 60, fit: BoxFit.fitHeight),
          ),
        ),
      ),
    );
  }

  Widget _buildRectangularButtonText(
      String imagePath, String title, BuildContext context,
      {double width = 15, double height = 15}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: () {
            if (title == 'Business') {
              Navigator.pushNamed(context, 'businessDetailsShops');
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('$title button pressed')));
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color(0xFF89CFF3),
            minimumSize: Size(width, height),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath,
                  width: 40, height: 40, fit: BoxFit.fitHeight),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
