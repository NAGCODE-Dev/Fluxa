import 'package:financas/app/app.dart';
import 'package:financas/core/config/supabase_config.dart';
import 'package:financas/core/sync/sync_service.dart';
import 'package:financas/data/datasources/drift_local_datasource.dart';
import 'package:financas/data/local/app_database.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );
  final database = AppDatabase();
  final datasource = DriftLocalDatasource(database);
  await datasource.initialize();

  runApp(
    FinancasApp(
      datasource: datasource,
      syncService: SupabaseSyncService(
        database,
        datasource,
      ),
    ),
  );
}
