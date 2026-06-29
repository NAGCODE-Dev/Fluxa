enum TransactionType { income, expense, transfer }

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.type,
    required this.occuredAt,
    required this.sourceLabel,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final double amount;
  final TransactionType type;
  final DateTime occuredAt;
  final String sourceLabel;
  final String category;

  bool get isPositive => type == TransactionType.income;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'type': type.name,
      'occuredAt': occuredAt.toIso8601String(),
      'sourceLabel': sourceLabel,
      'category': category,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere(
        (value) => value.name == json['type'],
        orElse: () => TransactionType.expense,
      ),
      occuredAt: DateTime.parse(json['occuredAt'] as String),
      sourceLabel: json['sourceLabel'] as String,
      category: json['category'] as String,
    );
  }
}
