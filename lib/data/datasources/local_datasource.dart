import 'package:financas/models/account.dart';
import 'package:financas/models/card.dart';
import 'package:financas/models/dashboard_summary.dart';
import 'package:financas/models/expense_draft.dart';
import 'package:financas/models/transaction.dart';
import 'package:financas/models/user_preferences.dart';

abstract class LocalDatasource {
  bool getHasCompletedWelcome();
  UserPreferences getPreferences();
  DashboardSummary getDashboardSummary();
  List<TransactionModel> getTransactions();
  List<PaymentCard> getCards();
  List<Account> getAccounts();
  List<String> getCategories();
  ExpenseDraft getExpenseDraft();
  Future<void> savePreferences(
    UserPreferences preferences, {
    required bool completedWelcome,
  });
  Future<void> addExpense(ExpenseDraft draft);
}
