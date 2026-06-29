import 'package:financas/models/subscription.dart';

final fakeSubscriptions = [
  SubscriptionModel(
    id: 'sub-spotify',
    name: 'Spotify',
    amount: 21.90,
    billingCycle: 'monthly',
    nextChargeDate: DateTime(2026, 7, 2),
    isActive: true,
    detectionSource: 'manual',
  ),
  SubscriptionModel(
    id: 'sub-google-one',
    name: 'Google One',
    amount: 9.99,
    billingCycle: 'monthly',
    nextChargeDate: DateTime(2026, 7, 5),
    isActive: true,
    detectionSource: 'manual',
  ),
];
