class ExpenseDraft {
  const ExpenseDraft({
    required this.amount,
    required this.category,
    required this.source,
    required this.description,
  });

  final double amount;
  final String category;
  final String source;
  final String description;

  ExpenseDraft copyWith({
    double? amount,
    String? category,
    String? source,
    String? description,
  }) {
    return ExpenseDraft(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      source: source ?? this.source,
      description: description ?? this.description,
    );
  }
}
