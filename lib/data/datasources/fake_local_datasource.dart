import 'package:financas/data/datasources/local_datasource.dart';
import 'package:financas/data/fake/fake_accounts.dart';
import 'package:financas/data/fake/fake_cards.dart';
import 'package:financas/data/fake/fake_transactions.dart';
import 'package:financas/models/account.dart';
import 'package:financas/models/card.dart';
import 'package:financas/models/dashboard_summary.dart';
import 'package:financas/models/expense_draft.dart';
import 'package:financas/models/transaction.dart';
import 'package:financas/models/user_preferences.dart';

class FakeLocalDatasource implements LocalDatasource {
  @override
  Future<void> addExpense(ExpenseDraft draft) async {}

  @override
  List<Account> getAccounts() => fakeAccounts;

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
  DashboardSummary getDashboardSummary() {
    return const DashboardSummary(
      currentBalance: 8420.50,
      monthSavings: 1240,
      metrics: [
        DashboardMetric(
          label: 'Cartões',
          valueLabel: 'R\$ 1.860',
          caption: 'R\$ 2.340 disponíveis',
        ),
        DashboardMetric(
          label: 'Meta principal',
          valueLabel: '68%',
          caption: 'Notebook em 7 meses',
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
  Future<void> savePreferences(
    UserPreferences preferences, {
    required bool completedWelcome,
  }) async {}
}
