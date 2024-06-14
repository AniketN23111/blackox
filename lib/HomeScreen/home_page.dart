import 'package:blackox/Model/business_details.dart';
import 'package:blackox/Services/database_services.dart'; // Adjust import based on your file structure
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService databaseService = DatabaseService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;

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
            border: InputBorder.none,
            prefixIcon: IconButton(
              onPressed: () {
                // Handle Search Button press
              },
              icon: const Icon(Icons.search),
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
                      return ListTile(
                        title: Center(child: Text(filteredList[index].bName)),
                        subtitle: Center(
                            child: Text(
                                '${filteredList[index].ratePer} - ${filteredList[index].rate}')),
                        onTap: () {
                          // Handle onTap action if needed
                        },
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
              'Seed Suppliers',
              'Labour',
              'Machinery Rental',
              'Seller',
              // Add more categories as needed
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
}
