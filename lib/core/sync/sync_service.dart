import 'dart:async';
import 'dart:convert';

import 'package:financas/core/sync/remote_sync_target.dart';
import 'package:financas/core/sync/sync_status.dart';
import 'package:financas/data/local/app_database.dart';
import 'package:financas/models/account.dart';
import 'package:financas/models/budget.dart';
import 'package:financas/models/calendar_event.dart';
import 'package:financas/models/card.dart';
import 'package:financas/models/goal.dart';
import 'package:financas/models/subscription.dart';
import 'package:financas/models/transaction.dart';
import 'package:financas/models/user_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SyncService {
  ValueListenable<SyncStatus> get status;

  Future<void> refreshStatus({required bool isAuthenticated});

  Future<void> syncNow({required Session? session});

  void dispose();
}

class NoopSyncService implements SyncService {
  NoopSyncService([SyncStatus? initialStatus])
      : _status = ValueNotifier<SyncStatus>(initialStatus ?? const SyncStatus.idle());

  final ValueNotifier<SyncStatus> _status;

  @override
  ValueListenable<SyncStatus> get status => _status;

  @override
  void dispose() {
    _status.dispose();
  }

  @override
  Future<void> refreshStatus({required bool isAuthenticated}) async {
    _status.value = _status.value.copyWith(isAuthenticated: isAuthenticated);
  }

  @override
  Future<void> syncNow({required Session? session}) async {
    _status.value = _status.value.copyWith(isAuthenticated: session != null);
  }
}

class SupabaseSyncService implements SyncService {
  SupabaseSyncService(
    this._database, [
    this._target,
    SupabaseClient? client,
  ]) : _client = client ?? Supabase.instance.client {
    _subscription = _database.watchSyncQueueItems().listen((_) {
      unawaited(refreshStatus(isAuthenticated: _client.auth.currentSession != null));
    });
  }

  final AppDatabase _database;
  final RemoteSyncTarget? _target;
  final SupabaseClient _client;
  final ValueNotifier<SyncStatus> _status =
      ValueNotifier<SyncStatus>(const SyncStatus.idle());
  StreamSubscription<List<SyncQueueTableData>>? _subscription;

  @override
  ValueListenable<SyncStatus> get status => _status;

  @override
  void dispose() {
    _subscription?.cancel();
    _status.dispose();
  }

  @override
  Future<void> refreshStatus({required bool isAuthenticated}) async {
    final items = await _database.getSyncQueueItems();
    final pendingCount = items
        .where((item) => item.status == 'pending' || item.status == 'processing')
        .length;
    final failedItems = items.where((item) => item.status == 'failed').toList();
    _status.value = _status.value.copyWith(
      isAuthenticated: isAuthenticated,
      pendingCount: pendingCount,
      failedCount: failedItems.length,
      lastError: failedItems.isEmpty ? null : failedItems.last.lastError,
    );
  }

  @override
  Future<void> syncNow({required Session? session}) async {
    await refreshStatus(isAuthenticated: session != null);
    if (session == null) {
      _status.value = _status.value.copyWith(
        isAuthenticated: false,
        isSyncing: false,
        lastError: 'Entre em uma conta para sincronizar.',
      );
      return;
    }

    final userId = session.user.id;
    _status.value = _status.value.copyWith(
      isAuthenticated: true,
      isSyncing: true,
      lastError: null,
    );

    final items = await _database.getSyncQueueItems(
      statuses: const ['pending', 'failed'],
    );

    for (final item in items) {
      await _database.markSyncQueueProcessing(item.id, userId: userId);
      try {
        await _applyRemoteMutation(item, userId: userId);
        await _database.markSyncQueueSynced(item.id, userId: userId);
      } catch (error) {
        await _database.markSyncQueueFailed(
          item.id,
          userId: userId,
          retryCount: item.retryCount + 1,
          lastError: error.toString(),
        );
      }
    }

    await _database.clearSyncedQueueItems();
    await _pullRemoteState(userId: userId);
    await refreshStatus(isAuthenticated: true);
    _status.value = _status.value.copyWith(
      isSyncing: false,
      lastSyncedAt: DateTime.now(),
    );
  }

  Future<void> _applyRemoteMutation(
    SyncQueueTableData item, {
    required String userId,
  }) async {
    final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;
    final table = item.localEntityType;

    if (item.operation == 'delete') {
      await _client.from(table).delete().eq('id', item.localEntityId);
      return;
    }

    final remotePayload = _buildRemotePayload(
      table: table,
      userId: userId,
      payload: payload,
    );
    await _client.from(table).upsert(remotePayload);
  }

