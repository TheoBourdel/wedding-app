class Favorite {
  final int? id;
  final int UserID;
  final int? ServiceID;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Favorite({
    this.id,
    required this.UserID,
    required this.ServiceID,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['ID'] as int?,
      UserID: json['UserID'] as int,
      ServiceID: json['ServiceID'] as int?,
      createdAt: json['CreatedAt'] as String?,
      updatedAt: json['UpdatedAt'] as String?,
      deletedAt: json['DeletedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id.toString(),
      'UserID': UserID.toString(),
      'ServiceID': ServiceID.toString(),
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt,
      'DeletedAt': deletedAt,
    };
  }
}