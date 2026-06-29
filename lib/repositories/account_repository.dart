import 'package:financas/data/datasources/local_datasource.dart';
import 'package:financas/models/account.dart';

class AccountRepository {
  const AccountRepository(this._localDatasource);

  final LocalDatasource _localDatasource;

  List<Account> listAccounts() {
    return _localDatasource.getAccounts();
  }
}
