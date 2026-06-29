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
    required this.metrics,
    required this.agenda,
  });

  final double currentBalance;
  final double monthSavings;
  final List<DashboardMetric> metrics;
  final List<DashboardAgendaItem> agenda;
}
