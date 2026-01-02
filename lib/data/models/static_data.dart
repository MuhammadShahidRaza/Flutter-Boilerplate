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
    final dynamic payload = json['data'];
    final Map<String, dynamic> resolved = payload is Map
        ? Map<String, dynamic>.from(payload)
        : json;

    return StaticPageModel(
      id: resolved['id'] ?? 0,
      name: resolved['name'] ?? '',
      description: resolved['description'] ?? '',
    );
  }
}
