import 'package:blackox/Model/bom_item.dart';
import 'package:blackox/Services/database_services.dart';
import 'package:flutter/material.dart';

class BOMScreen extends StatefulWidget {
  final List<Map<String, String>> bomData; // List of BOM data
  final String name;

  const BOMScreen({
    super.key,
    required this.bomData,
    required this.name,
  });

  @override
  State<BOMScreen> createState() => _BOMScreenState();
}

class _BOMScreenState extends State<BOMScreen> {
  late List<Future<List<BOMItem>>> futureBOMItemsList;
  DatabaseService dbService = DatabaseService();
  late String? cropName = '';

  @override
  void initState() {
    super.initState();
    // Create a list of futures for each BOM data
    futureBOMItemsList = widget.bomData.map((bom) {
      return dbService.fetchBOMItems(bom['bomCode']!, bom['bomId']!);
    }).toList();
    cropName = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$cropName - Bill of Materials'),
      ),
      body: ListView.builder(
        itemCount: futureBOMItemsList.length,
        itemBuilder: (context, index) {
          return FutureBuilder<List<BOMItem>>(
            future: futureBOMItemsList[index],
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available'));
              } else {
                final bomItems = snapshot.data!;
                double totalProductionCost =
                    bomItems.fold(0, (sum, item) => sum + item.totalCost);
                double seedsSubsidy =
                    bomItems.fold(0, (sum, item) => sum + item.subsidy);
                double finalProductionCost = totalProductionCost - seedsSubsidy;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBOMHeader(index),
                    ..._buildItemRows(bomItems),
                    const SizedBox(height: 16),
                    _buildCostSummary(
                        totalProductionCost, seedsSubsidy, finalProductionCost),
                    const Divider(),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildBOMHeader(int index) {
    // Assuming bomData contains a description or name of the BOM
    String? bomName = widget.bomData[index]['crop'];

    return Container(
      color: Colors.blueAccent.withOpacity(0.1),
      padding: const EdgeInsets.all(8.0),
      child: Text(
        bomName!, // Use the BOM name here
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  List<Widget> _buildItemRows(List<BOMItem> bomItems) {
    return List.generate(bomItems.length, (index) {
      final item = bomItems[index];
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: index % 2 == 0
              ? Colors.blueAccent.withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: Text('${index + 1}')),
            Expanded(flex: 3, child: Text(item.itemName)),
            Expanded(child: Text('${item.qty} ${item.uom}')),
            Expanded(child: Text('₹ ${item.totalCost}')),
          ],
        ),
      );
    });
  }

  Widget _buildCostSummary(double totalProductionCost, double seedsSubsidy,
      double finalProductionCost) {
    return Container(
      color: Colors.redAccent.withOpacity(0.2),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          _buildSummaryRow('Total Production Cost:', totalProductionCost),
          _buildSummaryRow('Subsidy:', seedsSubsidy, isSubsidy: true),
          const SizedBox(height: 8),
          _buildSummaryRow('Final Production Cost:', finalProductionCost,
              isFinalCost: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount,
      {bool isSubsidy = false, bool isFinalCost = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isFinalCost ? 20 : 18,
            fontWeight: isFinalCost ? FontWeight.bold : FontWeight.normal,
            color: isSubsidy ? Colors.green : Colors.black,
          ),
        ),
        Text(
          '${isSubsidy ? '- ' : ''}₹ ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isFinalCost ? 20 : 18,
            fontWeight: isFinalCost ? FontWeight.bold : FontWeight.normal,
            color: isSubsidy
                ? Colors.green
                : (isFinalCost ? Colors.green : Colors.black),
          ),
        ),
      ],
    );
  }
}
