import 'package:blackox/HomeScreen/account_page_navigator.dart';
import 'package:blackox/HomeScreen/add_page_navigator.dart';
import 'package:blackox/HomeScreen/categories_page_navigator.dart';
import 'package:blackox/HomeScreen/notification_page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:blackox/Constants/screen_utility.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'home_page_navigator.dart';

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

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeNavigator(),
    const CategoriesPageNavigator(),
    const AddPageNavigator(),
    const NotificationPageNavigator(),
    const AccountPageNavigator(),
  ];

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
    final formattedDate = DateFormat('MMM d, yyyy').format(now); // Date format
    setState(() {
      _currentDate = formattedDate;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    ),
                    SizedBox(width: ScreenUtility.screenWidth * 0.01),
                    Image.asset('assets/Icon/My Location.png'),
                    SizedBox(width: ScreenUtility.screenWidth * 0.01),
                    Text(
                      '$_weatherLocation',
                      style: const TextStyle(fontSize: 20),
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
          children: const <Widget>[
            DrawerHeader(
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
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions.map((widget) => widget ?? Container()).toList(),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildNavBarItem(Icons.home, 'Home', 0),
            _buildNavBarItem(Icons.list, 'Categories', 1),
            _buildNavBarItem(Icons.add_circle, 'Add', 2),
            _buildNavBarItem(Icons.notifications, 'Notifications', 3),
            _buildNavBarItem(Icons.account_circle, 'Account', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        _onItemTapped(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.amber[800]),
          Text(label,
              style: TextStyle(
                color: _selectedIndex == index ? Colors.amber[800] : Colors.black,
              )),
        ],
      ),
    );
  }
}
