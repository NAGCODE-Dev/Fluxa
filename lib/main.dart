import 'package:financas/app/app.dart';
import 'package:financas/data/datasources/shared_preferences_local_datasource.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final datasource = SharedPreferencesLocalDatasource(preferences);

  runApp(FinancasApp(datasource: datasource));
}
