import 'package:drift/native.dart';
import 'package:fluxa/data/datasources/drift_local_datasource.dart';
import 'package:fluxa/data/local/app_database.dart';
import 'package:fluxa/models/account.dart';
import 'package:fluxa/models/user_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('persistencia local Drift salva preferencias e contas', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final datasource = DriftLocalDatasource(database);

    await datasource.initialize();
    await datasource.savePreferences(
      const UserPreferences(
        displayName: 'Ana',
        appearance: AppAppearance.dark,
      ),
      completedWelcome: true,
    );
    await datasource.saveAccount(
      const Account(
        id: 'account-new',
        name: 'Carteira',
        type: 'dinheiro',
        balance: 120.5,
      ),
    );

    expect(datasource.getHasCompletedWelcome(), isTrue);
    expect(datasource.getPreferences().displayName, 'Ana');
    expect(
      datasource.getAccounts().any((account) => account.id == 'account-new'),
      isTrue,
    );

    await database.close();
  });

  test('mutacao local entra na sync queue', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final datasource = DriftLocalDatasource(database);

    await datasource.initialize();
    await datasource.saveAccount(
      const Account(
        id: 'account-sync',
        name: 'Conta sync',
        type: 'corrente',
        balance: 50,
      ),
    );

    final queueItems = await database.getSyncQueueItems();
    expect(queueItems.any((item) => item.localEntityId == 'account-sync'), isTrue);

    await database.close();
  });
}
