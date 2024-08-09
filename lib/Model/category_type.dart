class CategoryType {
  final String categoryName;
  final String color;
  final String imageIcon;

  CategoryType({
    required this.categoryName,
    required this.color,
    required this.imageIcon,
  });

  factory CategoryType.fromJson(Map<String, dynamic> json) {
    return CategoryType(
      categoryName: json['categoryName'],
      color: json['color'],
      imageIcon: json['imageIcon'],
    );
  }
}
