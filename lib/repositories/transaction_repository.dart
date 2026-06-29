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

  Future<void> saveTransaction(TransactionModel transaction) {
    return _localDatasource.saveTransaction(transaction);
  }

  Future<void> deleteTransaction(String transactionId) {
    return _localDatasource.deleteTransaction(transactionId);
  }

  Future<String> exportData() {
    return _localDatasource.exportData();
  }

  Future<void> importData(String rawData) {
    return _localDatasource.importData(rawData);
  }
}
