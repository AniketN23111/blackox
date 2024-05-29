import 'package:flutter/material.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({Key? key}) : super(key: key);

  @override
  _StartingScreenState createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  int _currentStep = 0;
  String? _selectedLanguage;
  String? _selectedOccupation;
  List<String> _selectedSubCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Black Ox'),
        actions: [
          TextButton(
            onPressed: () {
              // Handle skip action
            },
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(
              'assets/Images/BlackOxLogo.png',
              // Replace with the path to your image asset
              height: 100.0,
              width: 300.0,
              fit: BoxFit.fitWidth,
            ),
          ),
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 3) {
                  setState(() {
                    _currentStep += 1;
                  });
                } else {
                  // Handle final submission or navigation
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                }
              },
              steps: _getSteps(),
              type: StepperType.horizontal,
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: const Text('1'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Choose your Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildLanguageButton('Marathi'),
            const SizedBox(height: 20),
            _buildLanguageButton('Hindi'),
            const SizedBox(height: 20),
            _buildLanguageButton('Gujarati'),
            const SizedBox(height: 20),
            _buildLanguageButton('Kannada'),
            const SizedBox(height: 20),
            _buildLanguageButton('English'),
          ],
        ),
        isActive: _currentStep >= 0,
        state: _currentStep == 0 ? StepState.editing : StepState.complete,
      ),
      Step(
        title: const Text('2'),
        content: Column(
          children: [
            const Text(
              'Choose your Occupation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            _buildOccupationButton('Farmer', 'assets/Icon/farmerIcon.png'),
            const SizedBox(height: 20),
            _buildOccupationButton('Business', 'assets/Icon/businessIcon.png'),
          ],
        ),
        isActive: _currentStep >= 1,
        state: _currentStep == 1 ? StepState.editing : StepState.complete,
      ),
      Step(
        title: const Text('3'),
        content: Column(
          children: [
            const Text(
              'Sub category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSubCategoryButton('Machine rent'),
            const SizedBox(height: 20),
            _buildSubCategoryButton('Labour'),
            const SizedBox(height: 20),
            _buildSubCategoryButton('Advisor'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle Add More action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize:
                const Size(double.infinity, 60), // Increase button size
              ),
              child: const Text(
                'Add More',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                // Handle Continue action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize:
                const Size(double.infinity, 60), // Increase button size
              ),
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 2,
        state: _currentStep == 2 ? StepState.editing : StepState.complete,
      ),
    ];
  }

  Widget _buildLanguageButton(String language) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedLanguage = language;
          if (_currentStep < 3) {
            _currentStep += 1;
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
        _selectedLanguage == language ? Colors.white38 : Colors.grey,
        minimumSize: const Size(double.infinity, 60),
      ),
      child: Text(
        language,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildOccupationButton(String occupation, String imagePath) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedOccupation = occupation;
          if (_currentStep < 3) {
            _currentStep += 1;
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
        _selectedOccupation == occupation ? Colors.white38 : Colors.grey,
        minimumSize: const Size(double.infinity, 60), // Increase button size
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(occupation,
              style: const TextStyle(color: Colors.black, fontSize: 18)),
          const SizedBox(width: 10),
          Image.asset(imagePath, width: 24, height: 24),
        ],
      ),
    );
  }

  Widget _buildSubCategoryButton(String subCategory) {
    final bool isSelected = _selectedSubCategories.contains(subCategory);
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            _selectedSubCategories.remove(subCategory);
          } else {
            _selectedSubCategories.add(subCategory);
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.grey : Colors.grey,
        minimumSize: const Size(double.infinity, 60), // Increase button size
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 20,
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.green : Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(subCategory, style: const TextStyle(color: Colors.black, fontSize: 18)),
        ],
      ),
    );
  }
}
