// Assume DatabaseService class in database_services.dart
import 'package:flutter/material.dart';
import 'package:blackox/Model/business_details.dart';
import 'package:blackox/Model/category_type.dart';
import 'package:blackox/Services/database_services.dart'; // Assuming DatabaseService is imported correctly
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService databaseService = DatabaseService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  List<CategoryType> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await databaseService.getCategoryType(); // Adjust method name according to your implementation
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      // Handle error appropriately
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: const TextStyle(fontSize: 22),
            border: InputBorder.none,
            prefixIcon: IconButton(
              onPressed: () {
                // Handle Search Button press
              },
              icon: const Icon(Icons.search, size: 30),
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    // Handle microphone button press
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    // Handle camera button press
                  },
                ),
              ],
            ),
          ),
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showCategoryFilterDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedCategory != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    _selectedCategory!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: FutureBuilder<List<BusinessDetails>>(
              future: databaseService.getBusinessDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No business details available'));
                } else {
                  final businessDetailsList = snapshot.data!;
                  final filteredList = businessDetailsList.where((item) {
                    final itemName = item.bName.toLowerCase();
                    final searchQuery = _searchQuery.toLowerCase();
                    final matchesSearchQuery = itemName.contains(searchQuery);
                    final matchesCategory = _selectedCategory == null ||
                        item.categoryType == _selectedCategory;
                    return matchesSearchQuery && matchesCategory;
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      // Fetch color string for category
                      final categoryColorString = _getCategoryColorString(filteredList[index].categoryType);
                      final categoryIconString = _getCategoryIconString(filteredList[index].categoryType);

                      print('Category: ${filteredList[index].categoryType}, Color: $categoryColorString');
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(int.tryParse(categoryColorString) ?? 0xFFFFFFFF), // Convert color string to Color object
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Center(
                            child: Text(
                              filteredList[index].bName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          subtitle: Center(
                            child: Text(
                              '${filteredList[index].ratePer} - ${filteredList[index].rate}₹',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.phone),
                            onPressed: () {
                              _showPhoneNumber(context, filteredList[index].uNumber);
                            },
                          ),
                          onTap: () {
                            // Handle onTap action if needed
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: categoryIconString.isNotEmpty ? Image.network(categoryIconString) : Icon(Icons.category),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryColorString(String categoryType) {
    final category = _categories.firstWhere(
            (element) => element.categoryName == categoryType,
        orElse: () => CategoryType(categoryName: categoryType, color: '#000000', imageIcon: '')
    );

    String colorString = category.color;

    // Extract hexadecimal color value from Color(0xffa00beb) format
    if (colorString.startsWith('Color(') && colorString.endsWith(')')) {
      colorString = colorString.substring(6, colorString.length - 1); // Remove 'Color(' and ')'
    }

    return colorString;
  }


  String _getCategoryIconString(String categoryType) {
    final category = _categories.firstWhere((element) => element.categoryName == categoryType, orElse: () => CategoryType(categoryName: categoryType, color: '#000000', imageIcon: ''));
    return category.imageIcon;
  }

  void _showCategoryFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Category"),
          content: DropdownButton<String>(
            isExpanded: true,
            value: _selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
              });
              Navigator.of(context).pop();
            },
            items: <String>[
              'All Categories',
              ..._categories.map((category) => category.categoryName),
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showPhoneNumber(BuildContext context, String phoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Phone Number"),
          content: Text(phoneNumber),
          actions: [
            TextButton(
              child: const Text("Call"),
              onPressed: () async {
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: phoneNumber,
                );
                await launchUrl(launchUri);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
