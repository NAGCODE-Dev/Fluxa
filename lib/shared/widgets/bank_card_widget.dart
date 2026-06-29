import 'package:fluxa/core/extensions/money_extension.dart';
import 'package:fluxa/core/theme/radius.dart';
import 'package:fluxa/core/theme/spacing.dart';
import 'package:fluxa/models/card.dart';
import 'package:flutter/material.dart';

class BankCardWidget extends StatelessWidget {
  const BankCardWidget({
    super.key,
    required this.card,
    this.compact = false,
  });

  final PaymentCard card;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? AppSpacing.lg : AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(compact ? 20 : AppRadius.xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(card.backgroundColor),
            Color(card.backgroundColor).withValues(alpha: 0.92),
            Color(card.accentColor).withValues(alpha: 0.72),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            compact ? card.bankName : card.name,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            card.bankName,
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 18 : 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            card.maskedNumber,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
            ),
          ),
          if (!compact) ...[
            const SizedBox(height: AppSpacing.lg),
            _InfoRow(label: 'Limite total', value: card.limitAmount.toMoney()),
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              label: 'Disponível',
              value: card.availableAmount.toMoney(),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
