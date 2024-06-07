import 'package:blackox/Constants/screen_utility.dart';
import 'package:blackox/Splash Screen/account_complete.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:postgres/postgres.dart';

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

  bool isOtpVerified = false;
  bool isOtpEnabled = false;
  bool isSigningUp = false;

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
                      });
                    },
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Enter email address'),
                      EmailValidator(errorText: 'Please correct email filled'),
                    ]).call,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                        suffixIcon: TextButton(
                          onPressed: () async {
                            // Check if email already exists in the database
                            bool emailExists = await checkEmailExists(emailController.text);
                            if (emailExists) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Email already exists"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              // Send OTP if email does not exist
                              myauth.setConfig(
                                appEmail: "ox.black.passionit@gmail.com",
                                appName: "BlackOx",
                                userEmail: emailController.text,
                                otpLength: 6,
                                otpType: OTPType.digitsOnly,
                              );

                              if (await myauth.sendOTP() == true) {
                                setState(() {
                                  isOtpEnabled = true;
                                });
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
                SizedBox(height: ScreenUtility.screenHeight * 0.02),
                Row(
                  children: [
                    SizedBox(
                      height: ScreenUtility.screenHeight * 0.04,
                      width: ScreenUtility.screenWidth * 0.4,
                      child: ElevatedButton(
                        onPressed: isOtpEnabled
                            ? () async {
                          if (myauth.verifyOTP(otp: emailOtpController.text) == true) {
                            setState(() {
                              isOtpVerified = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("OTP is verified"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            setState(() {
                              isOtpVerified = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Invalid OTP"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOtpVerified ? Colors.green : Colors.red,
                          minimumSize: Size(
                            ScreenUtility.screenWidth * 0.4,
                            ScreenUtility.screenWidth * 0.05,
                          ), // Increase button size
                        ),
                        child: const Text(
                          'Verify Otp',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(width: ScreenUtility.screenHeight * 0.03),
                    SizedBox(
                      height: ScreenUtility.screenHeight * 0.04,
                      width: ScreenUtility.screenWidth * 0.4,
                      child: TextFormField(
                        controller: emailOtpController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter the 6-digit code';
                          }
                          if (value.length != 6) {
                            return 'Code must be exactly 6 digits';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Otp',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                        ),
                        enabled: isOtpEnabled,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtility.screenHeight * 0.05),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate() && isOtpVerified) {
                        setState(() {
                          isSigningUp = true;
                        });
                        bool isRegistered = await registerUser(
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
                                content: Text(
                                    'Registration failed. Please try again')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Verify OTP and fill all fields correctly."),
                          backgroundColor: Colors.red,
                        ));
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
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtility.screenHeight * 0.05),
                Center(
                  child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Sign Up With Google",
                        style: TextStyle(color: Colors.black),
                      )),
                ),
                SizedBox(height: ScreenUtility.screenHeight * 0.03),
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

  Future<bool> registerUser(
      String name, String password, String email, String number) async {
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

      final result = await connection.execute(
        'INSERT INTO ai.black_ox_user (name, password, email, number) '
            'VALUES (\$1, \$2, \$3, \$4)',
        parameters: [name, password, email, number],
      );
      print(result);
      await connection.close();
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  Future<bool> checkEmailExists(String email) async {
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

      final result = await connection.execute(
        'SELECT COUNT(*) FROM ai.black_ox_user WHERE email = \$1',
        parameters: [email],
      );

      await connection.close();

      // Ensure the result is properly cast to an integer
      if (result.isNotEmpty && result.first.isNotEmpty) {
        int count = result.first[0] as int;
        return count > 0;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking email existence: $e');
      return false;
    }
  }

  bool _validatePassword(String password) {
    // Regular expression to check if password contains at least one letter, one number, and one special character
    final RegExp regex =
    RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return regex.hasMatch(password);
  }
}
