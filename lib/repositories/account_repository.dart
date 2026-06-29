import 'package:fluxa/data/datasources/local_datasource.dart';
import 'package:fluxa/models/account.dart';

class AccountRepository {
  const AccountRepository(this._localDatasource);

  final LocalDatasource _localDatasource;

  List<Account> listAccounts() {
    return _localDatasource.getAccounts();
  }

  Future<void> saveAccount(Account account) {
    return _localDatasource.saveAccount(account);
  }

  Future<void> deleteAccount(String accountId) {
    return _localDatasource.deleteAccount(accountId);
  }
}
