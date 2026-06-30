import 'package:fluxa/core/extensions/money_extension.dart';
import 'package:fluxa/core/extensions/string_extension.dart';
import 'package:fluxa/core/theme/colors.dart';
import 'package:fluxa/core/theme/spacing.dart';
import 'package:fluxa/models/account.dart';
import 'package:fluxa/models/card.dart';
import 'package:fluxa/models/dashboard_summary.dart';
import 'package:fluxa/shared/widgets/app_card.dart';
import 'package:fluxa/shared/widgets/metric_tile.dart';
import 'package:fluxa/shared/widgets/section_heading.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.displayName,
    required this.summary,
    required this.accounts,
    required this.cards,
    this.headerAction,
  });

  final String displayName;
  final DashboardSummary summary;
  final List<Account> accounts;
  final List<PaymentCard> cards;
  final Widget? headerAction;

  @override
  Widget build(BuildContext context) {
    final name = displayName.orFallback('você');
    final savingsIsPositive = summary.monthSavings >= 0;
    final savingsPrefix = savingsIsPositive ? '+' : '-';
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
      children: [
        SectionHeading(
          eyebrow: 'Início',
          title: 'Olá, $name',
          trailing: headerAction,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saldo atual',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.sm + 2),
              Text(
                summary.currentBalance.toMoney(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '$savingsPrefix ${summary.monthSavings.abs().toMoney()} ${savingsIsPositive ? 'de economia' : 'de saída'} no mês',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: savingsIsPositive
                          ? AppColors.success
                          : AppColors.danger,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg - 2),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 760 ? 2 : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                mainAxisExtent: 152,
              ),
              itemCount: summary.metrics.length,
              itemBuilder: (context, index) {
                return MetricTile(metric: summary.metrics[index]);
              },
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg - 2),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estrutura financeira',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              _QuickStatRow(
                label: 'Contas',
                value: '${accounts.length} ativa${accounts.length == 1 ? '' : 's'}',
                caption: accounts.isEmpty
                    ? 'Cadastre uma conta para registrar gastos no fluxo local.'
                    : 'Saldo combinado ${accounts.fold<double>(0, (sum, account) => sum + account.balance).toMoney()}',
              ),
              const SizedBox(height: 12),
              _QuickStatRow(
                label: 'Cartões',
                value: '${cards.length} cadastrado${cards.length == 1 ? '' : 's'}',
                caption: cards.isEmpty
                    ? 'Nenhum cartão salvo ainda.'
                    : 'Fatura atual ${summary.totalCurrentInvoice.toMoney()}',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg - 2),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Próximos eventos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              ...summary.agenda.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(child: Text(item.label)),
                        Text(
                          item.dueLabel,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickStatRow extends StatelessWidget {
  const _QuickStatRow({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 2),
        Text(caption, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