  Map<String, dynamic> _buildRemotePayload({
    required String table,
    required String userId,
    required Map<String, dynamic> payload,
  }) {
    final now = DateTime.now().toUtc().toIso8601String();
    return switch (table) {
      'profiles' => {
          'id': userId,
          'user_id': userId,
          'display_name': payload['displayName'],
          'theme_preference': payload['themePreference'],
          'updated_at': now,
        },
      'accounts' => {
          'id': payload['id'],
          'user_id': userId,
          'name': payload['name'],
          'type': payload['type'],
          'initial_balance': payload['balance'],
          'current_balance': payload['balance'],
          'updated_at': now,
        },
      'cards' => {
          'id': payload['id'],
          'user_id': userId,
          'name': payload['name'],
          'bank_name': payload['bankName'],
          'skin_key': payload['bankName'],
          'limit_amount': payload['limitAmount'],
          'current_used_amount': payload['currentInvoice'],
          'updated_at': now,
        },
      'categories' => {
          'id': payload['name'],
          'user_id': userId,
          'name': payload['name'],
          'kind': 'expense',
          'icon_key': 'circle',
          'color': 'neutral',
          'is_system': false,
          'updated_at': now,
        },
      'goals' => {
          'id': payload['id'],
          'user_id': userId,
          'name': payload['name'],
          'target_amount': payload['targetAmount'],
          'current_amount': payload['currentAmount'],
          'status': 'active',
          'updated_at': now,
        },
      'budgets' => {
          'id': payload['id'],
          'user_id': userId,
          'category_id': payload['category'],
          'period_month': payload['periodMonth'],
          'period_year': payload['periodYear'],
          'budget_amount': payload['limitAmount'],
          'alert_threshold_percent': payload['alertThresholdPercent'],
          'updated_at': now,
        },
      'subscriptions' => {
          'id': payload['id'],
          'user_id': userId,
          'name': payload['name'],
          'amount': payload['amount'],
          'billing_cycle': payload['billingCycle'],
          'next_charge_date': payload['nextChargeDate'],
          'is_active': payload['isActive'],
          'detection_source': payload['detectionSource'],
          'updated_at': now,
        },
      'calendar_events' => {
          'id': payload['id'],
          'user_id': userId,
          'type': payload['type'],
          'title': payload['title'],
          'description': payload['description'],
          'event_date': payload['eventDate'],
          'amount': payload['amount'],
          'updated_at': now,
        },
      'transactions' => {
          'id': payload['id'],
          'user_id': userId,
          'category_id': payload['category'],
          'type': payload['type'],
          'amount': payload['amount'],
          'description': payload['description'],
          'source_label': payload['sourceLabel'],
          'transaction_date': payload['occuredAt'],
          'created_via': 'app',
          'updated_at': now,
        },
      _ => {
          ...payload,
          'user_id': userId,
          'updated_at': now,
        },
    };
  }

