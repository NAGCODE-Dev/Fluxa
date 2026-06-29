import 'dart:async';
import 'dart:convert';

import 'package:fluxa/core/sync/remote_sync_target.dart';
import 'package:fluxa/core/sync/sync_status.dart';
import 'package:fluxa/data/local/app_database.dart';
import 'package:fluxa/models/account.dart';
import 'package:fluxa/models/card.dart';
import 'package:fluxa/models/goal.dart';
import 'package:fluxa/models/transaction.dart';
import 'package:fluxa/models/user_preferences.dart';
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
  static const _remoteSyncEntityTypes = {
    'profiles',
    'accounts',
    'cards',
    'categories',
    'goals',
    'transactions',
  };

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

    try {
      final items = await _database.getSyncQueueItems(
        statuses: const ['pending', 'failed'],
      );

      for (final item in items) {
        await _database.markSyncQueueProcessing(item.id, userId: userId);
        try {
          if (!_remoteSyncEntityTypes.contains(item.localEntityType)) {
            await _database.markSyncQueueSynced(item.id, userId: userId);
            continue;
          }
          await _applyRemoteMutation(item, userId: userId);
          await _database.markSyncQueueSynced(item.id, userId: userId);
        } catch (error) {
          await _database.markSyncQueueFailed(
            item.id,
            userId: userId,
            retryCount: item.retryCount + 1,
            lastError: _describeSyncError(error),
          );
        }
      }

      await _database.clearSyncedQueueItems();
      await _pullRemoteState(userId: userId);
      await refreshStatus(isAuthenticated: true);
      _status.value = _status.value.copyWith(
        isSyncing: false,
        lastSyncedAt: DateTime.now(),
        lastError: null,
      );
    } catch (error) {
      _status.value = _status.value.copyWith(
        isSyncing: false,
        lastError: _describeSyncError(error),
      );
    }
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
      budgets: const [],
      subscriptions: const [],
      calendarEvents: const [],
      transactions: transactions,
    );
  }

  String _describeSyncError(Object error) {
    if (error is PostgrestException && error.code == 'PGRST205') {
      return 'O schema remoto do Supabase ainda nao foi aplicado. Rode as migrations da pasta supabase/migrations no projeto.';
    }
    return error.toString();
  }
}
