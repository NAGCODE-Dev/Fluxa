import 'package:financas/data/datasources/local_datasource.dart';
import 'package:financas/models/subscription.dart';

class SubscriptionRepository {
  const SubscriptionRepository(this._localDatasource);

  final LocalDatasource _localDatasource;

  List<SubscriptionModel> listSubscriptions() {
    return _localDatasource.getSubscriptions();
  }

  Future<void> saveSubscription(SubscriptionModel subscription) {
    return _localDatasource.saveSubscription(subscription);
  }

  Future<void> deleteSubscription(String subscriptionId) {
    return _localDatasource.deleteSubscription(subscriptionId);
  }
}
