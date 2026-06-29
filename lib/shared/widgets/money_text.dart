import 'package:financas/core/extensions/money_extension.dart';
import 'package:financas/core/theme/colors.dart';
import 'package:flutter/material.dart';

class MoneyText extends StatelessWidget {
  const MoneyText({
    super.key,
    required this.amount,
    this.positiveColor,
    this.negativeColor,
    this.style,
  });

  final double amount;
  final Color? positiveColor;
  final Color? negativeColor;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final isPositive = amount >= 0;
    final color = isPositive
        ? positiveColor ?? AppColors.success
        : negativeColor ?? AppColors.danger;

    return Text(
      amount.toMoney(),
      style: style?.copyWith(color: color) ??
          Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
    );
  }
}
