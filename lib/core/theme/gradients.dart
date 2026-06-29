import 'package:flutter/material.dart';

class AppGradients {
  static const brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3B82F6),
      Color(0xFF2563EB),
      Color(0xFF1D4ED8),
    ],
  );

  static const brandDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E40AF),
      Color(0xFF1D4ED8),
      Color(0xFF2563EB),
    ],
  );
}
