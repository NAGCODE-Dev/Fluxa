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

abstract class LocalDatasource {
  bool getHasCompletedWelcome();
  UserPreferences getPreferences();
  DashboardSummary getDashboardSummary();
  List<TransactionModel> getTransactions();
  List<PaymentCard> getCards();
  List<Account> getAccounts();
  List<String> getCategories();
  List<String> getExpenseSources();
  List<Goal> getGoals();
  List<Budget> getBudgets();
  List<SubscriptionModel> getSubscriptions();
  List<CalendarEventModel> getCalendarEvents();
  ExpenseDraft getExpenseDraft();
  Future<void> savePreferences(
    UserPreferences preferences, {
    required bool completedWelcome,
  });
  Future<void> addExpense(ExpenseDraft draft);
  Future<void> saveTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String transactionId);
  Future<void> saveAccount(Account account);
  Future<void> deleteAccount(String accountId);
  Future<void> saveCard(PaymentCard card);
  Future<void> deleteCard(String cardId);
  Future<void> saveCategory(String category);
  Future<void> deleteCategory(String category);
  Future<void> saveGoal(Goal goal);
  Future<void> deleteGoal(String goalId);
  Future<void> saveBudget(Budget budget);
  Future<void> deleteBudget(String budgetId);
  Future<void> saveSubscription(SubscriptionModel subscription);
  Future<void> deleteSubscription(String subscriptionId);
  Future<void> saveCalendarEvent(CalendarEventModel event);
  Future<void> deleteCalendarEvent(String eventId);
  Future<String> exportData();
  Future<void> importData(String rawData);
}
