class CropDetails {
  final String cropCategory;
  final String cropName;
  final int bomId;
  final String bomCode;

  CropDetails({
    required this.cropCategory,
    required this.cropName,
    required this.bomId,
    required this.bomCode,
  });

  factory CropDetails.fromJson(Map<String, dynamic> json) {
    return CropDetails(
        cropCategory: json['croptype'],
        cropName: json['crop'],
        bomId: int.tryParse(json['bomid']) ?? 0,
        bomCode: json['bomcode']);
  }
}
