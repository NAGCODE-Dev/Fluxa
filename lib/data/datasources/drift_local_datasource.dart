import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:fluxa/core/sync/remote_sync_target.dart';
import 'package:fluxa/data/datasources/local_datasource.dart';
import 'package:fluxa/data/fake/fake_accounts.dart';
import 'package:fluxa/data/fake/fake_budgets.dart';
import 'package:fluxa/data/fake/fake_calendar_events.dart';
import 'package:fluxa/data/fake/fake_cards.dart';
import 'package:fluxa/data/fake/fake_goals.dart';
import 'package:fluxa/data/fake/fake_subscriptions.dart';
import 'package:fluxa/data/fake/fake_transactions.dart';
import 'package:fluxa/data/local/app_database.dart';
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

class DriftLocalDatasource implements LocalDatasource, RemoteSyncTarget {
  DriftLocalDatasource(this._database);

  static const _remoteSyncEntityTypes = {
    'profiles',
    'accounts',
    'cards',
    'categories',
    'goals',
    'transactions',
  };

  static const _defaultCategories = [
    'Mercado',
    'Transporte',
    'Saúde',
    'Moradia',
    'Lazer',
    'Assinaturas',
    'Outros',
  ];

  final AppDatabase _database;

  UserPreferences _preferences = const UserPreferences(
    displayName: 'Nik',
    appearance: AppAppearance.calm,
  );
  bool _completedWelcome = false;
  List<Account> _accounts = List<Account>.from(fakeAccounts);
  List<PaymentCard> _cards = List<PaymentCard>.from(fakeCards);
  List<String> _categories = List<String>.from(_defaultCategories);
  List<Goal> _goals = List<Goal>.from(fakeGoals);
  List<Budget> _budgets = List<Budget>.from(fakeBudgets);
  List<SubscriptionModel> _subscriptions =
      List<SubscriptionModel>.from(fakeSubscriptions);
  List<CalendarEventModel> _calendarEvents =
      List<CalendarEventModel>.from(fakeCalendarEvents);
  List<TransactionModel> _transactions =
      List<TransactionModel>.from(fakeTransactions);

  Future<void> initialize() async {
    await _seedIfNeeded();
    await _reloadCache();
  }

