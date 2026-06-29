import 'package:financas/data/datasources/local_datasource.dart';

class DataBackupRepository {
  const DataBackupRepository(this._localDatasource);

  final LocalDatasource _localDatasource;

  Future<String> exportData() {
    return _localDatasource.exportData();
  }

  Future<void> importData(String rawData) {
    return _localDatasource.importData(rawData);
  }
}
