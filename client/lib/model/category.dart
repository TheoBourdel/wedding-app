class Category {
  final int? id;
  final String name;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Category({
    this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['ID'] as int?,
      name: json['Name'] as String,
      createdAt: json['CreatedAt'] as String?,
      updatedAt: json['UpdatedAt'] as String?,
      deletedAt: json['DeletedAt'] as String?,
    );
  }
}