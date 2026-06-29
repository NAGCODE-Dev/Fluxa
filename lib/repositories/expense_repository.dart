import 'package:financas/data/datasources/local_datasource.dart';
import 'package:financas/models/expense_draft.dart';

class ExpenseRepository {
  const ExpenseRepository(this._localDatasource);

  final LocalDatasource _localDatasource;

  ExpenseDraft getDraft() {
    return _localDatasource.getExpenseDraft();
  }

  List<String> getCategories() {
    return _localDatasource.getCategories();
  }
}
