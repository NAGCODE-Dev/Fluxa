import 'package:financas/data/datasources/local_datasource.dart';
import 'package:financas/models/budget.dart';

class BudgetRepository {
  const BudgetRepository(this._localDatasource);

  final LocalDatasource _localDatasource;

  List<Budget> listBudgets() {
    return _localDatasource.getBudgets();
  }

  Future<void> saveBudget(Budget budget) {
    return _localDatasource.saveBudget(budget);
  }

  Future<void> deleteBudget(String budgetId) {
    return _localDatasource.deleteBudget(budgetId);
  }
}
