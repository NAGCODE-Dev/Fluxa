class Budget {
  const Budget({
    required this.id,
    required this.category,
    required this.periodMonth,
    required this.periodYear,
    required this.limitAmount,
    required this.usedAmount,
    required this.alertThresholdPercent,
  });

  final String id;
  final String category;
  final int periodMonth;
  final int periodYear;
  final double limitAmount;
  final double usedAmount;
  final double alertThresholdPercent;

  double get remainingAmount => limitAmount - usedAmount;
  double get usageProgress => limitAmount == 0 ? 0 : usedAmount / limitAmount;
  bool get isNearLimit => usageProgress >= (alertThresholdPercent / 100);

  Budget copyWith({
    String? id,
    String? category,
    int? periodMonth,
    int? periodYear,
    double? limitAmount,
    double? usedAmount,
    double? alertThresholdPercent,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      periodMonth: periodMonth ?? this.periodMonth,
      periodYear: periodYear ?? this.periodYear,
      limitAmount: limitAmount ?? this.limitAmount,
      usedAmount: usedAmount ?? this.usedAmount,
      alertThresholdPercent:
          alertThresholdPercent ?? this.alertThresholdPercent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'periodMonth': periodMonth,
      'periodYear': periodYear,
      'limitAmount': limitAmount,
      'usedAmount': usedAmount,
      'alertThresholdPercent': alertThresholdPercent,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      category: json['category'] as String,
      periodMonth: json['periodMonth'] as int,
      periodYear: json['periodYear'] as int,
      limitAmount: (json['limitAmount'] as num).toDouble(),
      usedAmount: (json['usedAmount'] as num).toDouble(),
      alertThresholdPercent:
          (json['alertThresholdPercent'] as num?)?.toDouble() ?? 80,
    );
  }
}
