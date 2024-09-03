import 'package:blackox/CropCalculator/bom_screen.dart';
import 'package:blackox/Model/crop_details.dart';
import 'package:blackox/Services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';

class CropCalculator extends StatefulWidget {
  const CropCalculator({super.key});

  @override
  State<CropCalculator> createState() => _CropCalculatorState();
}

class _CropCalculatorState extends State<CropCalculator> {
  bool autoMode = false;
  String? _selectedMonth;
  CropDetails? _selectedCrop;
  DatabaseService dbService = DatabaseService();
  late Future<List<CropDetails>> futureCropItems;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateFormat('MMMM').format(DateTime.now());
    futureCropItems = dbService.fetchCropItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<CropDetails>>(
          future: futureCropItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available'));
            } else {
              List<CropDetails> cropItems = snapshot.data!;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Crop Calculator',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          backgroundColor: Colors.yellowAccent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Auto',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black87),
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
                      DropdownButton<CropDetails>(
                        value: _selectedCrop,
                        items: cropItems.map((CropDetails crop) {
                          return DropdownMenuItem<CropDetails>(
                            value: crop,
                            child: Text(crop.cropName),
                          );
                        }).toList(),
                        onChanged: (CropDetails? newValue) {
                          setState(() {
                            _selectedCrop = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Farm Area Type*',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      DropdownButton<String>(
                        items: <String>['Type 1', 'Type 2', 'Type 3']
                            .map((String value) {
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
                        value: _selectedMonth,
                        items:
                            DateFormat().dateSymbols.MONTHS.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedMonth = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Link With Soil Test/ Soil Health Card',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
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
                            if (_selectedCrop != null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BOMScreen(
                                            bomCode: _selectedCrop!.bomCode,
                                            bomId: _selectedCrop!.bomId,
                                          )));
                            } else {
                              // Handle the case where no crop is selected
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a crop'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          child: const Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
