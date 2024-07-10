class WeddingBudget {
  final int id;
  final int weddingId;
  final int categoryId;
  final double amount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  WeddingBudget({
    required this.id,
    required this.weddingId,
    required this.categoryId,
    required this.amount,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory WeddingBudget.fromJson(Map<String, dynamic> json) {
    return WeddingBudget(
      id: json['id'],
      weddingId: json['wedding_id'],
      categoryId: json['category_id'],
      amount: (json['amount'] as num).toDouble(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wedding_id': weddingId,
      'category_id': categoryId,
      'amount': amount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
