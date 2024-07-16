class WeddingBudget {
  final int id;
  final int weddingId;
  final int categoryId;
  final double amount;
  final double amountPaid;
  final bool paid;

  WeddingBudget({
    required this.id,
    required this.weddingId,
    required this.categoryId,
    required this.amount,
    this.amountPaid = 0,
    this.paid = false,
  });

  factory WeddingBudget.fromJson(Map<String, dynamic> json) {
    return WeddingBudget(
      id: json['id'],
      weddingId: json['wedding_id'],
      categoryId: json['category_id'],
      amount: (json['amount'] as num).toDouble(),
      amountPaid: (json['amount_paid'] as num).toDouble(),
      paid: json['paid'] ?? false, // Default to false if not provided
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wedding_id': weddingId,
      'category_id': categoryId,
      'amount': amount,
      'amount_paid': amountPaid,
      'paid': paid,
    };
  }
}
