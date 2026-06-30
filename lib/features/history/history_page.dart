import 'package:fluxa/core/extensions/date_extension.dart';
import 'package:fluxa/core/extensions/money_extension.dart';
import 'package:fluxa/core/brands/expense_brand_signal.dart';
import 'package:fluxa/core/theme/spacing.dart';
import 'package:fluxa/models/subscription.dart';
import 'package:fluxa/models/transaction.dart';
import 'package:fluxa/shared/widgets/app_bottom_sheet.dart';
import 'package:fluxa/shared/widgets/app_button.dart';
import 'package:fluxa/shared/widgets/app_card.dart';
import 'package:fluxa/shared/widgets/app_input.dart';
import 'package:fluxa/shared/widgets/empty_state.dart';
import 'package:fluxa/shared/widgets/section_heading.dart';
import 'package:fluxa/shared/widgets/transaction_row.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
    required this.transactions,
    required this.subscriptions,
    required this.onSaveTransaction,
    required this.onDeleteTransaction,
    this.headerAction,
  });

  final List<TransactionModel> transactions;
  final List<SubscriptionModel> subscriptions;
  final Future<void> Function(TransactionModel transaction) onSaveTransaction;
  final Future<void> Function(String transactionId) onDeleteTransaction;
  final Widget? headerAction;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final TextEditingController _searchController;
  bool _filterCurrentMonth = false;
  bool _filterCards = false;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()..addListener(_refresh);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filteredTransactions = widget.transactions.where((item) {
      if (query.isEmpty) {
        return _matchesQuickFilters(item);
      }

      final matchesSearch = item.title.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.sourceLabel.toLowerCase().contains(query);
      return matchesSearch && _matchesQuickFilters(item);
    }).toList();
    final upcomingSubscriptions = [...widget.subscriptions]
      ..sort((left, right) => left.nextChargeDate.compareTo(right.nextChargeDate));
    final categories = widget.transactions
        .map((item) => item.category)
        .toSet()
        .toList()
      ..sort();

    if (widget.transactions.isEmpty) {
      return const EmptyState(
        title: 'Nenhuma movimentação ainda',
        message: 'Quando você registrar receitas ou gastos, o histórico aparece aqui.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
      children: [
        SectionHeading(
          eyebrow: 'Histórico',
          title: 'Movimentações',
          trailing: widget.headerAction,
        ),
        const SizedBox(height: AppSpacing.xl),
        if (upcomingSubscriptions.isNotEmpty) ...[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recorrências próximas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                ...upcomingSubscriptions.take(3).map(
                  (subscription) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${subscription.name} • ${subscription.amount.toMoney()}',
                          ),
                        ),
                        Text(
                          subscription.nextChargeDate.toShortPtBr(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg - 2),
        ],
        AppInput(
          controller: _searchController,
          hint: 'Buscar mercado, uber, salário...',
          prefixIcon: const Icon(Icons.search_rounded),
        ),
        const SizedBox(height: AppSpacing.lg - 2),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilterChip(
              label: const Text('Mês atual'),
              selected: _filterCurrentMonth,
              onSelected: (value) {
                setState(() {
                  _filterCurrentMonth = value;
                });
              },
            ),
            FilterChip(
              label: const Text('Cartões'),
              selected: _filterCards,
              onSelected: (value) {
                setState(() {
                  _filterCards = value;
                });
              },
            ),
            for (final category in categories.take(5))
              FilterChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (value) {
                  setState(() {
                    _selectedCategory = value ? category : null;
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 18),
        if (filteredTransactions.isEmpty)
          const EmptyState(
            title: 'Nenhum resultado',
            message: 'Ajuste a busca para encontrar a movimentação que você quer revisar.',
          )
        else
          ...filteredTransactions.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Builder(
                builder: (context) {
                  final brand = ExpenseBrandCatalog.resolve(
                    text:
                        '${item.title} ${item.description} ${item.category} ${item.sourceLabel}',
                    appName: item.sourceLabel,
                    packageName: '',
                  );
                  final hasBrand =
                      brand.key != ExpenseBrandCatalog.genericBank.key ||
                          item.sourceLabel.toLowerCase().contains('banco');

                  return TransactionRow(
                    title: item.title,
                    subtitle:
                        '${item.occuredAt.toShortPtBr()} • ${item.category} • ${item.sourceLabel}',
                    amount: item.amount,
                    accentColor: hasBrand ? brand.color : null,
                    accentIcon: hasBrand ? brand.icon : null,
                    accentLabel: hasBrand ? brand.label : null,
                    trailing: _TransactionActionsButton(
                      transaction: item,
                      onSaveTransaction: widget.onSaveTransaction,
                      onDeleteTransaction: widget.onDeleteTransaction,
                    ),
                  );
                },
              ),
            )),
      ],
    );
  }

  void _refresh() {
    setState(() {});
  }

  bool _matchesQuickFilters(TransactionModel item) {
    if (_filterCurrentMonth) {
      final now = DateTime.now();
      final sameMonth =
          item.occuredAt.month == now.month && item.occuredAt.year == now.year;
      if (!sameMonth) {
        return false;
      }
    }

    if (_filterCards) {
      final source = item.sourceLabel.toLowerCase();
      final isCard = source.contains('crédito') ||
          source.contains('credito') ||
          source.contains('cartão') ||
          source.contains('cartao');
      if (!isCard) {
        return false;
      }
    }

    if (_selectedCategory != null && item.category != _selectedCategory) {
      return false;
    }

    return true;
  }
}