  @override
  Future<void> addExpense(ExpenseDraft draft) async {
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
  Future<void> deleteAccount(String accountId) async {
    _accounts = _accounts.where((account) => account.id != accountId).toList();
    await _writeAccounts(_accounts);
    await _enqueueDelete(
      entityType: 'accounts',
      localEntityId: accountId,
    );
  }

  @override
  Future<void> deleteCard(String cardId) async {
    _cards = _cards.where((card) => card.id != cardId).toList();
    await _writeCards(_cards);
    await _enqueueDelete(
      entityType: 'cards',
      localEntityId: cardId,
    );
  }

  @override
  Future<void> deleteCategory(String category) async {
    _categories = _categories
        .where((item) => item.toLowerCase() != category.toLowerCase())
        .toList();
    if (_categories.isEmpty) {
      _categories = List<String>.from(_defaultCategories);
    }
    await _writeCategories(_categories);
    await _enqueueDelete(
      entityType: 'categories',
      localEntityId: category,
    );
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    _goals = _goals.where((goal) => goal.id != goalId).toList();
    await _writeGoals(_goals);
    await _enqueueDelete(
      entityType: 'goals',
      localEntityId: goalId,
    );
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    final index = _transactions.indexWhere((item) => item.id == transactionId);
    if (index < 0) {
      return;
    }

    final removed = _transactions.removeAt(index);
    final reverted = _reverseTransactionImpact(
      transaction: removed,
      accounts: _accounts,
      cards: _cards,
    );
    _accounts = reverted.accounts;
    _cards = reverted.cards;

    await _writeTransactions(_transactions);
    await _writeAccounts(_accounts);
    await _writeCards(_cards);
    await _enqueueDelete(
      entityType: 'transactions',
      localEntityId: transactionId,
    );
  }

  @override
  Future<String> exportData() async {
    return jsonEncode({
      'version': 1,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'data': {
        'completedWelcome': _completedWelcome,
        'preferences': _preferences.toJson(),
        'accounts': _accounts.map((item) => item.toJson()).toList(),
        'cards': _cards.map((item) => item.toJson()).toList(),
        'categories': _categories,
        'goals': _goals.map((item) => item.toJson()).toList(),
        'budgets': _budgets.map((item) => item.toJson()).toList(),
        'subscriptions': _subscriptions.map((item) => item.toJson()).toList(),
        'calendarEvents': _calendarEvents.map((item) => item.toJson()).toList(),
        'transactions': _transactions.map((item) => item.toJson()).toList(),
      },
    });
  }

  @override
  List<Account> getAccounts() => List<Account>.from(_accounts);

  @override
  List<Budget> getBudgets() => List<Budget>.from(_budgets);

  @override
  List<CalendarEventModel> getCalendarEvents() =>
      List<CalendarEventModel>.from(_calendarEvents);

  @override
  List<PaymentCard> getCards() => List<PaymentCard>.from(_cards);

  @override
  List<String> getCategories() => List<String>.from(_categories);

  @override
  DashboardSummary getDashboardSummary() {
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

    final monthTransactions = _transactions.where((item) {
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
    final currentBalance = _accounts.fold<double>(
      0,
      (sum, item) => sum + item.balance,
    );
    final totalCardAvailable = _cards.fold<double>(
      0,
      (sum, item) => sum + item.availableAmount,
    );
    final totalCurrentInvoice = _cards.fold<double>(
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
      totalTransactions: _transactions.length,
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
          valueLabel: '${_transactions.length}',
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
  List<String> getExpenseSources() {
    final accountSources = _accounts.map(
      (account) => '${account.name} • Débito',
    );
    final cardSources = _cards.map(
      (card) => '${card.bankName} • Crédito',
    );
    return [...accountSources, ...cardSources];
  }

  @override
  List<Goal> getGoals() => List<Goal>.from(_goals);

  @override
  List<SubscriptionModel> getSubscriptions() =>
      List<SubscriptionModel>.from(_subscriptions);

  @override
  bool getHasCompletedWelcome() => _completedWelcome;

  @override
  UserPreferences getPreferences() => _preferences;

  @override
  List<TransactionModel> getTransactions() => List<TransactionModel>.from(
        _transactions,
      );

  @override
  Future<void> importData(String rawData) async {
    final decoded = jsonDecode(rawData);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Backup inválido.');
    }

    final payload = decoded['data'] is Map<String, dynamic>
        ? decoded['data'] as Map<String, dynamic>
        : decoded;
    final preferencesPayload = payload['preferences'];
    final accountsPayload = payload['accounts'];
    final cardsPayload = payload['cards'];
    final categoriesPayload = payload['categories'];
    final goalsPayload = payload['goals'];
    final budgetsPayload = payload['budgets'];
    final subscriptionsPayload = payload['subscriptions'];
    final calendarEventsPayload = payload['calendarEvents'];
    final transactionsPayload = payload['transactions'];

    _completedWelcome = payload['completedWelcome'] as bool? ?? true;
    _preferences = preferencesPayload is Map<String, dynamic>
        ? UserPreferences.fromJson(preferencesPayload)
        : const UserPreferences(
            displayName: 'Você',
            appearance: AppAppearance.calm,
          );
    _accounts = _parseList(accountsPayload, Account.fromJson);
    _cards = _parseList(cardsPayload, PaymentCard.fromJson);
    _categories = categoriesPayload is List<dynamic>
        ? categoriesPayload.map((item) => item.toString()).toList()
        : List<String>.from(_defaultCategories);
    if (_categories.isEmpty) {
      _categories = List<String>.from(_defaultCategories);
    }
    _goals = _parseList(goalsPayload, Goal.fromJson);
    _budgets = _parseList(budgetsPayload, Budget.fromJson);
    _subscriptions =
        _parseList(subscriptionsPayload, SubscriptionModel.fromJson);
    _calendarEvents =
        _parseList(calendarEventsPayload, CalendarEventModel.fromJson);
    _transactions = _parseList(transactionsPayload, TransactionModel.fromJson)
      ..sort((left, right) => right.occuredAt.compareTo(left.occuredAt));

    await _persistSnapshot();
    await _database.clearQueue();
    await _enqueueFullSnapshot();
  }

  @override
  Future<void> applyRemoteSnapshot({
    required UserPreferences preferences,
    required bool completedWelcome,
    required List<Account> accounts,
    required List<PaymentCard> cards,
    required List<String> categories,
    required List<Goal> goals,
    List<Budget> budgets = const [],
    List<SubscriptionModel> subscriptions = const [],
    List<CalendarEventModel> calendarEvents = const [],
    required List<TransactionModel> transactions,
  }) async {
    _preferences = preferences;
    _completedWelcome = completedWelcome;
    _accounts = accounts;
    _cards = cards;
    _categories = categories.isEmpty
        ? List<String>.from(_defaultCategories)
        : categories;
    _goals = goals;
    _budgets = budgets;
    _subscriptions = subscriptions;
    _calendarEvents = calendarEvents;
    _transactions = transactions
      ..sort((left, right) => right.occuredAt.compareTo(left.occuredAt));

    await _persistSnapshot();
  }

  @override
  Future<void> saveAccount(Account account) async {
    final isUpdate = _accounts.any((item) => item.id == account.id);
    final index = _accounts.indexWhere((item) => item.id == account.id);
    if (index >= 0) {
      _accounts[index] = account;
    } else {
      _accounts.add(account);
    }
    await _writeAccounts(_accounts);
    await _enqueueUpsert(
      entityType: 'accounts',
      localEntityId: account.id,
      operation: isUpdate ? 'update' : 'create',
      payload: account.toJson(),
    );
  }

  @override
  Future<void> saveCard(PaymentCard card) async {
    final isUpdate = _cards.any((item) => item.id == card.id);
    final index = _cards.indexWhere((item) => item.id == card.id);
    if (index >= 0) {
      _cards[index] = card;
    } else {
      _cards.add(card);
    }
    await _writeCards(_cards);
    await _enqueueUpsert(
      entityType: 'cards',
      localEntityId: card.id,
      operation: isUpdate ? 'update' : 'create',
      payload: card.toJson(),
    );
  }

  @override
  Future<void> saveCategory(String category) async {
    final normalized = category.trim();
    if (normalized.isEmpty) {
      return;
    }

    final exists = _categories.any(
      (item) => item.toLowerCase() == normalized.toLowerCase(),
    );
    if (!exists) {
      _categories.add(normalized);
      await _writeCategories(_categories);
      await _enqueueUpsert(
        entityType: 'categories',
        localEntityId: normalized,
        operation: 'create',
        payload: {'name': normalized},
      );
    }
  }

  @override
  Future<void> saveGoal(Goal goal) async {
    final isUpdate = _goals.any((item) => item.id == goal.id);
    final index = _goals.indexWhere((item) => item.id == goal.id);
    if (index >= 0) {
      _goals[index] = goal;
    } else {
      _goals.add(goal);
    }
    await _writeGoals(_goals);
    await _enqueueUpsert(
      entityType: 'goals',
      localEntityId: goal.id,
      operation: isUpdate ? 'update' : 'create',
      payload: goal.toJson(),
    );
  }

  @override
  Future<void> saveBudget(Budget budget) async {
    final index = _budgets.indexWhere((item) => item.id == budget.id);
    if (index >= 0) {
      _budgets[index] = budget;
    } else {
      _budgets.add(budget);
    }
    await _writeBudgets(_budgets);
  }

  @override
  Future<void> deleteBudget(String budgetId) async {
    _budgets = _budgets.where((budget) => budget.id != budgetId).toList();
    await _writeBudgets(_budgets);
  }

  @override
  Future<void> saveSubscription(SubscriptionModel subscription) async {
    final index =
        _subscriptions.indexWhere((item) => item.id == subscription.id);
    if (index >= 0) {
      _subscriptions[index] = subscription;
    } else {
      _subscriptions.add(subscription);
    }
    await _writeSubscriptions(_subscriptions);
  }

  @override
  Future<void> deleteSubscription(String subscriptionId) async {
    _subscriptions = _subscriptions
        .where((subscription) => subscription.id != subscriptionId)
        .toList();
    await _writeSubscriptions(_subscriptions);
  }

  @override
  Future<void> saveCalendarEvent(CalendarEventModel event) async {
    final index = _calendarEvents.indexWhere((item) => item.id == event.id);
    if (index >= 0) {
      _calendarEvents[index] = event;
    } else {
      _calendarEvents.add(event);
    }
    await _writeCalendarEvents(_calendarEvents);
  }

  @override
  Future<void> deleteCalendarEvent(String eventId) async {
    _calendarEvents =
        _calendarEvents.where((event) => event.id != eventId).toList();
    await _writeCalendarEvents(_calendarEvents);
  }

  @override
  Future<void> savePreferences(
    UserPreferences preferences, {
    required bool completedWelcome,
  }) async {
    _preferences = preferences;
    _completedWelcome = completedWelcome;
    await _writePreferences();
    await _enqueueUpsert(
      entityType: 'profiles',
      localEntityId: 'profile',
      operation: 'update',
      payload: {
        'displayName': preferences.displayName,
        'themePreference': preferences.appearance.name,
        'completedWelcome': completedWelcome,
      },
    );
  }

  @override
  Future<void> saveTransaction(TransactionModel transaction) async {
    final isUpdate = _transactions.any((item) => item.id == transaction.id);
    final index = _transactions.indexWhere((item) => item.id == transaction.id);

    var updatedAccounts = _accounts;
    var updatedCards = _cards;
    if (index >= 0) {
      final existing = _transactions[index];
      final reverted = _reverseTransactionImpact(
        transaction: existing,
        accounts: updatedAccounts,
        cards: updatedCards,
      );
      updatedAccounts = reverted.accounts;
      updatedCards = reverted.cards;
      _transactions[index] = transaction;
    } else {
      _transactions.insert(0, transaction);
    }

    final applied = _applyTransactionImpact(
      transaction: transaction,
      accounts: updatedAccounts,
      cards: updatedCards,
    );

    _accounts = applied.accounts;
    _cards = applied.cards;
    _transactions.sort((left, right) => right.occuredAt.compareTo(left.occuredAt));

    await _writeTransactions(_transactions);
    await _writeAccounts(_accounts);
    await _writeCards(_cards);
    await _enqueueUpsert(
      entityType: 'transactions',
      localEntityId: transaction.id,
      operation: isUpdate ? 'update' : 'create',
      payload: transaction.toJson(),
    );
  }

  Future<void> _reloadCache() async {
    final preferenceRow =
        await (_database.select(_database.appPreferencesTable)
              ..where((table) => table.id.equals(1)))
            .getSingleOrNull();
    _preferences = UserPreferences(
      displayName: preferenceRow?.displayName ?? 'Nik',
      appearance: AppAppearance.values.firstWhere(
        (value) => value.name == preferenceRow?.appearance,
        orElse: () => AppAppearance.calm,
      ),
    );
    _completedWelcome = preferenceRow?.completedWelcome ?? false;

    _accounts = (await _database.select(_database.accountsTable).get())
        .map(
          (row) => Account(
            id: row.id,
            name: row.name,
            type: row.type,
            balance: row.balance,
          ),
        )
        .toList();

    _cards = (await _database.select(_database.cardsTable).get())
        .map(
          (row) => PaymentCard(
            id: row.id,
            bankName: row.bankName,
            name: row.name,
            maskedNumber: row.maskedNumber,
            limitAmount: row.limitAmount,
            availableAmount: row.availableAmount,
            currentInvoice: row.currentInvoice,
            closingLabel: row.closingLabel,
            dueLabel: row.dueLabel,
            backgroundColor: row.backgroundColor,
            accentColor: row.accentColor,
          ),
        )
        .toList();

    _categories = (await _database.select(_database.categoriesTable).get())
        .map((row) => row.name)
        .toList();
    if (_categories.isEmpty) {
      _categories = List<String>.from(_defaultCategories);
    }

    _goals = (await _database.select(_database.goalsTable).get())
        .map(
          (row) => Goal(
            id: row.id,
            name: row.name,
            targetAmount: row.targetAmount,
            currentAmount: row.currentAmount,
            estimatedLabel: row.estimatedLabel,
          ),
        )
        .toList();
    _budgets = (await _database.select(_database.budgetsTable).get())
        .map(
          (row) => Budget(
            id: row.id,
            category: row.category,
            periodMonth: row.periodMonth,
            periodYear: row.periodYear,
            limitAmount: row.budgetAmount,
            usedAmount: _transactions
                .where(
                  (item) =>
                      item.category == row.category &&
                      item.occuredAt.month == row.periodMonth &&
                      item.occuredAt.year == row.periodYear &&
                      item.amount < 0,
                )
                .fold<double>(0, (sum, item) => sum + item.amount.abs()),
            alertThresholdPercent: row.alertThresholdPercent,
          ),
        )
        .toList();
    _subscriptions = (await _database.select(_database.subscriptionsTable).get())
        .map(
          (row) => SubscriptionModel(
            id: row.id,
            name: row.name,
            amount: row.amount,
            billingCycle: row.billingCycle,
            nextChargeDate: row.nextChargeDate,
            isActive: row.isActive,
            detectionSource: row.detectionSource,
          ),
        )
        .toList();
    _calendarEvents =
        (await _database.select(_database.calendarEventsTable).get())
            .map(
              (row) => CalendarEventModel(
                id: row.id,
                type: row.type,
                title: row.title,
                description: row.description ?? '',
                eventDate: row.eventDate,
                amount: row.amount,
              ),
            )
            .toList()
          ..sort((left, right) => left.eventDate.compareTo(right.eventDate));

    _transactions = (await _database.select(_database.transactionsTable).get())
        .map(
          (row) => TransactionModel(
            id: row.id,
            title: row.title,
            description: row.description,
            amount: row.amount,
            type: TransactionType.values.firstWhere(
              (value) => value.name == row.type,
              orElse: () => TransactionType.expense,
            ),
            occuredAt: row.occuredAt,
            sourceLabel: row.sourceLabel,
            category: row.category,
          ),
        )
        .toList()
      ..sort((left, right) => right.occuredAt.compareTo(left.occuredAt));
  }

  Future<void> _seedIfNeeded() async {
    final accountCount = await _database.managers.accountsTable.count();
    if (accountCount > 0) {
      return;
    }

    await _database.into(_database.appPreferencesTable).insertOnConflictUpdate(
          const AppPreferencesTableCompanion(
            id: Value(1),
            displayName: Value('Nik'),
            appearance: Value('calm'),
            completedWelcome: Value(false),
          ),
        );
    await _writeAccounts(List<Account>.from(fakeAccounts));
    await _writeCards(List<PaymentCard>.from(fakeCards));
    await _writeCategories(List<String>.from(_defaultCategories));
    await _writeGoals(List<Goal>.from(fakeGoals));
    await _writeBudgets(List<Budget>.from(fakeBudgets));
    await _writeSubscriptions(List<SubscriptionModel>.from(fakeSubscriptions));
    await _writeCalendarEvents(
      List<CalendarEventModel>.from(fakeCalendarEvents),
    );
    await _writeTransactions(List<TransactionModel>.from(fakeTransactions));
  }

  Future<void> _writeAccounts(List<Account> accounts) {
    return _database.replaceAccounts(
      accounts
          .map(
            (item) => AccountsTableCompanion.insert(
              id: item.id,
              name: item.name,
              type: item.type,
              balance: item.balance,
            ),
          )
          .toList(),
    );
  }

  Future<void> _writeCards(List<PaymentCard> cards) {
    return _database.replaceCards(
      cards
          .map(
            (item) => CardsTableCompanion.insert(
              id: item.id,
              bankName: item.bankName,
              name: item.name,
              maskedNumber: item.maskedNumber,
              limitAmount: item.limitAmount,
              availableAmount: item.availableAmount,
              currentInvoice: item.currentInvoice,
              closingLabel: item.closingLabel,
              dueLabel: item.dueLabel,
              backgroundColor: item.backgroundColor,
              accentColor: item.accentColor,
            ),
          )
          .toList(),
    );
  }

  Future<void> _writeCategories(List<String> categories) {
    return _database.replaceCategories(
      categories
          .map((item) => CategoriesTableCompanion.insert(name: item))
          .toList(),
    );
  }

  Future<void> _writeGoals(List<Goal> goals) {
    return _database.replaceGoals(
      goals
          .map(
            (item) => GoalsTableCompanion.insert(
              id: item.id,
              name: item.name,
              targetAmount: item.targetAmount,
              currentAmount: item.currentAmount,
              estimatedLabel: item.estimatedLabel,
            ),
          )
          .toList(),
    );
  }

  Future<void> _writeBudgets(List<Budget> budgets) {
    return _database.replaceBudgets(
      budgets
          .map(
            (item) => BudgetsTableCompanion.insert(
              id: item.id,
              category: item.category,
              periodMonth: item.periodMonth,
              periodYear: item.periodYear,
              budgetAmount: item.limitAmount,
              alertThresholdPercent: Value(item.alertThresholdPercent),
            ),
          )
          .toList(),
    );
  }

  Future<void> _writeSubscriptions(List<SubscriptionModel> subscriptions) {
    return _database.replaceSubscriptions(
      subscriptions
          .map(
            (item) => SubscriptionsTableCompanion.insert(
              id: item.id,
              name: item.name,
              amount: item.amount,
              billingCycle: item.billingCycle,
              nextChargeDate: item.nextChargeDate,
              isActive: Value(item.isActive),
              detectionSource: item.detectionSource,
            ),
          )
          .toList(),
    );
  }

  Future<void> _writeCalendarEvents(List<CalendarEventModel> events) {
    return _database.replaceCalendarEvents(
      events
          .map(
            (item) => CalendarEventsTableCompanion.insert(
              id: item.id,
              type: item.type,
              title: item.title,
              description: Value(item.description.isEmpty ? null : item.description),
              eventDate: item.eventDate,
              amount: Value(item.amount),
            ),
          )
          .toList(),
    );
  }

  Future<void> _writePreferences() {
    return _database.into(_database.appPreferencesTable).insertOnConflictUpdate(
          AppPreferencesTableCompanion.insert(
            id: const Value(1),
            displayName: Value(_preferences.displayName),
            appearance: Value(_preferences.appearance.name),
            completedWelcome: Value(_completedWelcome),
          ),
        );
  }

  Future<void> _writeTransactions(List<TransactionModel> transactions) {
    return _database.replaceTransactions(
      transactions
          .map(
            (item) => TransactionsTableCompanion.insert(
              id: item.id,
              title: item.title,
              description: Value(item.description),
              amount: item.amount,
              type: item.type.name,
              occuredAt: item.occuredAt,
              sourceLabel: item.sourceLabel,
              category: item.category,
            ),
          )
          .toList(),
    );
  }

  Future<void> _persistSnapshot() async {
    await _writePreferences();
    await _writeAccounts(_accounts);
    await _writeCards(_cards);
    await _writeCategories(_categories);
    await _writeGoals(_goals);
    await _writeBudgets(_budgets);
    await _writeSubscriptions(_subscriptions);
    await _writeCalendarEvents(_calendarEvents);
    await _writeTransactions(_transactions);
  }

  Future<void> _enqueueDelete({
    required String entityType,
    required String localEntityId,
  }) {
    if (!_remoteSyncEntityTypes.contains(entityType)) {
      return Future.value();
    }
    return _database.enqueueSyncMutation(
      localEntityType: entityType,
      localEntityId: localEntityId,
      operation: 'delete',
      clientMutationId: '${entityType}_${localEntityId}_delete',
      payloadJson: jsonEncode({'id': localEntityId}),
    );
  }

  Future<void> _enqueueFullSnapshot() async {
    for (final account in _accounts) {
      await _enqueueUpsert(
        entityType: 'accounts',
        localEntityId: account.id,
        operation: 'update',
        payload: account.toJson(),
      );
    }
    for (final card in _cards) {
      await _enqueueUpsert(
        entityType: 'cards',
        localEntityId: card.id,
        operation: 'update',
        payload: card.toJson(),
      );
    }
    for (final category in _categories) {
      await _enqueueUpsert(
        entityType: 'categories',
        localEntityId: category,
        operation: 'update',
        payload: {'name': category},
      );
    }
    for (final goal in _goals) {
      await _enqueueUpsert(
        entityType: 'goals',
        localEntityId: goal.id,
        operation: 'update',
        payload: goal.toJson(),
      );
    }
    for (final transaction in _transactions) {
      await _enqueueUpsert(
        entityType: 'transactions',
        localEntityId: transaction.id,
        operation: 'update',
        payload: transaction.toJson(),
      );
    }
    await _enqueueUpsert(
      entityType: 'profiles',
      localEntityId: 'profile',
      operation: 'update',
      payload: {
        'displayName': _preferences.displayName,
        'themePreference': _preferences.appearance.name,
        'completedWelcome': _completedWelcome,
      },
    );
  }

  Future<void> _enqueueUpsert({
    required String entityType,
    required String localEntityId,
    required String operation,
    required Map<String, dynamic> payload,
  }) {
    if (!_remoteSyncEntityTypes.contains(entityType)) {
      return Future.value();
    }
    return _database.enqueueSyncMutation(
      localEntityType: entityType,
      localEntityId: localEntityId,
      operation: operation,
      clientMutationId: '${entityType}_$localEntityId',
      payloadJson: jsonEncode(payload),
    );
  }

  _LedgerState _applyTransactionImpact({
    required TransactionModel transaction,
    required List<Account> accounts,
    required List<PaymentCard> cards,
  }) {
    if (_isCreditCardSource(transaction.sourceLabel, cards)) {
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
    if (_isCreditCardSource(transaction.sourceLabel, cards)) {
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

  bool _isCreditCardSource(String source, List<PaymentCard> cards) {
    final normalized = source.toLowerCase();
    return normalized.contains('crédito') ||
        normalized.contains('credito') ||
        normalized.contains('cartão') ||
        normalized.contains('cartao') ||
        cards.any((card) {
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
