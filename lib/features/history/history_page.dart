import 'package:financas/core/extensions/date_extension.dart';
import 'package:financas/core/theme/spacing.dart';
import 'package:financas/models/transaction.dart';
import 'package:financas/shared/widgets/app_bottom_sheet.dart';
import 'package:financas/shared/widgets/app_button.dart';
import 'package:financas/shared/widgets/app_card.dart';
import 'package:financas/shared/widgets/app_input.dart';
import 'package:financas/shared/widgets/empty_state.dart';
import 'package:financas/shared/widgets/section_heading.dart';
import 'package:financas/shared/widgets/transaction_row.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
    required this.transactions,
    required this.onSaveTransaction,
    required this.onDeleteTransaction,
  });

  final List<TransactionModel> transactions;
  final Future<void> Function(TransactionModel transaction) onSaveTransaction;
  final Future<void> Function(String transactionId) onDeleteTransaction;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final TextEditingController _searchController;

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
        return true;
      }

      return item.title.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.sourceLabel.toLowerCase().contains(query);
    }).toList();

    if (widget.transactions.isEmpty) {
      return const EmptyState(
        title: 'Nenhuma movimentação ainda',
        message: 'Quando você registrar receitas ou gastos, o histórico aparece aqui.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
      children: [
        const SectionHeading(
          eyebrow: 'Histórico',
          title: 'Para onde seu dinheiro foi',
          description:
              'Busca, filtros rápidos e leitura direta da movimentação sem ruído visual.',
        ),
        const SizedBox(height: AppSpacing.xl),
        AppInput(
          controller: _searchController,
          hint: 'Buscar mercado, uber, salário...',
          prefixIcon: const Icon(Icons.search_rounded),
        ),
        const SizedBox(height: AppSpacing.lg - 2),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            Chip(label: Text('Mês atual')),
            Chip(label: Text('Cartões')),
            Chip(label: Text('Mercado')),
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
              child: TransactionRow(
                title: item.title,
                subtitle:
                    '${item.occuredAt.toShortPtBr()} • ${item.category} • ${item.sourceLabel}',
                amount: item.amount,
                trailing: PopupMenuButton<_TransactionAction>(
                  icon: const Icon(Icons.more_horiz_rounded),
                  onSelected: (action) async {
                    if (action == _TransactionAction.edit) {
                      final updated = await _TransactionFormSheet.show(
                        context,
                        initialTransaction: item,
                      );
                      if (updated == null) {
                        return;
                      }
                      await widget.onSaveTransaction(updated);
                      return;
                    }

                    final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Excluir movimentação'),
                            content: Text(
                              'Remover "${item.title}" do histórico e recalcular saldos locais?',
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

                    await widget.onDeleteTransaction(item.id);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: _TransactionAction.edit,
                      child: Text('Editar'),
                    ),
                    PopupMenuItem(
                      value: _TransactionAction.delete,
                      child: Text('Excluir'),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  void _refresh() {
    setState(() {});
  }
}

enum _TransactionAction { edit, delete }

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