enum _TransactionAction { edit, delete }

class _TransactionActionsButton extends StatelessWidget {
  const _TransactionActionsButton({
    required this.transaction,
    required this.onSaveTransaction,
    required this.onDeleteTransaction,
  });

  final TransactionModel transaction;
  final Future<void> Function(TransactionModel transaction) onSaveTransaction;
  final Future<void> Function(String transactionId) onDeleteTransaction;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _openActions(context),
      icon: const Icon(Icons.more_horiz_rounded),
    );
  }

  Future<void> _openActions(BuildContext context) async {
    final action = await AppBottomSheet.show<_TransactionAction>(
      context: context,
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionTile(
                action: _TransactionAction.edit,
                icon: Icons.edit_rounded,
                label: 'Editar movimentação',
              ),
              SizedBox(height: 10),
              _ActionTile(
                action: _TransactionAction.delete,
                icon: Icons.delete_outline_rounded,
                label: 'Excluir movimentação',
                destructive: true,
              ),
            ],
          ),
        ),
      ),
    );

    if (action == null || !context.mounted) {
      return;
    }

    if (action == _TransactionAction.edit) {
      final updated = await _TransactionFormSheet.show(
        context,
        initialTransaction: transaction,
      );
      if (updated == null) {
        return;
      }
      await onSaveTransaction(updated);
      return;
    }

    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Excluir movimentação'),
            content: Text(
              'Remover "${transaction.title}" do histórico e recalcular saldos locais?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Excluir'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) {
      return;
    }

    await onDeleteTransaction(transaction.id);
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.action,
    required this.icon,
    required this.label,
    this.destructive = false,
  });

  final _TransactionAction action;
  final IconData icon;
  final String label;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? Theme.of(context).colorScheme.error : null;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.of(context).pop(action),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: color,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionFormSheet extends StatefulWidget {
  const _TransactionFormSheet({
    required this.initialTransaction,
  });

  final TransactionModel initialTransaction;

  static Future<TransactionModel?> show(
    BuildContext context, {
    required TransactionModel initialTransaction,
  }) {
    return AppBottomSheet.show<TransactionModel>(
      context: context,
      child: _TransactionFormSheet(initialTransaction: initialTransaction),
    );
  }

  @override
  State<_TransactionFormSheet> createState() => _TransactionFormSheetState();
}

class _TransactionFormSheetState extends State<_TransactionFormSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _categoryController;
  late final TextEditingController _sourceController;
  late final TextEditingController _descriptionController;
  late TransactionType _type;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTransaction.title);
    _amountController = TextEditingController(
      text: widget.initialTransaction.amount.abs().toStringAsFixed(2),
    );
    _categoryController = TextEditingController(
      text: widget.initialTransaction.category,
    );
    _sourceController = TextEditingController(
      text: widget.initialTransaction.sourceLabel,
    );
    _descriptionController = TextEditingController(
      text: widget.initialTransaction.description,
    );
    _type = widget.initialTransaction.type;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
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
              'Editar movimentação',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInput(
              controller: _titleController,
              label: 'Título',
              hint: 'Salário, Mercado, Uber...',
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _amountController,
              label: 'Valor',
              hint: '120.00',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            DropdownButtonFormField<TransactionType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Tipo'),
              items: TransactionType.values
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(_labelForType(type)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _type = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _categoryController,
              label: 'Categoria',
              hint: 'Mercado',
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _sourceController,
              label: 'Origem',
              hint: 'Conta principal • Débito',
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _descriptionController,
              label: 'Descrição',
              hint: 'Opcional',
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.lg + 2),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: _submit,
                label: 'Salvar alteração',
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
    final title = _titleController.text.trim();
    final category = _categoryController.text.trim();
    final source = _sourceController.text.trim();
    final amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', '.'),
    );

    if (title.isEmpty || category.isEmpty || source.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha título, valor, categoria e origem.')),
      );
      return;
    }

    final signedAmount = switch (_type) {
      TransactionType.expense => -amount,
      TransactionType.income => amount,
      TransactionType.transfer => amount,
    };

    Navigator.of(context).pop(
      widget.initialTransaction.copyWith(
        title: title,
        category: category,
        sourceLabel: source,
        description: _descriptionController.text.trim(),
        amount: signedAmount,
        type: _type,
      ),
    );
  }

  static String _labelForType(TransactionType type) {
    return switch (type) {
      TransactionType.income => 'Receita',
      TransactionType.expense => 'Despesa',
      TransactionType.transfer => 'Transferência',
    };
  }
}
