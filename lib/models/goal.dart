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
}
