class Budget {
  const Budget({
    required this.id,
    required this.category,
    required this.limitAmount,
    required this.usedAmount,
  });

  final String id;
  final String category;
  final double limitAmount;
  final double usedAmount;

  double get remainingAmount => limitAmount - usedAmount;
}
