class SubscriptionModel {
  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.billingCycle,
    required this.nextChargeDate,
    required this.isActive,
    required this.detectionSource,
  });

  final String id;
  final String name;
  final double amount;
  final String billingCycle;
  final DateTime nextChargeDate;
  final bool isActive;
  final String detectionSource;

  double get annualAmount => billingCycle == 'yearly' ? amount : amount * 12;

  SubscriptionModel copyWith({
    String? id,
    String? name,
    double? amount,
    String? billingCycle,
    DateTime? nextChargeDate,
    bool? isActive,
    String? detectionSource,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      billingCycle: billingCycle ?? this.billingCycle,
      nextChargeDate: nextChargeDate ?? this.nextChargeDate,
      isActive: isActive ?? this.isActive,
      detectionSource: detectionSource ?? this.detectionSource,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'billingCycle': billingCycle,
      'nextChargeDate': nextChargeDate.toIso8601String(),
      'isActive': isActive,
      'detectionSource': detectionSource,
    };
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      billingCycle: json['billingCycle'] as String,
      nextChargeDate: DateTime.parse(json['nextChargeDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      detectionSource: json['detectionSource'] as String? ?? 'manual',
    );
  }
}
