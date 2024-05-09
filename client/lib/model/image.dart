class Image {
  final int? id;
  final String? path;
  final int? ServiceID;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Image({
    this.id,
    required this.path,
    required this.ServiceID,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['ID'] as int?,
      path: json['Path'] as String?,
      ServiceID: json['ServiceID'] as int?,
      createdAt: json['CreatedAt'] as String?,
      updatedAt: json['UpdatedAt'] as String?,
      deletedAt: json['DeletedAt'] as String?,
    );
  }
}