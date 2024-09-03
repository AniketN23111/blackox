class BOMItem {
  final String itemCategory;
  final String itemName;
  final int qty;
  final int rate;
  final String uom;
  final int totalCost;
  final int subsidy;

  BOMItem({
    required this.itemCategory,
    required this.itemName,
    required this.qty,
    required this.rate,
    required this.uom,
    required this.totalCost,
    required this.subsidy,
  });

  factory BOMItem.fromJson(Map<String, dynamic> json) {
    return BOMItem(
      itemCategory: json['item_category'],
      itemName: json['item_name'],
      qty: int.tryParse(json['quantity']) ?? 0,
      rate: int.tryParse(json['rate_per_unit']) ?? 0,
      uom: json['uom'],
      totalCost: int.tryParse(json['total_cost']) ?? 0,
      subsidy: int.tryParse(json['subsidyamount']) ?? 0,
    );
  }
}