  Future<void> _pullRemoteState({
    required String userId,
  }) async {
    if (_target == null) {
      return;
    }

    final profileResponse = await _client
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    final accountsResponse = await _client
        .from('accounts')
        .select()
        .eq('user_id', userId);
    final cardsResponse = await _client.from('cards').select().eq('user_id', userId);
    final categoriesResponse = await _client
        .from('categories')
        .select()
        .or('user_id.eq.$userId,user_id.is.null');
    final goalsResponse = await _client.from('goals').select().eq('user_id', userId);
    final budgetsResponse = await _client.from('budgets').select().eq('user_id', userId);
    final subscriptionsResponse =
        await _client.from('subscriptions').select().eq('user_id', userId);
    final calendarEventsResponse =
        await _client.from('calendar_events').select().eq('user_id', userId);
    final transactionsResponse = await _client
        .from('transactions')
        .select()
        .eq('user_id', userId);

    final profile = profileResponse == null
        ? const UserPreferences(
            displayName: 'Você',
            appearance: AppAppearance.calm,
          )
        : UserPreferences(
            displayName: profileResponse['display_name'] as String? ?? 'Você',
            appearance: AppAppearance.values.firstWhere(
              (value) =>
                  value.name ==
                  (profileResponse['theme_preference'] as String? ?? 'calm'),
              orElse: () => AppAppearance.calm,
            ),
          );

    final accounts = (accountsResponse as List<dynamic>)
        .map(
          (item) => Account(
            id: item['id'] as String,
            name: item['name'] as String,
            type: item['type'] as String? ?? 'corrente',
            balance: (item['current_balance'] as num?)?.toDouble() ??
                (item['initial_balance'] as num?)?.toDouble() ??
                0,
          ),
        )
        .toList();

    final cards = (cardsResponse as List<dynamic>)
        .map(
          (item) => PaymentCard(
            id: item['id'] as String,
            bankName: item['bank_name'] as String? ?? 'Banco',
            name: item['name'] as String? ?? 'Cartão',
            maskedNumber: '•••• ${(item['id'] as String).substring(0, 4)}',
            limitAmount: (item['limit_amount'] as num?)?.toDouble() ?? 0,
            availableAmount:
                ((item['limit_amount'] as num?)?.toDouble() ?? 0) -
                    ((item['current_used_amount'] as num?)?.toDouble() ?? 0),
            currentInvoice:
                (item['current_used_amount'] as num?)?.toDouble() ?? 0,
            closingLabel: 'Fechamento',
            dueLabel: 'Vencimento',
            backgroundColor: 0xFF111827,
            accentColor: 0xFFF3F4F6,
          ),
        )
        .toList();

    final categories = (categoriesResponse as List<dynamic>)
        .map((item) => item['name'] as String)
        .toSet()
        .toList();

    final goals = (goalsResponse as List<dynamic>)
        .map(
          (item) => Goal(
            id: item['id'] as String,
            name: item['name'] as String,
            targetAmount: (item['target_amount'] as num?)?.toDouble() ?? 0,
            currentAmount: (item['current_amount'] as num?)?.toDouble() ?? 0,
            estimatedLabel:
                (item['target_date'] as String?)?.split('T').first ?? 'Sem prazo',
          ),
        )
        .toList();

    final budgets = (budgetsResponse as List<dynamic>)
        .map(
          (item) => Budget(
            id: item['id'] as String,
            category: item['category_id'] as String? ?? 'Outros',
            periodMonth: item['period_month'] as int? ?? DateTime.now().month,
            periodYear: item['period_year'] as int? ?? DateTime.now().year,
            limitAmount: (item['budget_amount'] as num?)?.toDouble() ?? 0,
            usedAmount: 0,
            alertThresholdPercent:
                (item['alert_threshold_percent'] as num?)?.toDouble() ?? 80,
          ),
        )
        .toList();

    final subscriptions = (subscriptionsResponse as List<dynamic>)
        .map(
          (item) => SubscriptionModel(
            id: item['id'] as String,
            name: item['name'] as String,
            amount: (item['amount'] as num?)?.toDouble() ?? 0,
            billingCycle: item['billing_cycle'] as String? ?? 'monthly',
            nextChargeDate: DateTime.tryParse(
                  item['next_charge_date'] as String? ?? '',
                ) ??
                DateTime.now(),
            isActive: item['is_active'] as bool? ?? true,
            detectionSource: item['detection_source'] as String? ?? 'manual',
          ),
        )
        .toList();

    final calendarEvents = (calendarEventsResponse as List<dynamic>)
        .map(
          (item) => CalendarEventModel(
            id: item['id'] as String,
            type: item['type'] as String? ?? 'custom',
            title: item['title'] as String? ?? 'Evento',
            description: item['description'] as String? ?? '',
            eventDate: DateTime.tryParse(item['event_date'] as String? ?? '') ??
                DateTime.now(),
            amount: (item['amount'] as num?)?.toDouble(),
          ),
        )
        .toList();

    final transactions = (transactionsResponse as List<dynamic>)
        .map(
          (item) => TransactionModel(
            id: item['id'] as String,
            title: item['category_id'] as String? ?? 'Movimentação',
            description: item['description'] as String? ?? '',
            amount: (item['amount'] as num?)?.toDouble() ?? 0,
            type: TransactionType.values.firstWhere(
              (value) => value.name == item['type'],
              orElse: () => TransactionType.expense,
            ),
            occuredAt: DateTime.tryParse(
                  item['transaction_date'] as String? ?? '',
                ) ??
                DateTime.now(),
            sourceLabel: item['source_label'] as String? ?? 'Origem',
            category: item['category_id'] as String? ?? 'Outros',
          ),
        )
        .toList();

    await _target.applyRemoteSnapshot(
      preferences: profile,
      completedWelcome: true,
      accounts: accounts,
      cards: cards,
      categories: categories,
      goals: goals,
      budgets: budgets,
      subscriptions: subscriptions,
      calendarEvents: calendarEvents,
      transactions: transactions,
    );
  }
}
