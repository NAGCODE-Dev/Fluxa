class PaymentCard {
  const PaymentCard({
    required this.id,
    required this.bankName,
    required this.name,
    required this.maskedNumber,
    required this.limitAmount,
    required this.availableAmount,
    required this.currentInvoice,
    required this.closingLabel,
    required this.dueLabel,
    required this.backgroundColor,
    required this.accentColor,
  });

  final String id;
  final String bankName;
  final String name;
  final String maskedNumber;
  final double limitAmount;
  final double availableAmount;
  final double currentInvoice;
  final String closingLabel;
  final String dueLabel;
  final int backgroundColor;
  final int accentColor;
}
