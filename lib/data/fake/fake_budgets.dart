import 'package:fluxa/models/budget.dart';

final fakeBudgets = [
  const Budget(
    id: 'budget-market',
    category: 'Mercado',
    periodMonth: 6,
    periodYear: 2026,
    limitAmount: 800,
    usedAmount: 540,
    alertThresholdPercent: 80,
  ),
  const Budget(
    id: 'budget-leisure',
    category: 'Lazer',
    periodMonth: 6,
    periodYear: 2026,
    limitAmount: 300,
    usedAmount: 210,
    alertThresholdPercent: 75,
  ),
];
