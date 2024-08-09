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
      uName: json['uName'],
      uNumber: json['uNumber'],
      uEmail: json['uEmail'],
      bName: json['bName'],
      bAddress: json['bAddress'],
      bPinCode: json['bPinCode'],
      bCity: json['bCity'],
      gstNO: json['gstNO'],
      categoryType: json['categoryType'],
      productName: json['productName'],
      rate: json['rate'],
      ratePer: json['ratePer'],
      discountRate: json['discountRate'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      registerDate: DateTime.parse(json['registerDate']),
      imageUrl: json['imageUrl'],
    );
  }
}
