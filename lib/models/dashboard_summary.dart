class DashboardMetric {
  const DashboardMetric({
    required this.label,
    required this.valueLabel,
    required this.caption,
  });

  final String label;
  final String valueLabel;
  final String caption;
}

class DashboardAgendaItem {
  const DashboardAgendaItem({
    required this.label,
    required this.dueLabel,
  });

  final String label;
  final String dueLabel;
}

class DashboardSummary {
  const DashboardSummary({
    required this.currentBalance,
    required this.monthSavings,
    required this.monthIncome,
    required this.monthExpense,
    required this.totalCardAvailable,
    required this.totalCurrentInvoice,
    required this.totalTransactions,
    required this.metrics,
    required this.agenda,
  });

  final double currentBalance;
  final double monthSavings;
  final double monthIncome;
  final double monthExpense;
  final double totalCardAvailable;
  final double totalCurrentInvoice;
  final int totalTransactions;
  final List<DashboardMetric> metrics;
  final List<DashboardAgendaItem> agenda;
}
