import 'package:financas/data/datasources/local_datasource.dart';
import 'package:financas/features/add_expense/add_expense_sheet.dart';
import 'package:financas/features/cards/cards_page.dart';
import 'package:financas/features/dashboard/dashboard_page.dart';
import 'package:financas/features/history/history_page.dart';
import 'package:financas/features/welcome/welcome_page.dart';
import 'package:financas/models/user_preferences.dart';
import 'package:financas/repositories/card_repository.dart';
import 'package:financas/repositories/dashboard_repository.dart';
import 'package:financas/repositories/expense_repository.dart';
import 'package:financas/repositories/preferences_repository.dart';
import 'package:financas/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';

class RootShell extends StatefulWidget {
  const RootShell({
    super.key,
    required this.datasource,
  });

  final LocalDatasource datasource;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  late bool _completedWelcome;
  late final PreferencesRepository _preferencesRepository =
      PreferencesRepository(widget.datasource);
  late final DashboardRepository _dashboardRepository =
      DashboardRepository(widget.datasource);
  late final TransactionRepository _transactionRepository =
      TransactionRepository(widget.datasource);
  late final CardRepository _cardRepository = CardRepository(widget.datasource);
  late final ExpenseRepository _expenseRepository =
      ExpenseRepository(widget.datasource);
  late UserPreferences _preferences = _preferencesRepository.getPreferences();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _completedWelcome = _preferencesRepository.getHasCompletedWelcome();
  }

  @override
  Widget build(BuildContext context) {
    if (!_completedWelcome) {
      return WelcomePage(
        initialPreferences: _preferences,
        onContinueLocal: _completeWelcome,
        onSyncWithGoogle: _completeWelcome,
      );
    }

    final pages = [
      DashboardPage(
        displayName: _preferences.displayName,
        summary: _dashboardRepository.getSummary(),
      ),
      HistoryPage(
        transactions: _transactionRepository.listTransactions(),
      ),
      CardsPage(
        cards: _cardRepository.listCards(),
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
        selectedIcon: Icon(Icons.credit_card_rounded),
        label: 'Cartões',
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

  Future<void> _openAddExpense() async {
    final result = await AddExpenseSheet.show(
      context,
      draft: _expenseRepository.getDraft(),
      categories: _expenseRepository.getCategories(),
    );

    if (result == null) {
      return;
    }

    await _transactionRepository.addExpense(result);
    setState(() {});
  }

  void _selectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
