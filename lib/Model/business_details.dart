class BusinessDetails {
  final String uName;
  final String uNumber;
  final String uEmail;
  final String bName;
  final String bAddress;
  final int bPinCode;
  final String bCity;
  final String gstNO;
  final String categoryType;
  final String productName;
  final int rate;
  final String ratePer;
  final String discountRate;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime registerDate;
  final String imageUrl;

  BusinessDetails({
    required this.uName,
    required this.uNumber,
    required this.uEmail,
    required this.bName,
    required this.bAddress,
    required this.bPinCode,
    required this.bCity,
    required this.gstNO,
    required this.categoryType,
    required this.productName,
    required this.rate,
    required this.ratePer,
    required this.discountRate,
    required this.startDate,
    required this.endDate,
    required this.registerDate,
    required this.imageUrl,
  });

  factory BusinessDetails.fromJson(Map<String, dynamic> json) {
    return BusinessDetails(
      uName: json['u_name'],
      uNumber: json['u_number'],
      uEmail: json['u_email'],
      bName: json['b_name'],
      bAddress: json['b_address'],
      bPinCode: json['b_pincode'] ?? 0,
      bCity: json['b_city'],
      gstNO: json['gstno'],
      categoryType: json['category_type'],
      productName: json['product_name'],
      rate: json['rate'] ?? 0,
      ratePer: json['rate_per'],
      discountRate: json['discount_rate'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      registerDate: DateTime.parse(json['register_date']),
      imageUrl: json['image_url'],
    );
  }
}
