import 'package:blackox/Constants/screen_utility.dart';
import 'package:blackox/i18n/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';

class SelectionScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const SelectionScreen({super.key, required this.onLocaleChange});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {

  String? selectedCategoryType;
  String? selectedRatePer;

  TextEditingController perNameController = TextEditingController();
  TextEditingController perEmailController = TextEditingController();
  TextEditingController perNumberController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessAddressController = TextEditingController();
  TextEditingController businessCityController = TextEditingController();
  TextEditingController businessPinCodeController = TextEditingController();
  TextEditingController businessGSTController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController discountRateController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

  int _currentStep = 0;
  String? _selectedLanguage;
  String? _selectedOccupation;
  final List<String> _selectedSubCategories = [];
  List<Step> steps = [];

  bool isStored=false;

  void _resetSteps(String occupation) {
    setState(() {
      _selectedOccupation = occupation;
      _currentStep = _selectedOccupation == 'Farmer' ? 2 : 2;
    });
  }

  void _navigateToStep(int step) {
    setState(() {
      if (step >= 0 && step < _getSteps().length) {
        _currentStep = step;
      }
    });
  }
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (picked != null) {
      setState(() {
        controller.text = dateFormatter.format(picked);
      });
    }
  }

  void registerDetails(){
    setState(() {
      DateTime registerDate = DateTime.now();
      registerBusinessDetails(perNameController.text, perNumberController.text, perEmailController.text, businessNameController.text, businessAddressController.text, int.parse(businessPinCodeController.text), businessCityController.text, businessGSTController.text, selectedCategoryType.toString(), productNameController.text, int.parse(rateController.text), selectedRatePer.toString(), discountRateController.text, DateTime.parse(startDateController.text), DateTime.parse(endDateController.text), registerDate);
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
              height: ScreenUtility.screenHeight * 0.2,
              fit: BoxFit.fitWidth,
            ),
          ),
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              steps: _getSteps(),
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
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: ScreenUtility.screenHeight * 0.02),
            _buildLanguageButton('English', 'en'),
             SizedBox(height: ScreenUtility.screenHeight * 0.02),
            _buildLanguageButton('Marathi', 'mr'),
             SizedBox(height: ScreenUtility.screenHeight * 0.02),
            _buildLanguageButton('Hindi', 'hi'),
             SizedBox(height: ScreenUtility.screenHeight * 0.02),
            _buildLanguageButton('Gujarati', 'gu'),
             SizedBox(height: ScreenUtility.screenHeight * 0.02),
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
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: ScreenUtility.screenHeight * 0.02),
            _buildOccupationButton('Farmer', 'assets/Icon/farmerIcon.png'),
             SizedBox(height: ScreenUtility.screenHeight * 0.02),
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
      _currentStep = _currentStep < 2
          ? 2
          : _currentStep; // Ensure current step is at least 4
      _currentStep = _currentStep > 2
          ? 2
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
          title: const Text('3'),
          content: Column(
            children: [
              Text(
                AppLocalizations.of(context).translate('sub_category'),
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
               SizedBox(height: ScreenUtility.screenHeight * 0.02),
              _buildSubCategoryButton('Machine rent'),
               SizedBox(height: ScreenUtility.screenHeight * 0.02),
              _buildSubCategoryButton('Labour'),
               SizedBox(height: ScreenUtility.screenHeight * 0.02),
              _buildSubCategoryButton('Advisor'),
               SizedBox(height: ScreenUtility.screenHeight * 0.03),
              ElevatedButton(
                onPressed: () {
                  // Handle Add More action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(
                      ScreenUtility.screenWidth * 0.8,
                      ScreenUtility.screenHeight *
                          0.05), // Increase button size
                ),
                child: Text(
                  AppLocalizations.of(context).translate('add_more'),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
               SizedBox(height: ScreenUtility.screenHeight * 0.03),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/authenticationScreen');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(
                      ScreenUtility.screenWidth * 0.8,
                      ScreenUtility.screenHeight *
                          0.05), // Increase button size
                ),
                child: Text(
                  AppLocalizations.of(context).translate('continue'),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
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
        backgroundColor:
            _selectedLanguage == language ? Colors.white38 : Colors.grey,
        minimumSize: Size(ScreenUtility.screenWidth * 0.8,
            ScreenUtility.screenHeight * 0.05),
      ),
      child: Text(
        language,
        style: const TextStyle(color: Colors.black,fontSize: 24),
      ),
    );
  }

  Widget _buildOccupationButton(String occupation, String imagePath) {
    return ElevatedButton(
      onPressed: () => _resetSteps(occupation),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _selectedOccupation == occupation ? Colors.white38 : Colors.grey,
        minimumSize: Size(ScreenUtility.screenWidth * 0.8,
            ScreenUtility.screenHeight * 0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context).translate(occupation),
              style: const TextStyle(color: Colors.black, fontSize: 24)),
           SizedBox(width: ScreenUtility.screenWidth * 0.02),
          Image.asset(imagePath,
              width: ScreenUtility.screenWidth * 0.2,
              height: ScreenUtility.screenHeight * 0.08,
            fit: BoxFit.fitHeight,),
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
        minimumSize: Size(ScreenUtility.screenWidth * 0.8,
            ScreenUtility.screenHeight * 0.05),
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
           SizedBox(width: ScreenUtility.screenHeight * 0.01),
          Text(subCategory,
              style: const TextStyle(color: Colors.black, fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailForm() {
    final formkey = GlobalKey<FormState>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  controller: perNameController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Enter Name"),
                    MinLengthValidator(3,
                        errorText: 'Minimum 3 character filled name'),
                  ]).call,
                  decoration: const InputDecoration(
                      hintText: 'Enter Name',
                      labelText: 'Enter Name',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.green,
                      ),
                      contentPadding:  EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: perEmailController,
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
                      contentPadding:  EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius:
                              BorderRadius.all(Radius.circular(9.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: perNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Enter mobile number'),
                    PatternValidator(r'^[0-9]{10}$',
                        errorText: 'Enter valid 10-digit mobile number'),
                  ]).call,
                  decoration: const InputDecoration(
                      hintText: 'Mobile',
                      labelText: 'Mobile',
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.grey,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(9)))),
                ),
              ),
               SizedBox(height: ScreenUtility.screenHeight * 0.02),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    setState(() {
                      _currentStep += 1;
                      StepState.complete;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(
                      ScreenUtility.screenWidth * 0.8,
                      ScreenUtility.screenHeight *
                          0.05), // Increase button size
                ),
                child: Text(
                  AppLocalizations.of(context).translate('continue'),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessDetailForm() {
    final bformkey = GlobalKey<FormState>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: bformkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  controller: businessNameController,
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: AppLocalizations.of(context)
                            .translate('enter_business_name')),
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
                      contentPadding:  EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius:
                              BorderRadius.all(Radius.circular(9.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: businessAddressController,
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
                      contentPadding:  EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius:
                              BorderRadius.all(Radius.circular(9.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: businessPinCodeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the 6-digit Pin-Code';
                    }
                    if (value.length != 6) {
                      return 'Pin-Code must be exactly 6 digits';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Pin-Code',
                      labelText: 'Pin-Code',
                      prefixIcon: Icon(
                        Icons.pin_drop_rounded,
                        color: Colors.red,
                      ),
                      contentPadding:  EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(9)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: businessCityController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Enter Business Address'),
                  ]).call,
                  decoration: const InputDecoration(
                      hintText: 'City',
                      labelText: 'City',
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: Colors.black,
                      ),
                      contentPadding:  EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius:
                          BorderRadius.all(Radius.circular(9.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: businessGSTController,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(15),
                  ],
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the GST';
                    }
                    if (value.length != 15) {
                      return 'GST Is Invalid';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: 'GST-NO',
                      labelText: 'GST-NO',
                      prefixIcon: Icon(
                        Icons.format_list_numbered_rtl_sharp,
                        color: Colors.grey,
                      ),
                      contentPadding:  EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(9)))),
                ),
              ),
               SizedBox(height: ScreenUtility.screenHeight * 0.02),
              ElevatedButton(
                onPressed: () {
                  if (bformkey.currentState!.validate()) {
                    setState(() {
                      StepState.complete;
                      _currentStep += 1;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(
                      ScreenUtility.screenWidth * 0.8,
                      ScreenUtility.screenHeight *
                          0.05), // Increase button size
                ),
                child: Text(
                  AppLocalizations.of(context).translate('continue'),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSubCategorySelection() {
    final List<String> categoryType = [
      'Seed Suppliers',
      'Labour',
      'Machinery Rental',
      'Seller'
    ];

    final List<String> ratePer = ['Acre', 'KG', 'Person', 'Day' ,'KM'
    ];
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              items: categoryType.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategoryType = newValue;
                });
              },
              value: selectedCategoryType,
              decoration: InputDecoration(
                hintText: selectedCategoryType ?? 'Category Type',
                labelText: selectedCategoryType ?? 'Category Type',
                prefixIcon: const Icon(
                  Icons.business,
                  color: Colors.grey,
                ),
                contentPadding:  EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: productNameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Product Name',
                labelText: 'Product Name',
                prefixIcon: Icon(
                  Icons.drive_file_rename_outline,
                  color: Colors.grey,
                ),
                contentPadding:  EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: rateController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Rate';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Rate',
                labelText: 'Rate',
                prefixIcon: Icon(
                  Icons.currency_rupee,
                  color: Colors.grey,
                ),
                contentPadding:  EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              items: ratePer.map((String ratePerRate) {
                return DropdownMenuItem<String>(
                  value: ratePerRate,
                  child: Text(ratePerRate),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedRatePer = newValue;
                });
              },
              value: selectedRatePer,
              decoration: InputDecoration(
                hintText: selectedRatePer ?? 'Rate Per',
                labelText: selectedRatePer ?? 'Rate Per',
                prefixIcon: const Icon(
                  Icons.local_atm_outlined,
                  color: Colors.grey,
                ),
                contentPadding:  EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: discountRateController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: const InputDecoration(
                hintText: 'Discount Rate',
                labelText: 'Discount Rate',
                prefixIcon: Icon(
                  Icons.discount,
                  color: Colors.grey,
                ),
                contentPadding:  EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: startDateController,
              readOnly: true,
              onTap: () => _selectDate(context, startDateController),
              decoration: const InputDecoration(
                hintText: 'Start Date',
                labelText: 'Start Date',
                prefixIcon: Icon(
                  Icons.today_sharp,
                  color: Colors.grey,
                ),
                contentPadding:  EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: endDateController,
              readOnly: true,
              onTap: () => _selectDate(context, endDateController),
              decoration: const InputDecoration(
                hintText: 'End Date',
                labelText: 'End Date',
                prefixIcon: Icon(
                  Icons.today_sharp,
                  color: Colors.grey,
                ),
                contentPadding:  EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
              ),
            ),
          ),
          SizedBox(height: ScreenUtility.screenHeight * 0.03),
          ElevatedButton(
            onPressed: () {
              registerDetails();
              if(isStored)
              {
                 Navigator.pushNamed(context, '/LoginScreen');
              }
              else{
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                      content: Text(
                          'Registration failed. Please try again')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(
                  ScreenUtility.screenWidth * 0.8,
                  ScreenUtility.screenHeight *
                      0.05), // Increase button size
            ),
            child: Text(
              AppLocalizations.of(context).translate('continue'),
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> registerBusinessDetails(String uName, String uNumber, String uEmail, String bName,String bAddress, int bPinCode, String bCity, String gstNO,String categoryType, String productName, int rate, String ratePer,String discountRate,DateTime startDate,DateTime endDate,DateTime registerDate ) async {
    try {
      final connection = await Connection.open(
        Endpoint(
          host: '34.71.87.187',
          port: 5432,
          database: 'airegulation_dev',
          username: 'postgres',
          password: 'India@5555',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );

      connection.execute(
        'INSERT INTO ai.business_details (u_name,u_number,u_email,b_name,b_address,b_pincode,b_city,gstno,category_type,product_name,rate,rate_per,discount_rate,start_date,end_date,register_date) '
            'VALUES (\$1, \$2, \$3, \$4,\$5, \$6, \$7, \$8,\$9, \$10, \$11, \$12,\$13, \$14, \$15, \$16)',
        parameters: [uName,uNumber,uEmail,bName,bAddress,bPinCode,bCity,gstNO,categoryType,productName,rate,ratePer,discountRate,startDate,endDate,registerDate],
      );
      isStored=true;
      return true;
    } catch (e) {
      return false;
    }
  }
}
