import 'package:financas/data/datasources/local_datasource.dart';
import 'package:financas/models/card.dart';

class CardRepository {
  const CardRepository(this._localDatasource);

  final LocalDatasource _localDatasource;

  List<PaymentCard> listCards() {
    return _localDatasource.getCards();
  }

  Future<void> saveCard(PaymentCard card) {
    return _localDatasource.saveCard(card);
  }

  Future<void> deleteCard(String cardId) {
    return _localDatasource.deleteCard(cardId);
  }
}
