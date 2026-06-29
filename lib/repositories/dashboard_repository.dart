import 'package:fluxa/data/datasources/local_datasource.dart';
import 'package:fluxa/models/dashboard_summary.dart';

class DashboardRepository {
  const DashboardRepository(this._localDatasource);

  final LocalDatasource _localDatasource;

  DashboardSummary getSummary() {
    return _localDatasource.getDashboardSummary();
  }
}
