import 'dart:async';

import 'package:fluxa/core/sync/sync_service.dart';
import 'package:fluxa/core/sync/sync_status.dart';
import 'package:fluxa/core/notifications/notification_capture_service.dart';
import 'package:fluxa/core/theme/colors.dart';
import 'package:fluxa/data/datasources/local_datasource.dart';
import 'package:fluxa/features/add_expense/add_expense_sheet.dart';
import 'package:fluxa/features/auth/email_auth_sheet.dart';
import 'package:fluxa/features/cards/cards_page.dart';
import 'package:fluxa/features/dashboard/dashboard_page.dart';
import 'package:fluxa/features/history/history_page.dart';
import 'package:fluxa/features/welcome/welcome_page.dart';
import 'package:fluxa/models/expense_draft.dart';
import 'package:fluxa/models/user_preferences.dart';
import 'package:fluxa/shared/widgets/app_bottom_sheet.dart';
import 'package:fluxa/shared/widgets/app_card.dart';
import 'package:fluxa/repositories/account_repository.dart';
import 'package:fluxa/repositories/auth_repository.dart';
import 'package:fluxa/repositories/budget_repository.dart';
import 'package:fluxa/repositories/calendar_repository.dart';
import 'package:fluxa/repositories/card_repository.dart';
import 'package:fluxa/repositories/dashboard_repository.dart';
import 'package:fluxa/repositories/expense_repository.dart';
import 'package:fluxa/repositories/goal_repository.dart';
import 'package:fluxa/repositories/preferences_repository.dart';
import 'package:fluxa/repositories/subscription_repository.dart';
import 'package:fluxa/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RootShell extends StatefulWidget {
  const RootShell({
    super.key,
    required this.datasource,
    required this.syncService,
  });

  final LocalDatasource datasource;
  final SyncService syncService;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  late bool _completedWelcome;
  late final PreferencesRepository _preferencesRepository =
      PreferencesRepository(widget.datasource);
  late final AuthRepository _authRepository = AuthRepository();
  late final DashboardRepository _dashboardRepository =
      DashboardRepository(widget.datasource);
  late final TransactionRepository _transactionRepository =
      TransactionRepository(widget.datasource);
  late final AccountRepository _accountRepository =
      AccountRepository(widget.datasource);
  late final CardRepository _cardRepository = CardRepository(widget.datasource);
  late final ExpenseRepository _expenseRepository =
      ExpenseRepository(widget.datasource);
  late final GoalRepository _goalRepository = GoalRepository(widget.datasource);
  late final BudgetRepository _budgetRepository =
      BudgetRepository(widget.datasource);
  late final SubscriptionRepository _subscriptionRepository =
      SubscriptionRepository(widget.datasource);
  late final CalendarRepository _calendarRepository =
      CalendarRepository(widget.datasource);
  late final NotificationCaptureService _notificationCaptureService =
      NotificationCaptureService();
  late UserPreferences _preferences = _preferencesRepository.getPreferences();
  late Session? _session = _authRepository.getCurrentSession();
  late SyncStatus _syncStatus = widget.syncService.status.value;
  StreamSubscription<AuthState>? _authSubscription;
  StreamSubscription<CapturedExpenseSuggestion>? _notificationSubscription;
  VoidCallback? _syncListener;
  String? _lastNotificationSuggestionId;
  final List<CapturedExpenseSuggestion> _pendingSuggestions = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _completedWelcome = _preferencesRepository.getHasCompletedWelcome();
    _syncListener = () {
      if (!mounted) {
        return;
      }
      setState(() {
        _syncStatus = widget.syncService.status.value;
      });
    };
    widget.syncService.status.addListener(_syncListener!);
    _authSubscription = _authRepository.authStateChanges().listen((state) {
      if (!mounted) {
        return;
      }
      setState(() {
        _session = state.session;
      });
      unawaited(
        widget.syncService.refreshStatus(
          isAuthenticated: state.session != null,
        ),
      );
      if (state.session != null) {
        unawaited(widget.syncService.syncNow(session: state.session));
      }
    });
    unawaited(
      widget.syncService.refreshStatus(
        isAuthenticated: _session != null,
      ),
    );
    _startNotificationCapture();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _notificationSubscription?.cancel();
    if (_syncListener != null) {
      widget.syncService.status.removeListener(_syncListener!);
    }
    widget.syncService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_completedWelcome) {
      return WelcomePage(
        initialPreferences: _preferences,
        onContinueLocal: _completeWelcome,
        onSyncWithGoogle: _connectGoogleSync,
        onSyncWithEmail: _connectEmailSync,
      );
    }

    final pages = [
      DashboardPage(
        displayName: _preferences.displayName,
        summary: _dashboardRepository.getSummary(),
        accounts: _accountRepository.listAccounts(),
        cards: _cardRepository.listCards(),
        headerAction: _buildProfileButton(),
      ),
      HistoryPage(
        transactions: _transactionRepository.listTransactions(),
        subscriptions: _subscriptionRepository.listSubscriptions(),
        headerAction: _buildProfileButton(),
        onSaveTransaction: (transaction) async {
          await _transactionRepository.saveTransaction(transaction);
          setState(() {});
        },
        onDeleteTransaction: (transactionId) async {
          await _transactionRepository.deleteTransaction(transactionId);
          setState(() {});
        },
      ),
      CardsPage(
        accounts: _accountRepository.listAccounts(),
        cards: _cardRepository.listCards(),
        goals: _goalRepository.listGoals(),
        budgets: _budgetRepository.listBudgets(),
        subscriptions: _subscriptionRepository.listSubscriptions(),
        calendarEvents: _calendarRepository.listCalendarEvents(),
        onSaveAccount: (account) async {
          await _accountRepository.saveAccount(account);
          setState(() {});
        },
        onDeleteAccount: (accountId) async {
          await _accountRepository.deleteAccount(accountId);
          setState(() {});
        },
        onSaveCard: (card) async {
          await _cardRepository.saveCard(card);
          setState(() {});
        },
        onDeleteCard: (cardId) async {
          await _cardRepository.deleteCard(cardId);
          setState(() {});
        },
        onSaveGoal: (goal) async {
          await _goalRepository.saveGoal(goal);
          setState(() {});
        },
        onDeleteGoal: (goalId) async {
          await _goalRepository.deleteGoal(goalId);
          setState(() {});
        },
        onSaveBudget: (budget) async {
          await _budgetRepository.saveBudget(budget);
          setState(() {});
        },
        onDeleteBudget: (budgetId) async {
          await _budgetRepository.deleteBudget(budgetId);
          setState(() {});
        },
        onSaveSubscription: (subscription) async {
          await _subscriptionRepository.saveSubscription(subscription);
          setState(() {});
        },
        onDeleteSubscription: (subscriptionId) async {
          await _subscriptionRepository.deleteSubscription(subscriptionId);
          setState(() {});
        },
        onSaveCalendarEvent: (event) async {
          await _calendarRepository.saveCalendarEvent(event);
          setState(() {});
        },
        onDeleteCalendarEvent: (eventId) async {
          await _calendarRepository.deleteCalendarEvent(eventId);
          setState(() {});
        },
        headerAction: _buildProfileButton(),
      ),
    ];

    const destinations = [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
        label: 'Início',
      ),
      NavigationDestination(
        icon: Icon(Icons.receipt_long_outlined),
        selectedIcon: Icon(Icons.receipt_long_rounded),
        label: 'Histórico',
      ),
      NavigationDestination(
        icon: Icon(Icons.credit_card_outlined),
        selectedIcon: Icon(Icons.event_note_rounded),
        label: 'Planejamento',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;

        if (wide) {
          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  NavigationRail(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: _selectTab,
                    labelType: NavigationRailLabelType.all,
                    destinations: destinations
                        .map((item) => NavigationRailDestination(
                              icon: item.icon,
                              selectedIcon: item.selectedIcon,
                              label: Text(item.label),
                            ))
                        .toList(),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: pages[_currentIndex]),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: _openAddExpense,
              label: const Text('Adicionar gasto'),
              icon: const Icon(Icons.add_rounded),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(child: pages[_currentIndex]),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openAddExpense,
            label: const Text('Adicionar gasto'),
            icon: const Icon(Icons.add_rounded),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            destinations: destinations,
            onDestinationSelected: _selectTab,
          ),
        );
      },
    );
  }

  Future<void> _completeWelcome(UserPreferences preferences) async {
    await _preferencesRepository.savePreferences(
      preferences,
      completedWelcome: true,
    );
    setState(() {
      _preferences = preferences;
      _completedWelcome = true;
    });
  }

  Future<void> _connectGoogleSync(UserPreferences preferences) async {
    await _completeWelcome(preferences);
    await _signInWithGoogle();
  }

  Future<void> _connectEmailSync(UserPreferences preferences) async {
    await _completeWelcome(preferences);
    if (!mounted) {
      return;
    }
    final result = await EmailAuthSheet.show(context);
    if (result == null) {
      return;
    }
    await _submitEmailAuth(result);
  }

  Future<void> _openAddExpense({
    ExpenseDraft? initialDraft,
    CapturedExpenseSuggestion? capturedSuggestion,
  }) async {
    final sources = _expenseRepository.getSources();
    if (sources.isEmpty) {
      setState(() {
        _currentIndex = 2;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastre uma conta ou cartão antes de registrar um gasto.'),
        ),
      );
      return;
    }

    final categories = _expenseRepository.getCategories();
    final draft = initialDraft ?? _expenseRepository.getDraft();
    final availableCategories = categories.contains(draft.category)
        ? categories
        : [...categories, draft.category];

    final result = await AddExpenseSheet.show(
      context,
      draft: draft,
      categories: availableCategories,
      sources: sources,
      onCreateCategory: () async {
        final created = await _showQuickCategoryCreate();
        if (created == null) {
          return null;
        }
        await _expenseRepository.saveCategory(created);
        setState(() {});
        return created;
      },
      brandSignal: capturedSuggestion?.brand,
      detectedTitle: capturedSuggestion?.title,
    );

    if (result == null) {
      return;
    }

    if (!_expenseRepository.getCategories().contains(result.category)) {
      await _expenseRepository.saveCategory(result.category);
    }
    await _transactionRepository.addExpense(result);
    await widget.syncService.refreshStatus(
      isAuthenticated: _session != null,
    );
    setState(() {});
  }

  void _selectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _authRepository.signInWithGoogle();
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('Não foi possível iniciar o login com Google agora.');
    }
  }

  Widget _buildProfileButton() {
    final avatarUrl = _session?.user.userMetadata?['avatar_url'] as String? ??
        _session?.user.userMetadata?['picture'] as String?;
    final fallbackLabel = (_session?.user.email?.trim().isNotEmpty ?? false)
        ? _session!.user.email!.trim()
        : _preferences.displayName.trim();
    final showInitial =
        _session != null && (avatarUrl == null || avatarUrl.trim().isEmpty);
    final initial = fallbackLabel.isEmpty ? 'P' : fallbackLabel.characters.first.toUpperCase();

    return IconButton(
      tooltip: 'Perfil, contas e alertas',
      onPressed: _openProfileSheet,
      icon: Badge(
        isLabelVisible: _pendingSuggestions.isNotEmpty,
        label: Text('${_pendingSuggestions.length}'),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primary,
          backgroundImage:
              avatarUrl != null && avatarUrl.trim().isNotEmpty ? NetworkImage(avatarUrl) : null,
          child: avatarUrl != null && avatarUrl.trim().isNotEmpty
              ? null
              : Text(
                  showInitial ? initial : 'P',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
        ),
      ),
    );
  }

  Future<void> _openProfileSheet() async {
    final action = await AppBottomSheet.show<_ProfileAction>(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _session?.user.email ?? _preferences.displayName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                _session == null
                    ? 'Entre para sincronizar seus dados entre aparelhos.'
                    : _syncStatus.isSyncing
                        ? 'Sincronizando seus dados agora.'
                        : _syncStatus.failedCount > 0
                            ? 'Conta conectada, com ${_syncStatus.failedCount} item(ns) pendente(s).'
                            : _syncStatus.lastSyncedAt != null
                                ? 'Conta conectada. Última sincronização concluída.'
                                : 'Conta conectada e pronta para sincronizar.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 18),
              if (_pendingSuggestions.isNotEmpty) ...[
                Text(
                  'Sugestões de gastos',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                ..._pendingSuggestions.map(
                  (suggestion) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _PendingSuggestionTile(
                      suggestion: suggestion,
                      onRegister: () => Navigator.of(context).pop(
                        _ProfileAction.registerSuggestion(suggestion.id),
                      ),
                      onDismiss: () => Navigator.of(context).pop(
                        _ProfileAction.dismissSuggestion(suggestion.id),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (_session == null) ...[
                _ProfileActionTile(
                  icon: Icons.g_mobiledata_rounded,
                  label: 'Entrar com Google',
                  onTap: () => Navigator.of(context).pop(const _ProfileAction.google()),
                ),
                const SizedBox(height: 10),
                _ProfileActionTile(
                  icon: Icons.alternate_email_rounded,
                  label: 'Entrar com e-mail',
                  onTap: () => Navigator.of(context).pop(const _ProfileAction.email()),
                ),
              ] else ...[
                _ProfileActionTile(
                  icon: Icons.credit_card_rounded,
                  label: 'Ir para planejamento',
                  onTap: () => Navigator.of(context).pop(const _ProfileAction.planning()),
                ),
                const SizedBox(height: 10),
                _ProfileActionTile(
                  icon: Icons.logout_rounded,
                  label: 'Sair da conta',
                  destructive: true,
                  onTap: () => Navigator.of(context).pop(const _ProfileAction.signOut()),
                ),
              ],
              if (_notificationCaptureService.isSupported) ...[
                const SizedBox(height: 10),
                _ProfileActionTile(
                  icon: Icons.notifications_active_outlined,
                  label: 'Captura por notificações',
                  onTap: () => Navigator.of(context).pop(const _ProfileAction.notifications()),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (action == null || !mounted) {
      return;
    }

    switch (action.type) {
      case _ProfileActionType.google:
        await _signInWithGoogle();
        return;
      case _ProfileActionType.email:
        final result = await EmailAuthSheet.show(context);
        if (!mounted || result == null) {
          return;
        }
        await _submitEmailAuth(result);
        return;
      case _ProfileActionType.planning:
        _selectTab(2);
        return;
      case _ProfileActionType.signOut:
        await _signOut();
        return;
      case _ProfileActionType.notifications:
        await _openNotificationCaptureConsent();
        return;
      case _ProfileActionType.registerSuggestion:
        final suggestion = _takePendingSuggestion(action.suggestionId);
        if (suggestion != null) {
          await _openCapturedExpenseSuggestion(suggestion);
        }
        return;
      case _ProfileActionType.dismissSuggestion:
        _removePendingSuggestion(action.suggestionId);
        return;
    }
  }

  void _startNotificationCapture() {
    if (!_notificationCaptureService.isSupported) {
      return;
    }

    _notificationSubscription = _notificationCaptureService.suggestions.listen(
      _handleCapturedExpenseSuggestion,
    );
    unawaited(_showLastCapturedSuggestionIfNeeded());
  }

  Future<void> _showLastCapturedSuggestionIfNeeded() async {
    final suggestion = await _notificationCaptureService.getLastSuggestion();
    if (suggestion != null) {
      _handleCapturedExpenseSuggestion(suggestion);
    }
  }

  void _handleCapturedExpenseSuggestion(CapturedExpenseSuggestion suggestion) {
    if (!mounted || !_completedWelcome || suggestion.id == _lastNotificationSuggestionId) {
      return;
    }
    _lastNotificationSuggestionId = suggestion.id;
    _addPendingSuggestion(suggestion);

    final formattedAmount = suggestion.amount.toStringAsFixed(2).replaceAll('.', ',');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: suggestion.brand.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                suggestion.brand.icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${suggestion.brand.label}: R\$ $formattedAmount em ${suggestion.title}.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Registrar',
          onPressed: () => unawaited(_openCapturedExpenseSuggestion(suggestion)),
        ),
      ),
    );
  }

  Future<void> _openCapturedExpenseSuggestion(
    CapturedExpenseSuggestion suggestion,
  ) async {
    _removePendingSuggestion(suggestion.id);
    final sources = _expenseRepository.getSources();
    if (sources.isEmpty) {
      setState(() {
        _currentIndex = 2;
      });
      _showMessage('Cadastre uma conta ou cartão para registrar essa compra.');
      return;
    }

    await _openAddExpense(
      initialDraft: suggestion.toDraft(source: sources.first),
      capturedSuggestion: suggestion,
    );
  }

  void _addPendingSuggestion(CapturedExpenseSuggestion suggestion) {
    setState(() {
      _pendingSuggestions.removeWhere((item) => item.id == suggestion.id);
      _pendingSuggestions.insert(0, suggestion);
      if (_pendingSuggestions.length > 8) {
        _pendingSuggestions.removeRange(8, _pendingSuggestions.length);
      }
    });
  }

  CapturedExpenseSuggestion? _takePendingSuggestion(String? id) {
    if (id == null) {
      return null;
    }
    final index = _pendingSuggestions.indexWhere((item) => item.id == id);
    if (index == -1) {
      return null;
    }
    final suggestion = _pendingSuggestions[index];
    setState(() {
      _pendingSuggestions.removeAt(index);
    });
    return suggestion;
  }

  void _removePendingSuggestion(String? id) {
    if (id == null) {
      return;
    }
    setState(() {
      _pendingSuggestions.removeWhere((item) => item.id == id);
    });
  }

  Future<void> _openNotificationCaptureConsent() async {
    final enabled = await _notificationCaptureService.isEnabled();
    if (!mounted) {
      return;
    }

    if (enabled) {
      _showMessage('Captura por notificações já está ativa neste aparelho.');
      return;
    }

    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Captura por notificações',
                style: Theme.of(dialogContext).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                'O Fluxa pode ler notificações do Android para encontrar possíveis compras. Nada é registrado sozinho: você revisa e confirma antes de salvar.',
                style: Theme.of(dialogContext).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Ative apenas se concordar que o app leia notificações deste aparelho para criar sugestões de gastos.',
                style: Theme.of(dialogContext).textTheme.bodySmall,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Abrir configurações'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Agora não'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (accepted != true) {
      return;
    }

    await _notificationCaptureService.openSettings();
  }

  Future<String?> _showQuickCategoryCreate() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
          ),
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nova categoria',
                  style: Theme.of(dialogContext).textTheme.headlineSmall,
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Nome da categoria',
                    hintText: 'Ex.: Educação',
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      final value = controller.text.trim();
                      if (value.isEmpty) {
                        return;
                      }
                      Navigator.of(dialogContext).pop(value);
                    },
                    child: const Text('Salvar categoria'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    controller.dispose();
    return result;
  }

  Future<void> _submitEmailAuth(EmailAuthResult result) async {
    try {
      if (result.mode == EmailAuthMode.signUp) {
        await _authRepository.signUpWithEmail(
          email: result.email,
          password: result.password,
        );
        _showMessage('Conta criada. Verifique seu e-mail se a confirmação estiver habilitada.');
        return;
      }

      await _authRepository.signInWithEmail(
        email: result.email,
        password: result.password,
      );
      _showMessage('Sincronização ativada neste aparelho.');
      await widget.syncService.syncNow(session: _authRepository.getCurrentSession());
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('Não foi possível autenticar com e-mail agora.');
    }
  }

  Future<void> _signOut() async {
    try {
      await _authRepository.signOut();
      await widget.syncService.refreshStatus(isAuthenticated: false);
      _showMessage('Sincronização desativada neste aparelho.');
    } on AuthException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('Não foi possível sair da conta agora.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

enum _ProfileActionType {
  google,
  email,
  planning,
  signOut,
  notifications,
  registerSuggestion,
  dismissSuggestion,
}

class _ProfileAction {
  const _ProfileAction._(this.type, [this.suggestionId]);

  const _ProfileAction.google() : this._(_ProfileActionType.google);
  const _ProfileAction.email() : this._(_ProfileActionType.email);
  const _ProfileAction.planning() : this._(_ProfileActionType.planning);
  const _ProfileAction.signOut() : this._(_ProfileActionType.signOut);
  const _ProfileAction.notifications() : this._(_ProfileActionType.notifications);
  const _ProfileAction.registerSuggestion(String suggestionId)
      : this._(_ProfileActionType.registerSuggestion, suggestionId);
  const _ProfileAction.dismissSuggestion(String suggestionId)
      : this._(_ProfileActionType.dismissSuggestion, suggestionId);

  final _ProfileActionType type;
  final String? suggestionId;
}

class _PendingSuggestionTile extends StatelessWidget {
  const _PendingSuggestionTile({
    required this.suggestion,
    required this.onRegister,
    required this.onDismiss,
  });

  final CapturedExpenseSuggestion suggestion;
  final VoidCallback onRegister;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final amount = suggestion.amount.toStringAsFixed(2).replaceAll('.', ',');
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: suggestion.brand.color.withValues(alpha: 0.12),
        border: Border.all(color: suggestion.brand.color.withValues(alpha: 0.28)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: suggestion.brand.color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              suggestion.brand.icon,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion.brand.label,
                  style: textTheme.labelLarge?.copyWith(
                    color: suggestion.brand.color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  suggestion.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
                Text(
                  'R\$ $amount • ${suggestion.category}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Ignorar',
            onPressed: onDismiss,
            icon: const Icon(Icons.close_rounded),
          ),
          IconButton.filled(
            tooltip: 'Registrar',
            onPressed: onRegister,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? Theme.of(context).colorScheme.error : null;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: color,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
