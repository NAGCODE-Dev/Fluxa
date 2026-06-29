import 'package:financas/data/datasources/local_datasource.dart';
import 'package:financas/models/card.dart';

class CardRepository {
  const CardRepository(this._localDatasource);

  final LocalDatasource _localDatasource;

  List<PaymentCard> listCards() {
    return _localDatasource.getCards();
  }
}
