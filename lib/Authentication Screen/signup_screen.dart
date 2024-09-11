import 'package:blackox/Constants/screen_utility.dart';
import 'package:blackox/Services/database_services.dart';
import 'package:blackox/Splash Screen/account_complete.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController emailOtpController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  EmailOTP myauth = EmailOTP();
  DatabaseService dbService = DatabaseService();

  bool isOtpVerified = false;
  bool isOtpEnabled = false;
  bool isOtpSending = false; // Added state variable for OTP sending process
  bool isSigningUp = false;
  bool isEmailValid = false; // Added state variable for email validity

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/Images/BlackOxLogo.png',
                    height: ScreenUtility.screenHeight * 0.17,
                    width: ScreenUtility.screenWidth * 0.8,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextFormField(
                    controller: nameController,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Enter Name'),
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
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passwordController,
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
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    controller: numberController,
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
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(9)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    onChanged: (value) {
                      setState(() {
                        isOtpEnabled = false;
                        isOtpVerified = false;
                        emailOtpController.clear();
                        isEmailValid = EmailValidator(
                                errorText: 'Please correct email filled')
                            .isValid(value);
                      });
                    },
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
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                  ),
                ),
                SizedBox(height: ScreenUtility.screenHeight * 0.05),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          isSigningUp = true;
                        });
                        bool isRegistered = await dbService.registerUser(
                          nameController.text,
                          passwordController.text,
                          emailController.text,
                          numberController.text,
                        );
                        setState(() {
                          isSigningUp = false;
                        });
                        if (isRegistered) {
                          Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountComplete(
                                  username: nameController.text),
                            ),
                          );
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Email Already Exist'),
                                backgroundColor: Colors.redAccent),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(
                        ScreenUtility.screenWidth * 0.8,
                        ScreenUtility.screenHeight * 0.05,
                      ), // Increase button size
                    ),
                    child: isSigningUp
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                  ),
                ),
                SizedBox(height: ScreenUtility.screenHeight * 0.05),
                Center(
                  child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Sign Up With Google",
                        style: TextStyle(color: Colors.black, fontSize: 22),
                      )),
                ),
                SizedBox(height: ScreenUtility.screenHeight * 0.03),
                Center(
                  child: Row(
                    children: [
                      const SizedBox(width: 100),
                      Image.asset("assets/Icon/FacebookIcon.png"),
                      const SizedBox(width: 10),
                      Image.asset("assets/Icon/googleIcon.png"),
                      const SizedBox(width: 10),
                      Image.asset("assets/Icon/InstagramIcon.png"),
                      const SizedBox(width: 10),
                      Image.asset("assets/Icon/WhatsAppIcon.png"),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
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
