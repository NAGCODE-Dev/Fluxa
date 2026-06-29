class Goal {
  const Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.estimatedLabel,
  });

  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String estimatedLabel;

  double get progress => targetAmount == 0 ? 0 : currentAmount / targetAmount;

  Goal copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    String? estimatedLabel,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      estimatedLabel: estimatedLabel ?? this.estimatedLabel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'estimatedLabel': estimatedLabel,
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      estimatedLabel: json['estimatedLabel'] as String,
    );
  }
}
