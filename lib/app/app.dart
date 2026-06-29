import 'package:financas/data/datasources/local_datasource.dart';
import 'package:financas/core/theme/app_theme.dart';
import 'package:financas/features/root/root_shell.dart';
import 'package:flutter/material.dart';

class FinancasApp extends StatelessWidget {
  const FinancasApp({
    super.key,
    required this.datasource,
  });

  final LocalDatasource datasource;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finanças',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: RootShell(datasource: datasource),
    );
  }
}
