import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:blackox/i18n/app_localization.dart';

class StartingScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const StartingScreen({Key? key, required this.onLocaleChange}) : super(key: key);

  @override
  _StartingScreenState createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  int _currentStep = 0;
  String? _selectedLanguage;
  String? _selectedOccupation;
  List<String> _selectedSubCategories = [];

  void _resetSteps(String occupation) {
    setState(() {
      _selectedOccupation = occupation;
      _currentStep = _selectedOccupation == 'Business' ? 2 : 3;
    });
  }

  void _navigateToStep(int step) {
    setState(() {
      if (step >= 0 && step < _getSteps().length) {
        _currentStep = step;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (_currentStep > 0) {
              _navigateToStep(_currentStep - 1);
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
            child: const Text('Skip', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(
              'assets/Images/BlackOxLogo.png',
              height: 150.0,
              width: 300.0,
              fit: BoxFit.fitWidth,
            ),
          ),
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < _getSteps().length - 1) {
                  _navigateToStep(_currentStep + 1);
                } else {
                  // Handle final submission or navigation
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  _navigateToStep(_currentStep - 1);
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
    List<Step> steps = [
      Step(
        title: const Text('1'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              AppLocalizations.of(context).translate('choose_language'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildLanguageButton('English', 'en'),
            const SizedBox(height: 20),
            _buildLanguageButton('Marathi', 'mr'),
            const SizedBox(height: 20),
            _buildLanguageButton('Hindi', 'hi'),
            const SizedBox(height: 20),
            _buildLanguageButton('Gujarati', 'gu'),
            const SizedBox(height: 20),
            _buildLanguageButton('Kannada', 'kn'),
          ],
        ),
        isActive: _currentStep >= 0,
        state: _currentStep == 0 ? StepState.editing : StepState.complete,
      ),
      Step(
        title: const Text('2'),
        content: Column(
          children: [
            Text(
              AppLocalizations.of(context).translate('choose_occupation'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildOccupationButton('Farmer', 'assets/Icon/farmerIcon.png'),
            const SizedBox(height: 20),
            _buildOccupationButton('Business', 'assets/Icon/businessIcon.png'),
          ],
        ),
        isActive: _currentStep >= 1,
        state: _currentStep == 1 ? StepState.editing : StepState.complete,
      ),
    ];

    if (_selectedOccupation == 'Business') {
      steps.addAll([
        Step(
          title: const Text('3'),
          content: _buildPersonalDetailForm(),
          isActive: _currentStep == 2,
          state: _currentStep == 2 ? StepState.editing : StepState.complete,
        ),
        Step(
          title: const Text('4'),
          content: _buildBusinessDetailForm(),
          isActive: _currentStep == 3,
          state: _currentStep == 3 ? StepState.editing : StepState.complete,
        ),
        Step(
          title: const Text('5'),
          content: _buildSubCategorySelection(),
          isActive: _currentStep == 4,
          state: _currentStep == 4 ? StepState.editing : StepState.complete,
        ),
      ]);
    } else if (_selectedOccupation == 'Farmer') {
      steps.add(
        Step(
          title: const Text('3'),
          content: Column(
            children: [
              Text(
                AppLocalizations.of(context).translate('sub_category'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildSubCategorySelection(),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Handle Continue action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 60), // Increase button size
                ),
                child: Text(
                  AppLocalizations.of(context).translate('continue'),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
          isActive: _currentStep == 2,
          state: _currentStep == 2 ? StepState.editing : StepState.complete,
        ),
      );
    }

    return steps;
  }

  Widget _buildLanguageButton(String language, String code) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedLanguage = language;
          widget.onLocaleChange(Locale(code));
          if (_currentStep < 3) {
            _currentStep += 1;
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedLanguage == language ? Colors.white38 : Colors.grey,
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
      onPressed: () => _resetSteps(occupation),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedOccupation == occupation ? Colors.white38 : Colors.grey,
        minimumSize: const Size(double.infinity, 60),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context).translate(occupation),
              style: const TextStyle(color: Colors.black, fontSize: 18)),
          const SizedBox(width: 10),
          Image.asset(imagePath, width: 24, height: 24),
        ],
      ),
    );
  }

  Widget _buildSubCategorySelection() {
    List<String> subCategories = ['Machine rent', 'Labour', 'Advisor'];

    return Column(
      children: subCategories.map((subCategory) {
        return CheckboxListTile(
          title: Text(subCategory),
          value: _selectedSubCategories.contains(subCategory),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _selectedSubCategories.add(subCategory);
              } else {
                _selectedSubCategories.remove(subCategory);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildPersonalDetailForm() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).translate('personal_details'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('name'),
            border: const OutlineInputBorder(),
          ),
          validator: RequiredValidator(errorText: 'Name is required'),
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('phone'),
            border: const OutlineInputBorder(),
          ),
          validator: RequiredValidator(errorText: 'Phone number is required'),
        ),
      ],
    );
  }

  Widget _buildBusinessDetailForm() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context).translate('business_details'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('business_name'),
            border: const OutlineInputBorder(),
          ),
          validator: RequiredValidator(errorText: 'Business name is required'),
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('business_phone'),
            border: const OutlineInputBorder(),
          ),
          validator: RequiredValidator(errorText: 'Business phone is required'),
        ),
      ],
    );
  }
}
