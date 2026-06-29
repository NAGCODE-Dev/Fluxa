import 'package:financas/core/theme/spacing.dart';
import 'package:financas/models/expense_draft.dart';
import 'package:financas/shared/widgets/app_bottom_sheet.dart';
import 'package:financas/shared/widgets/app_button.dart';
import 'package:financas/shared/widgets/app_card.dart';
import 'package:financas/shared/widgets/app_input.dart';
import 'package:flutter/material.dart';

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({
    super.key,
    required this.draft,
    required this.categories,
  });

  final ExpenseDraft draft;
  final List<String> categories;

  static Future<ExpenseDraft?> show(
    BuildContext context, {
    required ExpenseDraft draft,
    required List<String> categories,
  }) {
    return AppBottomSheet.show<ExpenseDraft>(
      context: context,
      child: AddExpenseSheet(
        draft: draft,
        categories: categories,
      ),
    );
  }

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  late final TextEditingController _amountController;
  late final TextEditingController _sourceController;
  late final TextEditingController _descriptionController;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.draft.amount.toStringAsFixed(2),
    );
    _sourceController = TextEditingController(text: widget.draft.source);
    _descriptionController = TextEditingController(text: widget.draft.description);
    _selectedCategory = widget.categories.contains(widget.draft.category)
        ? widget.draft.category
        : widget.categories.first;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _sourceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, bottom + 12),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adicionar gasto',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg + 2),
            AppInput(
              controller: _amountController,
              label: 'Valor',
              hint: '120.00',
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Categoria',
              ),
              items: widget.categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _sourceController,
              label: 'Origem',
              hint: 'Cartão Santander • Crédito',
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _descriptionController,
              label: 'Descrição',
              hint: 'Opcional',
            ),
            const SizedBox(height: AppSpacing.lg + 2),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: _submit,
                label: 'Salvar em 1 toque',
              ),
            ),
            const SizedBox(height: AppSpacing.sm + 2),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () => Navigator.of(context).pop(),
                label: 'Cancelar',
                variant: AppButtonVariant.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final parsedAmount = double.tryParse(
      _amountController.text.trim().replaceAll(',', '.'),
    );

    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um valor válido.')),
      );
      return;
    }

    final source = _sourceController.text.trim();
    if (source.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe a origem da despesa.')),
      );
      return;
    }

    Navigator.of(context).pop(
      ExpenseDraft(
        amount: parsedAmount,
        category: _selectedCategory,
        source: source,
        description: _descriptionController.text.trim(),
      ),
    );
  }
}
