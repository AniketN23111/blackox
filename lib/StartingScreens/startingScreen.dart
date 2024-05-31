import 'package:blackox/i18n/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class StartingScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const StartingScreen({Key? key, required this.onLocaleChange})
      : super(key: key);

  @override
  _StartingScreenState createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  int _currentStep = 0;
  String? _selectedLanguage;
  String? _selectedOccupation;
  List<String> _selectedSubCategories = [];
  List<Step> steps = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (_currentStep > 0) {
              if (_currentStep == 4 && _selectedOccupation == 'Farmer') {
                // If on step 4 and selected occupation is farmer, reset to step 1
                setState(() {
                  _currentStep = 1;
                  _selectedOccupation = null; // Reset selected occupation
                });
              } else if (_currentStep == 2) {
                // Otherwise, proceed with normal back navigation
                setState(() {
                  _currentStep = 1;
                  _selectedOccupation =
                      null; // Ensure _currentStep is within range
                });
              } else {
                setState(() {
                  _currentStep =
                      (_currentStep - 1); // Ensure _currentStep is within range
                });
              }
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
              height: 100.0,
              width: 300.0,
              fit: BoxFit.fitWidth,
            ),
          ),
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 4) {
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
    steps.clear();
    steps.addAll([
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
    ]);

    if (_selectedOccupation == 'Business') {
      _currentStep = _currentStep < 2
          ? 2
          : _currentStep; // Ensure current step is at least 2
      _currentStep = _currentStep > 4
          ? 4
          : _currentStep; // Ensure current step is at most 4
    } else if (_selectedOccupation == 'Farmer') {
      _currentStep = _currentStep < 4
          ? 4
          : _currentStep; // Ensure current step is at least 4
      _currentStep = _currentStep > 4
          ? 4
          : _currentStep; // Ensure current step is at most 4
    }

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
          title: const Text('5'),
          content: Column(
            children: [
              Text(
                AppLocalizations.of(context).translate('sub_category'),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                child: Text(
                  AppLocalizations.of(context).translate('add_more'),
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Handle Continue action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize:
                      const Size(double.infinity, 60), // Increase button size
                ),
                child: Text(
                  AppLocalizations.of(context).translate('continue'),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
          isActive: _currentStep == 4,
          state: _currentStep == 4 ? StepState.editing : StepState.complete,
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
          _currentStep += 1;
          // Expand the stepper to show 5 steps
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _selectedOccupation == occupation ? Colors.white38 : Colors.grey,
        minimumSize: const Size(double.infinity, 60),
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
        minimumSize: const Size(double.infinity, 60),
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
          Text(subCategory,
              style: const TextStyle(color: Colors.black, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailForm() {
    final _formkey = GlobalKey<FormState>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Enter Name'),
                    MinLengthValidator(3,
                        errorText: 'Minimum 3 character filled name'),
                  ]).call,
                  decoration: const InputDecoration(
                      hintText: 'Enter  Name',
                      labelText: 'Enter Name',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.green,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius:
                              BorderRadius.all(Radius.circular(9.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Enter email address'),
                    EmailValidator(errorText: 'Please correct email filled'),
                  ]).call,
                  decoration: const InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.lightBlue,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius:
                              BorderRadius.all(Radius.circular(9.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Password';
                    }
                    // Check if password meets the criteria
                    bool isValidPassword = _validatePassword(value);
                    if (!isValidPassword) {
                      return 'Password must have a minimum of 8 characters and include letters, numbers, and special characters.';
                    }
                    return null; // Validation passed
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.lightBlue,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius:
                              BorderRadius.all(Radius.circular(9.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Enter mobile number'),
                    PatternValidator(r'({10}$)',
                        errorText: 'enter valid mobile number'),
                  ]).call,
                  decoration: const InputDecoration(
                      hintText: 'Mobile',
                      labelText: 'Mobile',
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(9)))),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  //if(_formkey.currentState!.validate())
                  setState(() {
                    _currentStep += 1;
                    StepState.complete;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize:
                      const Size(double.infinity, 60), // Increase button size
                ),
                child: Text(
                  AppLocalizations.of(context).translate('continue'),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessDetailForm() {
    final _bformkey = GlobalKey<FormState>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _bformkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  validator: MultiValidator([
                    RequiredValidator(errorText: AppLocalizations.of(context).translate('enter_business_name')),
                    MinLengthValidator(3,
                        errorText: 'Minimum 3 character filled name'),
                  ]).call,
                  decoration: const InputDecoration(
                      hintText: 'Enter Business Name',
                      labelText: 'Enter Business Name',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.green,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius:
                              BorderRadius.all(Radius.circular(9.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Enter Business Address'),
                  ]).call,
                  decoration: const InputDecoration(
                      hintText: 'Business Address',
                      labelText: 'Business Address',
                      prefixIcon: Icon(
                        Icons.location_city_outlined,
                        color: Colors.lightBlue,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius:
                              BorderRadius.all(Radius.circular(9.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Enter Pin-Code number'),
                    PatternValidator(r'(^{6}$)',
                        errorText: 'Enter Valid Pin-Code number'),
                  ]).call,
                  decoration: const InputDecoration(
                      hintText: 'Pin-Code',
                      labelText: 'Pin-Code',
                      prefixIcon: Icon(
                        Icons.pin_drop_rounded,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(9)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Enter GST number'),
                    PatternValidator(r'({6}$)',
                        errorText: 'Enter Valid GST number'),
                  ]).call,
                  decoration: const InputDecoration(
                      hintText: 'GST-NO',
                      labelText: 'GST-NO',
                      prefixIcon: Icon(
                        Icons.format_list_numbered_rtl_sharp,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(9)))),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  //if (_bformkey.currentState!.validate()) {
                  setState(() {
                    StepState.complete;
                    _currentStep += 1;
                  });
                  //}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize:
                      const Size(double.infinity, 60), // Increase button size
                ),
                child: Text(
                  AppLocalizations.of(context).translate('continue'),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubCategorySelection() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          // Expand the stepper to show 5 steps
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        minimumSize: const Size(double.infinity, 60),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('SubCategory',
              style: const TextStyle(color: Colors.black, fontSize: 18)),
        ],
      ),
    );
  }

  bool _validatePassword(String password) {
    // Regular expression to check if password contains at least one letter, one number, and one special character
    final RegExp regex =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return regex.hasMatch(password);
  }
}
