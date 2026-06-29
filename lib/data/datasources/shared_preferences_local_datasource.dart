import 'dart:convert';

import 'package:fluxa/data/datasources/local_datasource.dart';
import 'package:fluxa/data/fake/fake_accounts.dart';
import 'package:fluxa/data/fake/fake_budgets.dart';
import 'package:fluxa/data/fake/fake_calendar_events.dart';
import 'package:fluxa/data/fake/fake_cards.dart';
import 'package:fluxa/data/fake/fake_goals.dart';
import 'package:fluxa/data/fake/fake_subscriptions.dart';
import 'package:fluxa/data/fake/fake_transactions.dart';
import 'package:fluxa/models/account.dart';
import 'package:fluxa/models/budget.dart';
import 'package:fluxa/models/calendar_event.dart';
import 'package:fluxa/models/card.dart';
import 'package:fluxa/models/dashboard_summary.dart';
import 'package:fluxa/models/expense_draft.dart';
import 'package:fluxa/models/goal.dart';
import 'package:fluxa/models/subscription.dart';
import 'package:fluxa/models/transaction.dart';
import 'package:fluxa/models/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesLocalDatasource implements LocalDatasource {
  SharedPreferencesLocalDatasource(this._preferences);

  static const _preferencesKey = 'user_preferences';
  static const _welcomeCompletedKey = 'welcome_completed';
  static const _transactionsKey = 'transactions';
  static const _accountsKey = 'accounts';
  static const _cardsKey = 'cards';
  static const _categoriesKey = 'categories';
  static const _goalsKey = 'goals';
  static const _defaultCategories = [
    'Mercado',
    'Transporte',
    'Saúde',
    'Moradia',
    'Lazer',
    'Assinaturas',
    'Outros',
  ];

  final SharedPreferences _preferences;

  @override
  Future<void> addExpense(ExpenseDraft draft) async {
    await _ensureSeedData();
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
    await saveTransaction(expense);
  }

  @override
  List<Account> getAccounts() {
    final raw = _preferences.getString(_accountsKey);
    if (raw == null || raw.isEmpty) {
      return List<Account>.from(fakeAccounts);
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Account.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  List<PaymentCard> getCards() {
    final raw = _preferences.getString(_cardsKey);
    if (raw == null || raw.isEmpty) {
      return List<PaymentCard>.from(fakeCards);
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => PaymentCard.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  List<String> getCategories() {
    _ensureSeedDataSync();
    final raw = _preferences.getString(_categoriesKey);
    if (raw == null || raw.isEmpty) {
      return List<String>.from(_defaultCategories);
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    final categories = decoded.map((item) => item as String).toList();
    if (categories.isEmpty) {
      return List<String>.from(_defaultCategories);
    }
    return categories;
  }

  @override
  List<String> getExpenseSources() {
    final accountSources = getAccounts().map(
      (account) => '${account.name} • Débito',
    );
    final cardSources = getCards().map(
      (card) => '${card.bankName} • Crédito',
    );
    return [...accountSources, ...cardSources];
  }

  @override
  List<Goal> getGoals() {
    _ensureSeedDataSync();
    final raw = _preferences.getString(_goalsKey);
    if (raw == null || raw.isEmpty) {
      return List<Goal>.from(fakeGoals);
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Goal.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  List<Budget> getBudgets() => List<Budget>.from(fakeBudgets);

  @override
  List<SubscriptionModel> getSubscriptions() =>
      List<SubscriptionModel>.from(fakeSubscriptions);

  @override
  List<CalendarEventModel> getCalendarEvents() =>
      List<CalendarEventModel>.from(fakeCalendarEvents);

  @override
  DashboardSummary getDashboardSummary() {
    _ensureSeedDataSync();
    final transactions = getTransactions();
    final accounts = getAccounts();
    final cards = getCards();
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

    final monthTransactions = transactions.where((item) {
      return item.occuredAt.month == currentMonth &&
          item.occuredAt.year == currentYear;
    });

    final monthIncome = monthTransactions
        .where((item) => item.amount > 0)
        .fold<double>(0, (sum, item) => sum + item.amount);
    final monthExpense = monthTransactions
        .where((item) => item.amount < 0)
        .fold<double>(0, (sum, item) => sum + item.amount.abs());
    final monthSavings = monthIncome - monthExpense;
    final currentBalance = accounts.fold<double>(
      0,
      (sum, item) => sum + item.balance,
    );
    final totalCardAvailable = cards.fold<double>(
      0,
      (sum, item) => sum + item.availableAmount,
    );
    final totalCurrentInvoice = cards.fold<double>(
      0,
      (sum, item) => sum + item.currentInvoice,
    );

    return DashboardSummary(
      currentBalance: currentBalance,
      monthSavings: monthSavings,
      monthIncome: monthIncome,
      monthExpense: monthExpense,
      totalCardAvailable: totalCardAvailable,
      totalCurrentInvoice: totalCurrentInvoice,
      totalTransactions: transactions.length,
      metrics: [
        DashboardMetric(
          label: 'Cartões',
          valueLabel: 'R\$ ${totalCardAvailable.toStringAsFixed(0)}',
          caption: 'R\$ ${totalCurrentInvoice.toStringAsFixed(0)} em fatura',
        ),
        DashboardMetric(
          label: 'Receitas do mês',
          valueLabel: 'R\$ ${monthIncome.toStringAsFixed(0)}',
          caption: 'Despesas do mês: R\$ ${monthExpense.toStringAsFixed(0)}',
        ),
        DashboardMetric(
          label: 'Movimentações',
          valueLabel: '${transactions.length}',
          caption: 'Entradas registradas localmente',
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
    final sources = getExpenseSources();
    return const ExpenseDraft(
      amount: 0,
      category: 'Mercado',
      source: '',
      description: '',
    ).copyWith(
      source: sources.isEmpty ? 'Conta principal • Débito' : sources.first,
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
    _ensureSeedDataSync();
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
    await _ensureSeedData();
    await _preferences.setString(
      _preferencesKey,
      jsonEncode(preferences.toJson()),
    );
    await _preferences.setBool(_welcomeCompletedKey, completedWelcome);
  }

  @override
  Future<void> saveAccount(Account account) async {
    await _ensureSeedData();
    final accounts = getAccounts();
    final index = accounts.indexWhere((item) => item.id == account.id);
    if (index >= 0) {
      accounts[index] = account;
    } else {
      accounts.add(account);
    }

    await _preferences.setString(
      _accountsKey,
      jsonEncode(accounts.map((item) => item.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteAccount(String accountId) async {
    await _ensureSeedData();
    final accounts = getAccounts()
        .where((account) => account.id != accountId)
        .toList();
    await _preferences.setString(
      _accountsKey,
      jsonEncode(accounts.map((item) => item.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteCategory(String category) async {
    await _ensureSeedData();
    final categories = getCategories()
        .where((item) => item.toLowerCase() != category.toLowerCase())
        .toList();
    await _preferences.setString(_categoriesKey, jsonEncode(categories));
  }

  @override
  Future<void> saveCard(PaymentCard card) async {
    await _ensureSeedData();
    final cards = getCards();
    final index = cards.indexWhere((item) => item.id == card.id);
    if (index >= 0) {
      cards[index] = card;
    } else {
      cards.add(card);
    }

    await _preferences.setString(
      _cardsKey,
      jsonEncode(cards.map((item) => item.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteCard(String cardId) async {
    await _ensureSeedData();
    final cards = getCards().where((card) => card.id != cardId).toList();
    await _preferences.setString(
      _cardsKey,
      jsonEncode(cards.map((item) => item.toJson()).toList()),
    );
  }

  @override
  Future<void> saveCategory(String category) async {
    await _ensureSeedData();
    final normalized = category.trim();
    if (normalized.isEmpty) {
      return;
    }

    final categories = getCategories();
    final exists = categories.any(
      (item) => item.toLowerCase() == normalized.toLowerCase(),
    );
    if (!exists) {
      categories.add(normalized);
    }
    await _preferences.setString(_categoriesKey, jsonEncode(categories));
  }

  @override
  Future<void> saveGoal(Goal goal) async {
    await _ensureSeedData();
    final goals = getGoals();
    final index = goals.indexWhere((item) => item.id == goal.id);
    if (index >= 0) {
      goals[index] = goal;
    } else {
      goals.add(goal);
    }

    await _preferences.setString(
      _goalsKey,
      jsonEncode(goals.map((item) => item.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    await _ensureSeedData();
    final goals = getGoals().where((goal) => goal.id != goalId).toList();
    await _preferences.setString(
      _goalsKey,
      jsonEncode(goals.map((item) => item.toJson()).toList()),
    );
  }

  @override
  Future<void> saveBudget(Budget budget) async {}

  @override
  Future<void> deleteBudget(String budgetId) async {}

  @override
  Future<void> saveSubscription(SubscriptionModel subscription) async {}

  @override
  Future<void> deleteSubscription(String subscriptionId) async {}

  @override
  Future<void> saveCalendarEvent(CalendarEventModel event) async {}

  @override
  Future<void> deleteCalendarEvent(String eventId) async {}

  @override
  Future<void> saveTransaction(TransactionModel transaction) async {
    await _ensureSeedData();
    final transactions = getTransactions();
    final accounts = getAccounts();
    final cards = getCards();
    final index = transactions.indexWhere((item) => item.id == transaction.id);

    var updatedAccounts = accounts;
    var updatedCards = cards;
    if (index >= 0) {
      final existing = transactions[index];
      final reverted = _reverseTransactionImpact(
        transaction: existing,
        accounts: updatedAccounts,
        cards: updatedCards,
      );
      updatedAccounts = reverted.accounts;
      updatedCards = reverted.cards;
      transactions[index] = transaction;
    } else {
      transactions.insert(0, transaction);
    }

    final applied = _applyTransactionImpact(
      transaction: transaction,
      accounts: updatedAccounts,
      cards: updatedCards,
    );

    transactions.sort((left, right) => right.occuredAt.compareTo(left.occuredAt));
    await _writeTransactions(transactions);
    await _writeAccounts(applied.accounts);
    await _writeCards(applied.cards);
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    await _ensureSeedData();
    final transactions = getTransactions();
    final index = transactions.indexWhere((item) => item.id == transactionId);
    if (index < 0) {
      return;
    }

    final removed = transactions.removeAt(index);
    final reverted = _reverseTransactionImpact(
      transaction: removed,
      accounts: getAccounts(),
      cards: getCards(),
    );

    await _writeTransactions(transactions);
    await _writeAccounts(reverted.accounts);
    await _writeCards(reverted.cards);
  }

  @override
  Future<String> exportData() async {
    await _ensureSeedData();
    return jsonEncode({
      'version': 1,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'data': {
        'completedWelcome': getHasCompletedWelcome(),
        'preferences': getPreferences().toJson(),
        'accounts': getAccounts().map((item) => item.toJson()).toList(),
        'cards': getCards().map((item) => item.toJson()).toList(),
        'categories': getCategories(),
        'goals': getGoals().map((item) => item.toJson()).toList(),
        'transactions': getTransactions().map((item) => item.toJson()).toList(),
      },
    });
  }

  @override
  Future<void> importData(String rawData) async {
    await _ensureSeedData();
    final decoded = jsonDecode(rawData);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Backup inválido.');
    }

    final payload = decoded['data'] is Map<String, dynamic>
        ? decoded['data'] as Map<String, dynamic>
        : decoded;

    final completedWelcome = payload['completedWelcome'] as bool? ?? true;
    final preferencesPayload = payload['preferences'];
    final accountsPayload = payload['accounts'];
    final cardsPayload = payload['cards'];
    final categoriesPayload = payload['categories'];
    final goalsPayload = payload['goals'];
    final transactionsPayload = payload['transactions'];

    final preferences = preferencesPayload is Map<String, dynamic>
        ? UserPreferences.fromJson(preferencesPayload)
        : const UserPreferences(
            displayName: 'Você',
            appearance: AppAppearance.calm,
          );
    final accounts = _parseList(accountsPayload, Account.fromJson);
    final cards = _parseList(cardsPayload, PaymentCard.fromJson);
    final categories = categoriesPayload is List<dynamic>
        ? categoriesPayload.map((item) => item.toString()).toList()
        : List<String>.from(_defaultCategories);
    final goals = _parseList(goalsPayload, Goal.fromJson);
    final transactions = _parseList(transactionsPayload, TransactionModel.fromJson)
      ..sort((left, right) => right.occuredAt.compareTo(left.occuredAt));

    await _preferences.setString(
      _preferencesKey,
      jsonEncode(preferences.toJson()),
    );
    await _preferences.setBool(_welcomeCompletedKey, completedWelcome);
    await _writeAccounts(accounts);
    await _writeCards(cards);
    await _preferences.setString(
      _categoriesKey,
      jsonEncode(categories.isEmpty ? _defaultCategories : categories),
    );
    await _preferences.setString(
      _goalsKey,
      jsonEncode(goals.map((item) => item.toJson()).toList()),
    );
    await _writeTransactions(transactions);
  }

  Future<void> _ensureSeedData() async {
    if (!_preferences.containsKey(_accountsKey)) {
      await _preferences.setString(
        _accountsKey,
        jsonEncode(fakeAccounts.map((item) => item.toJson()).toList()),
      );
    }

    if (!_preferences.containsKey(_cardsKey)) {
      await _preferences.setString(
        _cardsKey,
        jsonEncode(fakeCards.map((item) => item.toJson()).toList()),
      );
    }

    if (!_preferences.containsKey(_categoriesKey)) {
      await _preferences.setString(
        _categoriesKey,
        jsonEncode(_defaultCategories),
      );
    }

    if (!_preferences.containsKey(_goalsKey)) {
      await _preferences.setString(
        _goalsKey,
        jsonEncode(fakeGoals.map((item) => item.toJson()).toList()),
      );
    }

    if (!_preferences.containsKey(_transactionsKey)) {
      await _preferences.setString(
        _transactionsKey,
        jsonEncode(fakeTransactions.map((item) => item.toJson()).toList()),
      );
    }
  }

  void _ensureSeedDataSync() {
    if (!_preferences.containsKey(_accountsKey)) {
      _preferences.setString(
        _accountsKey,
        jsonEncode(fakeAccounts.map((item) => item.toJson()).toList()),
      );
    }

    if (!_preferences.containsKey(_cardsKey)) {
      _preferences.setString(
        _cardsKey,
        jsonEncode(fakeCards.map((item) => item.toJson()).toList()),
      );
    }

    if (!_preferences.containsKey(_categoriesKey)) {
      _preferences.setString(
        _categoriesKey,
        jsonEncode(_defaultCategories),
      );
    }

    if (!_preferences.containsKey(_goalsKey)) {
      _preferences.setString(
        _goalsKey,
        jsonEncode(fakeGoals.map((item) => item.toJson()).toList()),
      );
    }

    if (!_preferences.containsKey(_transactionsKey)) {
      _preferences.setString(
        _transactionsKey,
        jsonEncode(fakeTransactions.map((item) => item.toJson()).toList()),
      );
    }
  }

  Future<void> _writeTransactions(List<TransactionModel> transactions) {
    return _preferences.setString(
      _transactionsKey,
      jsonEncode(transactions.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> _writeAccounts(List<Account> accounts) {
    return _preferences.setString(
      _accountsKey,
      jsonEncode(accounts.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> _writeCards(List<PaymentCard> cards) {
    return _preferences.setString(
      _cardsKey,
      jsonEncode(cards.map((item) => item.toJson()).toList()),
    );
  }

  _LedgerState _applyTransactionImpact({
    required TransactionModel transaction,
    required List<Account> accounts,
    required List<PaymentCard> cards,
  }) {
    if (_isCreditCardSource(transaction.sourceLabel)) {
      return _LedgerState(
        accounts: accounts,
        cards: _applyTransactionToCards(
          cards: cards,
          transaction: transaction,
          direction: 1,
        ),
      );
    }

    return _LedgerState(
      accounts: _applyTransactionToAccounts(
        accounts: accounts,
        transaction: transaction,
        direction: 1,
      ),
      cards: cards,
    );
  }

  _LedgerState _reverseTransactionImpact({
    required TransactionModel transaction,
    required List<Account> accounts,
    required List<PaymentCard> cards,
  }) {
    if (_isCreditCardSource(transaction.sourceLabel)) {
      return _LedgerState(
        accounts: accounts,
        cards: _applyTransactionToCards(
          cards: cards,
          transaction: transaction,
          direction: -1,
        ),
      );
    }

    return _LedgerState(
      accounts: _applyTransactionToAccounts(
        accounts: accounts,
        transaction: transaction,
        direction: -1,
      ),
      cards: cards,
    );
  }

  bool _isCreditCardSource(String source) {
    final normalized = source.toLowerCase();
    return normalized.contains('crédito') ||
        normalized.contains('credito') ||
        normalized.contains('cartão') ||
        normalized.contains('cartao') ||
        getCards().any((card) {
          final bank = card.bankName.toLowerCase();
          final name = card.name.toLowerCase();
          return normalized.contains(bank) &&
              (normalized.contains('credito') ||
                  normalized.contains('crédito') ||
                  normalized.contains(name));
        });
  }

  List<Account> _applyTransactionToAccounts({
    required List<Account> accounts,
    required TransactionModel transaction,
    required int direction,
  }) {
    final normalizedSource = transaction.sourceLabel.toLowerCase();

    return accounts.map((account) {
      final accountName = account.name.toLowerCase();
      final matches = normalizedSource.contains(accountName) ||
          accountName.contains(normalizedSource);
      if (!matches) {
        return account;
      }

      return account.copyWith(
        balance: account.balance + (transaction.amount * direction),
      );
    }).toList();
  }

  List<PaymentCard> _applyTransactionToCards({
    required List<PaymentCard> cards,
    required TransactionModel transaction,
    required int direction,
  }) {
    final normalizedSource = transaction.sourceLabel.toLowerCase();

    return cards.map((card) {
      final bank = card.bankName.toLowerCase();
      final name = card.name.toLowerCase();
      final matches = normalizedSource.contains(bank) ||
          normalizedSource.contains(name);
      if (!matches) {
        return card;
      }

      final invoice = card.currentInvoice + (-transaction.amount * direction);
      final available = card.availableAmount + (transaction.amount * direction);
      return card.copyWith(
        currentInvoice: invoice.clamp(0, card.limitAmount).toDouble(),
        availableAmount: available.clamp(0, card.limitAmount).toDouble(),
      );
    }).toList();
  }

  List<T> _parseList<T>(
    dynamic payload,
    T Function(Map<String, dynamic> json) parser,
  ) {
    if (payload is! List<dynamic>) {
      return <T>[];
    }

    return payload
        .map((item) => parser(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}

class _LedgerState {
  const _LedgerState({
    required this.accounts,
    required this.cards,
  });

  final List<Account> accounts;
  final List<PaymentCard> cards;
}
