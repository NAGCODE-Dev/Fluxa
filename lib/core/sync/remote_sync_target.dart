import 'package:fluxa/models/account.dart';
import 'package:fluxa/models/budget.dart';
import 'package:fluxa/models/calendar_event.dart';
import 'package:fluxa/models/card.dart';
import 'package:fluxa/models/goal.dart';
import 'package:fluxa/models/subscription.dart';
import 'package:fluxa/models/transaction.dart';
import 'package:fluxa/models/user_preferences.dart';

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
