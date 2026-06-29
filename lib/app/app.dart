import 'package:financas/data/datasources/local_datasource.dart';
import 'package:financas/core/sync/sync_service.dart';
import 'package:financas/core/theme/app_theme.dart';
import 'package:financas/features/root/root_shell.dart';
import 'package:flutter/material.dart';

class FinancasApp extends StatelessWidget {
  const FinancasApp({
    super.key,
    required this.datasource,
    this.syncService,
  });

  final LocalDatasource datasource;
  final SyncService? syncService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finanças',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: RootShell(
        datasource: datasource,
        syncService: syncService ?? NoopSyncService(),
      ),
    );
  }
}
