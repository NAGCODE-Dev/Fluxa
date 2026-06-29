import 'package:fluxa/core/theme/spacing.dart';
import 'package:fluxa/models/expense_draft.dart';
import 'package:fluxa/shared/widgets/app_bottom_sheet.dart';
import 'package:fluxa/shared/widgets/app_button.dart';
import 'package:fluxa/shared/widgets/app_card.dart';
import 'package:fluxa/shared/widgets/app_input.dart';
import 'package:flutter/material.dart';

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({
    super.key,
    required this.draft,
    required this.categories,
    required this.sources,
  });

  final ExpenseDraft draft;
  final List<String> categories;
  final List<String> sources;

  static Future<ExpenseDraft?> show(
    BuildContext context, {
    required ExpenseDraft draft,
    required List<String> categories,
    required List<String> sources,
  }) {
    return AppBottomSheet.show<ExpenseDraft>(
      context: context,
      child: AddExpenseSheet(
        draft: draft,
        categories: categories,
        sources: sources,
      ),
    );
  }

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late String _selectedCategory;
  late String _selectedSource;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.draft.amount > 0 ? widget.draft.amount.toStringAsFixed(2) : '',
    );
    _descriptionController = TextEditingController(text: widget.draft.description);
    _selectedCategory = widget.categories.contains(widget.draft.category)
        ? widget.draft.category
        : widget.categories.first;
    _selectedSource = widget.sources.contains(widget.draft.source)
        ? widget.draft.source
        : widget.sources.first;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: SingleChildScrollView(
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
                hint: '0,00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Categoria',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.categories
                    .map(
                      (category) => ChoiceChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.sm + 2),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Ou escolha na lista',
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
              DropdownButtonFormField<String>(
                initialValue: _selectedSource,
                decoration: const InputDecoration(
                  labelText: 'Origem do gasto',
                ),
                items: widget.sources
                    .map(
                      (source) => DropdownMenuItem(
                        value: source,
                        child: Text(
                          source,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    _selectedSource = value;
                  });
                },
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
                  label: 'Salvar gasto',
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
    Navigator.of(context).pop(
      ExpenseDraft(
        amount: parsedAmount,
        category: _selectedCategory,
        source: _selectedSource,
        description: _descriptionController.text.trim(),
      ),
    );
  }
}
