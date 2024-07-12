class WeddingBudget {
  final int id;
  final int weddingId;
  final int categoryId;
  final double amount;

  WeddingBudget({
    required this.id,
    required this.weddingId,
    required this.categoryId,
    required this.amount,
  });

  factory WeddingBudget.fromJson(Map<String, dynamic> json) {
    return WeddingBudget(
      id: json['id'],
      weddingId: json['wedding_id'],
      categoryId: json['category_id'],
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wedding_id': weddingId,
      'category_id': categoryId,
      'amount': amount,
    };
  }
}
