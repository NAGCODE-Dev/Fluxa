import 'package:financas/core/extensions/date_extension.dart';
import 'package:financas/core/theme/spacing.dart';
import 'package:financas/models/transaction.dart';
import 'package:financas/shared/widgets/app_input.dart';
import 'package:financas/shared/widgets/empty_state.dart';
import 'package:financas/shared/widgets/section_heading.dart';
import 'package:financas/shared/widgets/transaction_row.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    super.key,
    required this.transactions,
  });

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const EmptyState(
        title: 'Nenhuma movimentação ainda',
        message: 'Quando você registrar receitas ou gastos, o histórico aparece aqui.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
      children: [
        const SectionHeading(
          eyebrow: 'Histórico',
          title: 'Para onde seu dinheiro foi',
          description:
              'Busca, filtros rápidos e leitura direta da movimentação sem ruído visual.',
        ),
        const SizedBox(height: AppSpacing.xl),
        const AppInput(
          hint: 'Buscar mercado, uber, salário...',
          prefixIcon: Icon(Icons.search_rounded),
        ),
        const SizedBox(height: AppSpacing.lg - 2),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            Chip(label: Text('Mês atual')),
            Chip(label: Text('Cartões')),
            Chip(label: Text('Mercado')),
          ],
        ),
        const SizedBox(height: 18),
        ...transactions.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TransactionRow(
                title: item.title,
                subtitle: '${item.occuredAt.toShortPtBr()} • ${item.sourceLabel}',
                amount: item.amount,
              ),
            )),
      ],
    );
  }
}
