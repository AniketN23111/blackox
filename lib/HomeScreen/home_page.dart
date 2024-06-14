import 'package:blackox/Model/business_detials.dart';
import 'package:blackox/Services/database_services.dart'; // Adjust import based on your file structure
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService databaseService = DatabaseService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () {
                    // Handle microphone button press
                  },
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
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
      ),
      body: FutureBuilder<List<BusinessDetails>>(
        future: databaseService.getBusinessDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No business details available'));
          } else {
            final businessDetailsList = snapshot.data!;
            final filteredList = businessDetailsList.where((item) {
              final itemName = item.bName.toLowerCase();
              final searchQuery = _searchQuery.toLowerCase();
              return itemName.contains(searchQuery);
            }).toList();

            return ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Center(child: Text(filteredList[index].bName)),
                  subtitle: Center(child: Text('${filteredList[index].ratePer} - ${filteredList[index].rate}')),
                  onTap: () {
                    // Handle onTap action if needed
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
