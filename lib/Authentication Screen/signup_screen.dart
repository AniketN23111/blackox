import 'package:blackox/Constants/screen_utility.dart';
import 'package:blackox/Authentication Screen//account_complete.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController emailOtpController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController numberOtpController = TextEditingController();
  EmailOTP myauth = EmailOTP();

  bool isOtpVerified = false;

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
                    height: Screen_utility.screenHeight * 0.17,
                    width: Screen_utility.screenWidth * 0.8,
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
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Enter email address'),
                      EmailValidator(errorText: 'Please correct email filled'),
                    ]).call,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                        suffixIcon: TextButton(
                          onPressed: () async {
                            myauth.setConfig(
                              appEmail: "ox.black.passionit@gmail.com",
                              appName: "BlackOx",
                              userEmail: emailController.text,
                              otpLength: 6,
                              otpType: OTPType
                                  .digitsOnly, // Pass the customized email content
                            );

                            if (await myauth.sendOTP() == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("OTP has been sent"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Oops, OTP send failed"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: const Text("Send Otp"),
                        ),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.lightBlue,
                        ),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      height: Screen_utility.screenHeight * 0.04,
                      width: Screen_utility.screenWidth * 0.4,
                      child: ElevatedButton(
                        onPressed: () async {
                          if ( myauth.verifyOTP(otp: emailOtpController.text) == true) {
                            setState(() {
                              isOtpVerified =true;
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("OTP is verified"),
                              backgroundColor: Colors.green,
                            ));
                          } else {
                            isOtpVerified=false;
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Invalid OTP"),
                              backgroundColor: Colors.red,
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOtpVerified ? Colors.green : Colors.red,
                          minimumSize: Size(
                            Screen_utility.screenWidth * 0.4,
                            Screen_utility.screenWidth * 0.05,
                          ), // Increase button size
                        ),
                        child: const Text(
                          'Verify Otp',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      height: Screen_utility.screenHeight * 0.04,
                      width: Screen_utility.screenWidth * 0.4,
                      child: TextFormField(
                        controller: emailOtpController,
                        decoration: const InputDecoration(
                          hintText: 'Otp',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                        ),
                        enabled: !isOtpVerified,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountComplete(username: nameController.text),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(
                        Screen_utility.screenWidth * 0.8,
                        Screen_utility.screenHeight * 0.05,
                      ), // Increase button size
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                  child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Sign Up With Google",
                        style: TextStyle(color: Colors.black),
                      )),
                ),
                const SizedBox(height: 20),
                Row(
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
