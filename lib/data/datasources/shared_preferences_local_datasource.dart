import 'dart:convert';

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
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesLocalDatasource implements LocalDatasource {
  SharedPreferencesLocalDatasource(this._preferences);

  static const _preferencesKey = 'user_preferences';
  static const _welcomeCompletedKey = 'welcome_completed';
  static const _transactionsKey = 'transactions';
  static const _currentBalanceKey = 'current_balance';

  final SharedPreferences _preferences;

  @override
  Future<void> addExpense(ExpenseDraft draft) async {
    final transactions = getTransactions();
    final expense = TransactionModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: draft.category,
      description: draft.description,
      amount: -draft.amount,
      type: TransactionType.expense,
      occuredAt: DateTime.now(),
      sourceLabel: draft.source,
      category: draft.category,
    );

    transactions.insert(0, expense);
    await _preferences.setString(
      _transactionsKey,
      jsonEncode(transactions.map((item) => item.toJson()).toList()),
    );

    final currentBalance = _preferences.getDouble(_currentBalanceKey) ?? 8420.50;
    await _preferences.setDouble(_currentBalanceKey, currentBalance - draft.amount);
  }

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
      'Assinaturas',
      'Outros',
    ];
  }

  @override
  DashboardSummary getDashboardSummary() {
    final transactions = getTransactions();
    final currentBalance = _preferences.getDouble(_currentBalanceKey) ?? 8420.50;
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

    final monthTransactions = transactions.where((item) {
      return item.occuredAt.month == currentMonth &&
          item.occuredAt.year == currentYear;
    });

    final monthSavings = monthTransactions.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    final primaryCard = fakeCards.first;

    return DashboardSummary(
      currentBalance: currentBalance,
      monthSavings: monthSavings,
      metrics: [
        DashboardMetric(
          label: 'Cartões',
          valueLabel: 'R\$ ${primaryCard.availableAmount.toStringAsFixed(0)}',
          caption: 'R\$ ${primaryCard.currentInvoice.toStringAsFixed(0)} em fatura',
        ),
        DashboardMetric(
          label: 'Movimentações',
          valueLabel: '${transactions.length}',
          caption: 'Entradas registradas no arquivo',
        ),
      ],
      agenda: const [
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
  bool getHasCompletedWelcome() {
    return _preferences.getBool(_welcomeCompletedKey) ?? false;
  }

  @override
  UserPreferences getPreferences() {
    final raw = _preferences.getString(_preferencesKey);
    if (raw == null || raw.isEmpty) {
      return const UserPreferences(
        displayName: 'Nik',
        appearance: AppAppearance.calm,
      );
    }

    return UserPreferences.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  @override
  List<TransactionModel> getTransactions() {
    final raw = _preferences.getString(_transactionsKey);
    if (raw == null || raw.isEmpty) {
      return List<TransactionModel>.from(fakeTransactions);
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => TransactionModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> savePreferences(
    UserPreferences preferences, {
    required bool completedWelcome,
  }) async {
    await _preferences.setString(
      _preferencesKey,
      jsonEncode(preferences.toJson()),
    );
    await _preferences.setBool(_welcomeCompletedKey, completedWelcome);
  }
}
