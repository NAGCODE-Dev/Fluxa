import 'package:financas/core/theme/colors.dart';
import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.description,
  });

  final String eyebrow;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: textTheme.labelMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: textTheme.headlineSmall),
        if (description != null) ...[
          const SizedBox(height: 8),
          Text(description!, style: textTheme.bodyMedium),
        ],
      ],
    );
  }
}
