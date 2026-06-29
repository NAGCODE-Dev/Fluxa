import 'package:financas/core/extensions/money_extension.dart';
import 'package:financas/core/theme/spacing.dart';
import 'package:financas/models/card.dart';
import 'package:financas/shared/widgets/app_card.dart';
import 'package:financas/shared/widgets/bank_card_widget.dart';
import 'package:financas/shared/widgets/empty_state.dart';
import 'package:financas/shared/widgets/section_heading.dart';
import 'package:flutter/material.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({
    super.key,
    required this.cards,
  });

  final List<PaymentCard> cards;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const EmptyState(
        title: 'Nenhum cartão cadastrado',
        message: 'Os cartões aparecem aqui com identidade visual leve e final mascarado.',
      );
    }

    final primaryCard = cards.first;
    final secondaryCards = cards.skip(1).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
      children: [
        const SectionHeading(
          eyebrow: 'Cartões',
          title: 'Uso de crédito sem expor dados sensíveis',
          description:
              'Os cartões são apresentados por skin visual e final mascarado. Nada aqui depende de número completo ou CVV.',
        ),
        const SizedBox(height: AppSpacing.xl),
        BankCardWidget(card: primaryCard),
        const SizedBox(height: AppSpacing.lg - 2),
        Row(
          children: [
            for (final card in secondaryCards)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: card == secondaryCards.first ? 8 : 0,
                    left: card == secondaryCards.last ? 8 : 0,
                  ),
                  child: BankCardWidget(
                    card: card,
                    compact: true,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg - 2),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalhes rápidos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              _InfoRow(label: 'Fechamento', value: primaryCard.closingLabel),
              const SizedBox(height: 10),
              _InfoRow(label: 'Vencimento', value: primaryCard.dueLabel),
              const SizedBox(height: 10),
              _InfoRow(
                label: 'Fatura atual',
                value: primaryCard.currentInvoice.toMoney(),
              ),
            ],
          ),
        ),
      ],
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
        Expanded(child: Text(label)),
        Text(
          value,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}
