import 'package:fluxa/shared/widgets/app_card.dart';
import 'package:fluxa/shared/widgets/money_text.dart';
import 'package:flutter/material.dart';

class TransactionRow extends StatelessWidget {
  const TransactionRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.trailing,
    this.accentColor,
    this.accentIcon,
    this.accentLabel,
  });

  final String title;
  final String subtitle;
  final double amount;
  final Widget? trailing;
  final Color? accentColor;
  final IconData? accentIcon;
  final String? accentLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = accentColor;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color?.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(22),
          border: color == null
              ? null
              : Border.all(color: color.withValues(alpha: 0.24)),
        ),
        child: Padding(
          padding: color == null ? EdgeInsets.zero : const EdgeInsets.all(10),
          child: Row(
            children: [
              if (color != null && accentIcon != null) ...[
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    accentIcon,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (accentLabel != null && color != null) ...[
                      Text(
                        accentLabel!,
                        style: textTheme.labelMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(title, style: textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(subtitle, style: textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              MoneyText(amount: amount),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
