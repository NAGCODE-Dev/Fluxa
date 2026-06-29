import 'package:financas/data/datasources/local_datasource.dart';
import 'package:financas/models/expense_draft.dart';
import 'package:financas/models/transaction.dart';

class TransactionRepository {
  const TransactionRepository(this._localDatasource);

  final LocalDatasource _localDatasource;

  List<TransactionModel> listTransactions() {
    return _localDatasource.getTransactions();
  }

  Future<void> addExpense(ExpenseDraft draft) {
    return _localDatasource.addExpense(draft);
  }
}
