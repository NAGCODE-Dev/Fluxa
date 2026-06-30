import 'package:fluxa/core/brands/expense_brand_signal.dart';
import 'package:fluxa/core/theme/colors.dart';
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
    required this.onCreateCategory,
    this.brandSignal,
    this.detectedTitle,
  });

  final ExpenseDraft draft;
  final List<String> categories;
  final List<String> sources;
  final Future<String?> Function() onCreateCategory;
  final ExpenseBrandSignal? brandSignal;
  final String? detectedTitle;

  static Future<ExpenseDraft?> show(
    BuildContext context, {
    required ExpenseDraft draft,
    required List<String> categories,
    required List<String> sources,
    required Future<String?> Function() onCreateCategory,
    ExpenseBrandSignal? brandSignal,
    String? detectedTitle,
  }) {
    return AppBottomSheet.show<ExpenseDraft>(
      context: context,
      child: AddExpenseSheet(
        draft: draft,
        categories: categories,
        sources: sources,
        onCreateCategory: onCreateCategory,
        brandSignal: brandSignal,
        detectedTitle: detectedTitle,
      ),
    );
  }

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  static const _newCategoryValue = '__new_category__';
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late List<String> _categories;
  late String _selectedCategory;
  late String _selectedSource;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.draft.amount > 0 ? widget.draft.amount.toStringAsFixed(2) : '',
    );
    _descriptionController = TextEditingController(text: widget.draft.description);
    _categories = List<String>.from(widget.categories);
    _selectedCategory = _categories.contains(widget.draft.category)
        ? widget.draft.category
        : _categories.first;
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
              if (widget.brandSignal != null) ...[
                const SizedBox(height: AppSpacing.md),
                _DetectedExpensePreview(
                  brand: widget.brandSignal!,
                  title: widget.detectedTitle ?? 'Compra detectada',
                  amount: widget.draft.amount,
                  source: widget.draft.source,
                ),
              ],
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
                children: _categories
                    .map(
                      (category) => ChoiceChip(
                        label: Text(category),
                        showCheckmark: false,
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
                key: ValueKey('category-$_selectedCategory-${_categories.length}'),
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Ou escolha na lista',
                ),
                items: [
                  ..._categories.map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  ),
                  const DropdownMenuItem(
                    value: _newCategoryValue,
                    child: Text('+ Adicionar nova categoria'),
                  ),
                ],
                onChanged: (value) async {
                  if (value == null) {
                    return;
                  }

                  if (value == _newCategoryValue) {
                    final createdCategory = await widget.onCreateCategory();
                    if (!mounted || createdCategory == null) {
                      return;
                    }

                    setState(() {
                      if (!_categories.contains(createdCategory)) {
                        _categories = [..._categories, createdCategory];
                      }
                      _selectedCategory = createdCategory;
                    });
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

class _DetectedExpensePreview extends StatelessWidget {
  const _DetectedExpensePreview({
    required this.brand,
    required this.title,
    required this.amount,
    required this.source,
  });

  final ExpenseBrandSignal brand;
  final String title;
  final double amount;
  final String source;

  @override
  Widget build(BuildContext context) {
    final amountLabel = amount.toStringAsFixed(2).replaceAll('.', ',');
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: brand.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: brand.color.withValues(alpha: 0.34)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: brand.color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: brand.color.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              brand.icon,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand.label,
                  style: textTheme.labelLarge?.copyWith(
                    color: brand.color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  '$source • R\$ $amountLabel',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
