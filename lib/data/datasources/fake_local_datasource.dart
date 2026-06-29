import 'package:financas/data/datasources/local_datasource.dart';
import 'package:financas/data/fake/fake_accounts.dart';
import 'package:financas/data/fake/fake_budgets.dart';
import 'package:financas/data/fake/fake_calendar_events.dart';
import 'package:financas/data/fake/fake_cards.dart';
import 'package:financas/data/fake/fake_goals.dart';
import 'package:financas/data/fake/fake_subscriptions.dart';
import 'package:financas/data/fake/fake_transactions.dart';
import 'package:financas/models/account.dart';
import 'package:financas/models/budget.dart';
import 'package:financas/models/calendar_event.dart';
import 'package:financas/models/card.dart';
import 'package:financas/models/dashboard_summary.dart';
import 'package:financas/models/expense_draft.dart';
import 'package:financas/models/goal.dart';
import 'package:financas/models/subscription.dart';
import 'package:financas/models/transaction.dart';
import 'package:financas/models/user_preferences.dart';

class FakeLocalDatasource implements LocalDatasource {
  @override
  Future<void> addExpense(ExpenseDraft draft) async {}

  @override
  Future<void> deleteAccount(String accountId) async {}

  @override
  Future<void> deleteCategory(String category) async {}

  @override
  Future<void> deleteCard(String cardId) async {}

  @override
  Future<void> deleteBudget(String budgetId) async {}

  @override
  Future<void> deleteCalendarEvent(String eventId) async {}

  @override
  Future<void> deleteGoal(String goalId) async {}

  @override
  Future<void> deleteSubscription(String subscriptionId) async {}

  @override
  Future<void> deleteTransaction(String transactionId) async {}

  @override
  Future<String> exportData() async {
    return '''
{
  "version": 1,
  "exportedAt": "2026-06-28T00:00:00.000Z",
  "data": {
    "completedWelcome": false,
    "preferences": {
      "displayName": "Nik",
      "appearance": "calm"
    },
    "accounts": [],
    "cards": [],
    "categories": [],
    "goals": [],
    "budgets": [],
    "subscriptions": [],
    "calendarEvents": [],
    "transactions": []
  }
}
''';
  }

  @override
  List<Account> getAccounts() => fakeAccounts;

  @override
  List<Budget> getBudgets() => fakeBudgets;

  @override
  List<CalendarEventModel> getCalendarEvents() => fakeCalendarEvents;

  @override
  List<PaymentCard> getCards() => fakeCards;

  @override
  List<String> getCategories() {
    return const [
      'Mercado',
      'Transporte',
      'Saúde',
      'Moradia',
      'Lazer',
    ];
  }

  @override
  List<String> getExpenseSources() {
    return const [
      'Conta principal • Débito',
      'Reserva • Débito',
      'Nubank • Crédito',
      'Santander • Crédito',
      'Itaú • Crédito',
    ];
  }

  @override
  List<Goal> getGoals() => fakeGoals;

  @override
  List<SubscriptionModel> getSubscriptions() => fakeSubscriptions;

  @override
  DashboardSummary getDashboardSummary() {
    return const DashboardSummary(
      currentBalance: 8420.50,
      monthSavings: 1240,
      monthIncome: 3500,
      monthExpense: 2260,
      totalCardAvailable: 1860,
      totalCurrentInvoice: 2340,
      totalTransactions: 4,
      metrics: [
        DashboardMetric(
          label: 'Cartões',
          valueLabel: 'R\$ 1.860',
          caption: 'R\$ 2.340 disponíveis',
        ),
        DashboardMetric(
          label: 'Receitas do mês',
          valueLabel: 'R\$ 3.500',
          caption: 'Despesas do mês: R\$ 2.260',
        ),
        DashboardMetric(
          label: 'Movimentações',
          valueLabel: '4',
          caption: 'Entradas registradas localmente',
        ),
      ],
      agenda: [
        DashboardAgendaItem(label: 'Fechamento Nubank', dueLabel: 'amanhã'),
        DashboardAgendaItem(label: 'Spotify', dueLabel: '02 jul'),
        DashboardAgendaItem(label: 'Aporte meta', dueLabel: '4 dias'),
      ],
    );
  }

  @override
  ExpenseDraft getExpenseDraft() {
    return const ExpenseDraft(
      amount: 120,
      category: 'Mercado',
      source: 'Cartão Santander • Crédito',
      description: '',
    );
  }

  @override
  bool getHasCompletedWelcome() => false;

  @override
  UserPreferences getPreferences() {
    return const UserPreferences(
      displayName: 'Nik',
      appearance: AppAppearance.calm,
    );
  }

  @override
  List<TransactionModel> getTransactions() => fakeTransactions;

  @override
  Future<void> importData(String rawData) async {}

  @override
  Future<void> savePreferences(
    UserPreferences preferences, {
    required bool completedWelcome,
  }) async {}

  @override
  Future<void> saveAccount(Account account) async {}

  @override
  Future<void> saveBudget(Budget budget) async {}

  @override
  Future<void> saveCalendarEvent(CalendarEventModel event) async {}

  @override
  Future<void> saveCategory(String category) async {}

  @override
  Future<void> saveCard(PaymentCard card) async {}

  @override
  Future<void> saveGoal(Goal goal) async {}

  @override
  Future<void> saveSubscription(SubscriptionModel subscription) async {}

  @override
  Future<void> saveTransaction(TransactionModel transaction) async {}
}
