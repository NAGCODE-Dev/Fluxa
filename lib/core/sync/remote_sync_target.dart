import 'package:financas/models/account.dart';
import 'package:financas/models/budget.dart';
import 'package:financas/models/calendar_event.dart';
import 'package:financas/models/card.dart';
import 'package:financas/models/goal.dart';
import 'package:financas/models/subscription.dart';
import 'package:financas/models/transaction.dart';
import 'package:financas/models/user_preferences.dart';

abstract class RemoteSyncTarget {
  Future<void> applyRemoteSnapshot({
    required UserPreferences preferences,
    required bool completedWelcome,
    required List<Account> accounts,
    required List<PaymentCard> cards,
    required List<String> categories,
    required List<Goal> goals,
    required List<Budget> budgets,
    required List<SubscriptionModel> subscriptions,
    required List<CalendarEventModel> calendarEvents,
    required List<TransactionModel> transactions,
  });
}
