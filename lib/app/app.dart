import 'package:fluxa/data/datasources/local_datasource.dart';
import 'package:fluxa/core/theme/brand.dart';
import 'package:fluxa/core/sync/sync_service.dart';
import 'package:fluxa/core/theme/app_theme.dart';
import 'package:fluxa/features/root/root_shell.dart';
import 'package:flutter/material.dart';

class FluxaApp extends StatelessWidget {
  const FluxaApp({
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
      title: AppBrand.name,
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
