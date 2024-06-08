import 'package:blackox/Constants/screen_utility.dart';
import 'package:blackox/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  // Variable to hold user data
  List<List<dynamic>>? userData;

  // Variable to track login state
  bool _isLoggingIn = false;

  Future<void> _login() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoggingIn = true; // Set login state to true when login process starts
      });
      try {
        final isValid = await fetchUserCredentials(
          emailController.text.toString(),
          passwordController.text.toString(),
        );

        if (isValid) {
          // Fetch user data after successful login
          userData = await fetchUserData(emailController.text.toString());
          await _storeDetailsInPrefs();
          // Navigate to the page where the user can choose a Device
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // Show error message for invalid credentials
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid username or password')),
          );
        }
      } catch (e) {
        // Handle errors
        // ignore: avoid_print
        print('Login failed: $e');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      } finally {
        setState(() {
          _isLoggingIn = false; // Reset login state to false when login process completes
        });
      }
    }
  }

  Future<void> _storeDetailsInPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
  }

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
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
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
                            borderRadius: BorderRadius.all(Radius.circular(9.0)))),
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
                            borderRadius: BorderRadius.all(Radius.circular(9.0)))),
                  ),
                ),
                SizedBox(height: ScreenUtility.screenHeight * 0.05),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoggingIn ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(
                        ScreenUtility.screenWidth * 0.8,
                        ScreenUtility.screenHeight * 0.05,
                      ), // Increase button size
                    ),
                    child: _isLoggingIn
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      'Log In',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtility.screenHeight * 0.05),
                Center(
                  child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Sign IN With Google",
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

  Future<bool> fetchUserCredentials(String email, String password) async {
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
        'SELECT * FROM ai.black_ox_user WHERE email = \$1 AND password = \$2',
        parameters: [email, password],
      );

      await connection.close();

      // Debug prints
      print('Result: $result');
      print('Result is not empty: ${result.isNotEmpty}');

      return result.isNotEmpty;
    } catch (e) {
      print('Error fetching user credentials: $e');
      return false;
    }
  }

  Future<List<List<dynamic>>> fetchUserData(String email) async {
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
        'SELECT * FROM ai.black_ox_user WHERE email = \$1',
        parameters: [email],
      );

      await connection.close();

      // Debug prints
      print('User Data Result: $result');

      return result;
    } catch (e) {
      print('Error fetching user data: $e');
      return [];
    }
  }

  bool _validatePassword(String password) {
    // Regular expression to check if password contains at least one letter, one number, and one special character
    final RegExp regex =
    RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return regex.hasMatch(password);
  }
}
