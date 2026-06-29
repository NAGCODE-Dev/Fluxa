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

  PaymentCard copyWith({
    String? id,
    String? bankName,
    String? name,
    String? maskedNumber,
    double? limitAmount,
    double? availableAmount,
    double? currentInvoice,
    String? closingLabel,
    String? dueLabel,
    int? backgroundColor,
    int? accentColor,
  }) {
    return PaymentCard(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      name: name ?? this.name,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      limitAmount: limitAmount ?? this.limitAmount,
      availableAmount: availableAmount ?? this.availableAmount,
      currentInvoice: currentInvoice ?? this.currentInvoice,
      closingLabel: closingLabel ?? this.closingLabel,
      dueLabel: dueLabel ?? this.dueLabel,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankName': bankName,
      'name': name,
      'maskedNumber': maskedNumber,
      'limitAmount': limitAmount,
      'availableAmount': availableAmount,
      'currentInvoice': currentInvoice,
      'closingLabel': closingLabel,
      'dueLabel': dueLabel,
      'backgroundColor': backgroundColor,
      'accentColor': accentColor,
    };
  }

  factory PaymentCard.fromJson(Map<String, dynamic> json) {
    return PaymentCard(
      id: json['id'] as String,
      bankName: json['bankName'] as String,
      name: json['name'] as String,
      maskedNumber: json['maskedNumber'] as String,
      limitAmount: (json['limitAmount'] as num).toDouble(),
      availableAmount: (json['availableAmount'] as num).toDouble(),
      currentInvoice: (json['currentInvoice'] as num).toDouble(),
      closingLabel: json['closingLabel'] as String,
      dueLabel: json['dueLabel'] as String,
      backgroundColor: json['backgroundColor'] as int,
      accentColor: json['accentColor'] as int,
    );
  }
}
