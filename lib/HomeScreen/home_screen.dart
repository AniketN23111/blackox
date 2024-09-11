import 'package:blackox/Authentication%20Screen/authentication_screen.dart';
import 'package:blackox/Constants/screen_utility.dart';
import 'package:flutter/material.dart';
import 'package:blackox/Navigator/NavigatorAccountPage/account_page.dart';
import 'package:blackox/Navigator/NavigatorAddPage/add_page.dart';
import 'package:blackox/Navigator/NavigatorCategories/categories_page.dart';
import 'package:blackox/Navigator/NavigatorHome/home_page.dart';
import 'package:blackox/Navigator/NavigatorNotification/notification_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _currentDate = '';
  late Timer _timer;

  // Weather variables
  String? _weatherLocation = 'Unknown';
  String? _weatherCondition = 'Unknown';
  double? _weatherTemperature;

  // Location variables
  Position? _currentPosition;

  // PageController for managing tab views
  final PageController _pageController = PageController();

  // Pages for each tab
  final List<Widget> _pages = [
    const HomePage(),
    const CategoriesPage(),
    const AddPage(),
    const NotificationPage(),
    const AccountPage(),
  ];

  // Manage visibility of navigation bar
  bool _showBottomNavBar = true;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 60), (Timer t) => _updateTime());
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showErrorDialog('Location services are disabled.');
      return;
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      _showErrorDialog(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _showErrorDialog(
            'Location permissions are denied (actual value: $permission).');
        return;
      }
    }

    // Get the current location
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _currentPosition = position;
      });
      _fetchWeather();
    } catch (e) {
      print("Failed to get location: $e");
    }
  }

  Future<void> _fetchWeather() async {
    if (_currentPosition != null) {
      double lat = _currentPosition!.latitude;
      double lon = _currentPosition!.longitude;
      await _fetchCityName(lat, lon);
      _fetchWeatherData(lat, lon);
    }
  }

  Future<void> _fetchCityName(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        setState(() {
          _weatherLocation = placemarks[0].locality;
        });
      }
    } catch (e) {
      print('Error fetching city name: $e');
    }
  }

  Future<void> _fetchWeatherData(double lat, double lon) async {
    String apiUrl = 'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true';

    try {
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var weatherData = jsonResponse['current_weather'];

        setState(() {
          _weatherCondition = weatherData['weathercode'].toString();
          _weatherTemperature = weatherData['temperature'];
        });
      } else {
        print('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _updateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('MMM d').format(now); // Date format
    setState(() {
      _currentDate = formattedDate;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex == 0) {
      return true;
    } else {
      _onItemTapped(0); // Navigate to the first tab
      return false;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    // Perform logout logic here
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
          (Route<dynamic> route) => false, // Remove all routes
    );
    setState(() {
     // _showBottomNavBar = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/Images/BlackOxLogo.png",
                height: ScreenUtility.screenHeight * 0.07,
                fit: BoxFit.contain,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_weatherLocation != null &&
                      _weatherCondition != null &&
                      _weatherTemperature != null)
                    Text(
                      '$_weatherTemperature°C',
                      style: const TextStyle(fontSize: 26),
                    ),
                  Row(
                    children: [
                      Text(
                        _currentDate,
                        style: const TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: ScreenUtility.screenWidth * 0.01),
                      Image.asset('assets/Icon/My Location.png'),
                      SizedBox(width: ScreenUtility.screenWidth * 0.01),
                      Text(
                        '$_weatherLocation',
                        style: const TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false, // This removes the back button
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.message),
                title: Text('Messages'),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Profile'),
                onTap: () {
                  _onItemTapped(4); // Navigate to Account Page
                },
              ),
              const ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () {
                  _handleLogout(); // Handle logout
                },
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: _showBottomNavBar
            ? BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.orange,
          onTap: _onItemTapped,
        )
            : null,
      ),
    );
  }
}
