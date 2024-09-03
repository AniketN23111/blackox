import 'package:blackox/Model/bom_item.dart';
import 'package:blackox/Services/database_services.dart';
import 'package:flutter/material.dart';

class BOMScreen extends StatefulWidget {
  final String bomCode;
  final int bomId;

  const BOMScreen({super.key, required this.bomCode, required this.bomId});

  @override
  State<BOMScreen> createState() => _BOMScreenState();
}

class _BOMScreenState extends State<BOMScreen> {
  late Future<List<BOMItem>> futureBOMItems;
  DatabaseService dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    futureBOMItems = dbService.fetchBOMItems(widget.bomCode, widget.bomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill of Material'),
      ),
      body: FutureBuilder<List<BOMItem>>(
        future: futureBOMItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            // List of BOM items
            final bomItems = snapshot.data!;

            // Calculate total production cost
            double totalProductionCost =
                bomItems.fold(0, (sum, item) => sum + item.totalCost);

            double seedsSubsidy =
                bomItems.fold(0, (sum, item) => sum + item.subsidy);

            double finalProductionCost = totalProductionCost - seedsSubsidy;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      color: Colors.blueAccent.withOpacity(0.1),
                      padding: const EdgeInsets.all(8.0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              child: Text('No.',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 3,
                              child: Text('Items',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(
                              child: Text('Units',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(
                              child: Text('Cost',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                  ),

                  // Table Rows
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bomItems.length,
                    itemBuilder: (context, index) {
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
                            Expanded(child: Text('${item.totalCost}₹')),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  Container(
                    color: Colors.redAccent.withOpacity(0.2),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Production Cost:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('₹ ${totalProductionCost.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subsidy:',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.green)),
                            Text('- ₹ ${seedsSubsidy.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.green)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Final Production Cost:',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('₹ ${finalProductionCost.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
