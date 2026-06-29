import 'package:financas/core/theme/spacing.dart';
import 'package:flutter/material.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
