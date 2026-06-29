import 'package:financas/data/datasources/local_datasource.dart';
import 'package:financas/models/goal.dart';

class GoalRepository {
  const GoalRepository(this._localDatasource);

  final LocalDatasource _localDatasource;

  List<Goal> listGoals() {
    return _localDatasource.getGoals();
  }

  Future<void> saveGoal(Goal goal) {
    return _localDatasource.saveGoal(goal);
  }

  Future<void> deleteGoal(String goalId) {
    return _localDatasource.deleteGoal(goalId);
  }
}
