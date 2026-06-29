import 'package:financas/data/datasources/local_datasource.dart';
import 'package:financas/models/user_preferences.dart';

class PreferencesRepository {
  const PreferencesRepository(this._localDatasource);

  final LocalDatasource _localDatasource;

  bool getHasCompletedWelcome() {
    return _localDatasource.getHasCompletedWelcome();
  }

  UserPreferences getPreferences() {
    return _localDatasource.getPreferences();
  }

  Future<void> savePreferences(
    UserPreferences preferences, {
    required bool completedWelcome,
  }) {
    return _localDatasource.savePreferences(
      preferences,
      completedWelcome: completedWelcome,
    );
  }
}
