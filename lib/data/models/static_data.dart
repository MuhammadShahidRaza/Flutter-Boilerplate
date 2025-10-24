class StaticPageModel {
  final int id;
  final String name;
  final String description;

  StaticPageModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory StaticPageModel.fromJson(Map<String, dynamic> json) {
    return StaticPageModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
