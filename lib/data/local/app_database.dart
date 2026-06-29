import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class AppPreferencesTable extends Table {
  IntColumn get id => integer()();
  TextColumn get displayName => text().withDefault(const Constant('Nik'))();
  TextColumn get appearance => text().withDefault(const Constant('calm'))();
  BoolColumn get completedWelcome =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class AccountsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  RealColumn get balance => real()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class CardsTable extends Table {
  TextColumn get id => text()();
  TextColumn get bankName => text()();
  TextColumn get name => text()();
  TextColumn get maskedNumber => text()();
  RealColumn get limitAmount => real()();
  RealColumn get availableAmount => real()();
  RealColumn get currentInvoice => real()();
  TextColumn get closingLabel => text()();
  TextColumn get dueLabel => text()();
  IntColumn get backgroundColor => integer()();
  IntColumn get accentColor => integer()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class CategoriesTable extends Table {
  TextColumn get name => text()();

  @override
  Set<Column<Object>>? get primaryKey => {name};
}

class TransactionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  RealColumn get amount => real()();
  TextColumn get type => text()();
  DateTimeColumn get occuredAt => dateTime()();
  TextColumn get sourceLabel => text()();
  TextColumn get category => text()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class GoalsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real()();
  TextColumn get estimatedLabel => text()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class BudgetsTable extends Table {
  TextColumn get id => text()();
  TextColumn get category => text()();
  IntColumn get periodMonth => integer()();
  IntColumn get periodYear => integer()();
  RealColumn get budgetAmount => real()();
  RealColumn get alertThresholdPercent =>
      real().withDefault(const Constant(80))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class SubscriptionsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get billingCycle => text()();
  DateTimeColumn get nextChargeDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get detectionSource => text()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class CalendarEventsTable extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get eventDate => dateTime()();
  RealColumn get amount => real().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class SyncQueueTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get localEntityType => text()();
  TextColumn get localEntityId => text()();
  TextColumn get operation => text()();
  TextColumn get clientMutationId => text().nullable()();
  TextColumn get payloadJson => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    AppPreferencesTable,
    AccountsTable,
    CardsTable,
    CategoriesTable,
    TransactionsTable,
    GoalsTable,
    BudgetsTable,
    SubscriptionsTable,
    CalendarEventsTable,
    SyncQueueTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  // ignore: use_super_parameters
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'financas_app'));

  // ignore: use_super_parameters
  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
        },
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(syncQueueTable, syncQueueTable.userId);
            await migrator.addColumn(
              syncQueueTable,
              syncQueueTable.clientMutationId,
            );
          }
        },
      );

  Future<void> replaceAccounts(List<AccountsTableCompanion> accounts) async {
    await transaction(() async {
      await delete(accountsTable).go();
      if (accounts.isNotEmpty) {
        await batch((batch) => batch.insertAll(accountsTable, accounts));
      }
    });
  }

  Future<void> replaceCards(List<CardsTableCompanion> cards) async {
    await transaction(() async {
      await delete(cardsTable).go();
      if (cards.isNotEmpty) {
        await batch((batch) => batch.insertAll(cardsTable, cards));
      }
    });
  }

  Future<void> replaceCategories(
    List<CategoriesTableCompanion> categories,
  ) async {
    await transaction(() async {
      await delete(categoriesTable).go();
      if (categories.isNotEmpty) {
        await batch((batch) => batch.insertAll(categoriesTable, categories));
      }
    });
  }

  Future<void> replaceGoals(List<GoalsTableCompanion> goals) async {
    await transaction(() async {
      await delete(goalsTable).go();
      if (goals.isNotEmpty) {
        await batch((batch) => batch.insertAll(goalsTable, goals));
      }
    });
  }

  Future<void> replaceBudgets(List<BudgetsTableCompanion> budgets) async {
    await transaction(() async {
      await delete(budgetsTable).go();
      if (budgets.isNotEmpty) {
        await batch((batch) => batch.insertAll(budgetsTable, budgets));
      }
    });
  }

  Future<void> replaceSubscriptions(
    List<SubscriptionsTableCompanion> subscriptions,
  ) async {
    await transaction(() async {
      await delete(subscriptionsTable).go();
      if (subscriptions.isNotEmpty) {
        await batch(
          (batch) => batch.insertAll(subscriptionsTable, subscriptions),
        );
      }
    });
  }

  Future<void> replaceCalendarEvents(
    List<CalendarEventsTableCompanion> events,
  ) async {
    await transaction(() async {
      await delete(calendarEventsTable).go();
      if (events.isNotEmpty) {
        await batch((batch) => batch.insertAll(calendarEventsTable, events));
      }
    });
  }

  Future<void> replaceTransactions(
    List<TransactionsTableCompanion> transactions,
  ) async {
    await transaction(() async {
      await delete(transactionsTable).go();
      if (transactions.isNotEmpty) {
        await batch((batch) => batch.insertAll(transactionsTable, transactions));
      }
    });
  }

  Future<void> enqueueSyncMutation({
    required String localEntityType,
    required String localEntityId,
    required String operation,
    required String payloadJson,
    String? userId,
    String? clientMutationId,
  }) {
    final now = DateTime.now();
    final mutationId = clientMutationId ?? '${localEntityType}_$localEntityId';
    return into(syncQueueTable).insertOnConflictUpdate(
      SyncQueueTableCompanion.insert(
        id: mutationId,
        userId: Value(userId),
        localEntityType: localEntityType,
        localEntityId: localEntityId,
        operation: operation,
        clientMutationId: Value(mutationId),
        payloadJson: payloadJson,
        status: const Value('pending'),
        retryCount: const Value(0),
        lastError: const Value.absent(),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<List<SyncQueueTableData>> getSyncQueueItems({
    List<String>? statuses,
  }) {
    final query = select(syncQueueTable)
      ..orderBy([
        (table) => OrderingTerm.asc(table.createdAt),
      ]);
    if (statuses != null && statuses.isNotEmpty) {
      query.where((table) => table.status.isIn(statuses));
    }
    return query.get();
  }

  Stream<List<SyncQueueTableData>> watchSyncQueueItems() {
    final query = select(syncQueueTable)
      ..orderBy([
        (table) => OrderingTerm.asc(table.createdAt),
      ]);
    return query.watch();
  }

  Future<void> markSyncQueueProcessing(String id, {String? userId}) {
    return (update(syncQueueTable)..where((table) => table.id.equals(id))).write(
      SyncQueueTableCompanion(
        userId: Value(userId),
        status: const Value('processing'),
        updatedAt: Value(DateTime.now()),
        lastError: const Value.absent(),
      ),
    );
  }

  Future<void> markSyncQueueSynced(String id, {String? userId}) {
    return (update(syncQueueTable)..where((table) => table.id.equals(id))).write(
      SyncQueueTableCompanion(
        userId: Value(userId),
        status: const Value('synced'),
        updatedAt: Value(DateTime.now()),
        lastError: const Value.absent(),
      ),
    );
  }

  Future<void> markSyncQueueFailed(
    String id, {
    String? userId,
    required int retryCount,
    required String lastError,
  }) {
    return (update(syncQueueTable)..where((table) => table.id.equals(id))).write(
      SyncQueueTableCompanion(
        userId: Value(userId),
        status: const Value('failed'),
        retryCount: Value(retryCount),
        lastError: Value(lastError),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> clearSyncedQueueItems() {
    return (delete(syncQueueTable)
          ..where((table) => table.status.equals('synced')))
        .go();
  }

  Future<void> clearQueue() {
    return delete(syncQueueTable).go();
  }
}
