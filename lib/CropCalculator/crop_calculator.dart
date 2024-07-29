import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class CropCalculator extends StatefulWidget {
  const CropCalculator({super.key});

  @override
  State<CropCalculator> createState() => _CropCalculatorState();
}

class _CropCalculatorState extends State<CropCalculator> {
  bool autoMode = false;
  TextEditingController _dateController = TextEditingController();
  String _currentDate = '';

  // Weather variables
  String? _weatherLocation = 'Nashik';
  String? _weatherCondition = 'Clear';
  double? _weatherTemperature = 24.0;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd MMM yyyy').format(now); // Date format
    setState(() {
      _currentDate = formattedDate;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Crop Calculator',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87, backgroundColor: Colors.yellowAccent),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Auto',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  FlutterSwitch(
                    width: 55.0,
                    height: 25.0,
                    valueFontSize: 12.0,
                    toggleSize: 18.0,
                    value: autoMode,
                    onToggle: (val) {
                      setState(() {
                        autoMode = val;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Crop Name*',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              DropdownButton<String>(
                items: <String>['Wheat', 'Rice', 'Maize'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: 16),
              const Text(
                'Farm Area Type*',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              DropdownButton<String>(
                items: <String>['Type 1', 'Type 2', 'Type 3'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: 16),
              const Text(
                'Sowing Area*',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Sowing Area',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pincode*',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Pincode',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sowing Month*',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              DropdownButton<String>(
                items: <String>['January', 'February', 'March'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: 16),
              const Text(
                'Sowing Date',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Select Sowing Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Link With Soil Test/ Soil Health Card',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  FlutterSwitch(
                    width: 55.0,
                    height: 25.0,
                    valueFontSize: 12.0,
                    toggleSize: 18.0,
                    value: autoMode,
                    onToggle: (val) {
                      setState(() {
                        autoMode = val;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Farm land Mapping',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: Text('Map Placeholder')),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle continue action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
