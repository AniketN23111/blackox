import 'package:blackox/Constants/screen_utility.dart';
import 'package:blackox/HomeScreen/account_page.dart';
import 'package:blackox/HomeScreen/add_page.dart';
import 'package:blackox/HomeScreen/categories_page.dart';
import 'package:blackox/HomeScreen/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:blackox/HomeScreen/home_page.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _currentTime = '';
  String _currentDate = '';
  late Timer _timer;

  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CategoriesPage(),
    AddPage(),
    NotificationPage(),
    AccountPage(),
  ];

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 60), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final formattedTime = DateFormat('hh:mm a').format(now); // 12-hour format with AM/PM
    final formattedDate = DateFormat('MMM d, yyyy').format(now); // Date format
    setState(() {
      _currentTime = formattedTime;
      _currentDate = formattedDate;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                Text('$_currentDate $_currentTime', style: TextStyle(fontSize: 16)),
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
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
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
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
