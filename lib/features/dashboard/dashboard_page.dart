import 'package:financas/core/extensions/money_extension.dart';
import 'package:financas/core/extensions/string_extension.dart';
import 'package:financas/core/theme/colors.dart';
import 'package:financas/core/theme/spacing.dart';
import 'package:financas/models/dashboard_summary.dart';
import 'package:financas/shared/widgets/app_card.dart';
import 'package:financas/shared/widgets/metric_tile.dart';
import 'package:financas/shared/widgets/section_heading.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.displayName,
    required this.summary,
  });

  final String displayName;
  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final name = displayName.orFallback('você');
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
      children: [
        SectionHeading(
          eyebrow: 'Início',
          title: 'Olá, $name',
          description:
              'Uma visão rápida do que importa agora, sem exigir rolagem crítica ou leitura excessiva.',
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
                '+ ${summary.monthSavings.toMoney()} de economia no mês',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.success,
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
                mainAxisExtent: 134,
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
