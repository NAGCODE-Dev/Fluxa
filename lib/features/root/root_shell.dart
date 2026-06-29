import 'dart:async';

import 'package:fluxa/core/sync/sync_service.dart';
import 'package:fluxa/core/sync/sync_status.dart';
import 'package:fluxa/data/datasources/local_datasource.dart';
import 'package:fluxa/features/add_expense/add_expense_sheet.dart';
import 'package:fluxa/features/auth/email_auth_sheet.dart';
import 'package:fluxa/features/cards/cards_page.dart';
import 'package:fluxa/features/dashboard/dashboard_page.dart';
import 'package:fluxa/features/history/history_page.dart';
import 'package:fluxa/features/welcome/welcome_page.dart';
import 'package:fluxa/models/user_preferences.dart';
import 'package:fluxa/repositories/account_repository.dart';
import 'package:fluxa/repositories/auth_repository.dart';
import 'package:fluxa/repositories/budget_repository.dart';
import 'package:fluxa/repositories/calendar_repository.dart';
import 'package:fluxa/repositories/card_repository.dart';
import 'package:fluxa/repositories/data_backup_repository.dart';
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
  late final DataBackupRepository _dataBackupRepository =
      DataBackupRepository(widget.datasource);
  late final ExpenseRepository _expenseRepository =
      ExpenseRepository(widget.datasource);
  late final GoalRepository _goalRepository = GoalRepository(widget.datasource);
  late final BudgetRepository _budgetRepository =
      BudgetRepository(widget.datasource);
  late final SubscriptionRepository _subscriptionRepository =
      SubscriptionRepository(widget.datasource);
  late final CalendarRepository _calendarRepository =
      CalendarRepository(widget.datasource);
  late UserPreferences _preferences = _preferencesRepository.getPreferences();
  late Session? _session = _authRepository.getCurrentSession();
  late SyncStatus _syncStatus = widget.syncService.status.value;
  StreamSubscription<AuthState>? _authSubscription;
  VoidCallback? _syncListener;
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
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
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
      ),
      HistoryPage(
        transactions: _transactionRepository.listTransactions(),
        subscriptions: _subscriptionRepository.listSubscriptions(),
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
        categories: _expenseRepository.getCategories(),
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
        onSaveCategory: (category) async {
          await _expenseRepository.saveCategory(category);
          setState(() {});
        },
        onDeleteCategory: (category) async {
          await _expenseRepository.deleteCategory(category);
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
        onExportData: _dataBackupRepository.exportData,
        onImportData: (rawData) async {
          await _dataBackupRepository.importData(rawData);
          setState(() {
            _preferences = _preferencesRepository.getPreferences();
            _completedWelcome = _preferencesRepository.getHasCompletedWelcome();
          });
        },
        currentSession: _session,
        onSignInWithGoogle: _signInWithGoogle,
        onSignOut: _signOut,
        onEmailAuthRequested: _submitEmailAuth,
        syncStatus: _syncStatus,
        onSyncNow: () => widget.syncService.syncNow(session: _session),
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

  Future<void> _openAddExpense() async {
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

    final result = await AddExpenseSheet.show(
      context,
      draft: _expenseRepository.getDraft(),
      categories: _expenseRepository.getCategories(),
      sources: sources,
    );

    if (result == null) {
      return;
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
