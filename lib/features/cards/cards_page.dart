import 'package:fluxa/core/theme/radius.dart';
import 'package:fluxa/core/extensions/date_extension.dart';
import 'package:fluxa/core/extensions/money_extension.dart';
import 'package:fluxa/core/theme/spacing.dart';
import 'package:fluxa/models/account.dart';
import 'package:fluxa/models/budget.dart';
import 'package:fluxa/models/calendar_event.dart';
import 'package:fluxa/models/card.dart';
import 'package:fluxa/models/goal.dart';
import 'package:fluxa/models/subscription.dart';
import 'package:fluxa/shared/widgets/app_bottom_sheet.dart';
import 'package:fluxa/shared/widgets/app_button.dart';
import 'package:fluxa/shared/widgets/app_card.dart';
import 'package:fluxa/shared/widgets/app_input.dart';
import 'package:fluxa/shared/widgets/bank_card_widget.dart';
import 'package:fluxa/shared/widgets/empty_state.dart';
import 'package:fluxa/shared/widgets/section_heading.dart';
import 'package:flutter/material.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({
    super.key,
    required this.accounts,
    required this.cards,
    required this.goals,
    required this.budgets,
    required this.subscriptions,
    required this.calendarEvents,
    required this.onSaveAccount,
    required this.onDeleteAccount,
    required this.onSaveCard,
    required this.onDeleteCard,
    required this.onSaveGoal,
    required this.onDeleteGoal,
    required this.onSaveBudget,
    required this.onDeleteBudget,
    required this.onSaveSubscription,
    required this.onDeleteSubscription,
    required this.onSaveCalendarEvent,
    required this.onDeleteCalendarEvent,
    this.headerAction,
  });

  final List<Account> accounts;
  final List<PaymentCard> cards;
  final List<Goal> goals;
  final List<Budget> budgets;
  final List<SubscriptionModel> subscriptions;
  final List<CalendarEventModel> calendarEvents;
  final Future<void> Function(Account account) onSaveAccount;
  final Future<void> Function(String accountId) onDeleteAccount;
  final Future<void> Function(PaymentCard card) onSaveCard;
  final Future<void> Function(String cardId) onDeleteCard;
  final Future<void> Function(Goal goal) onSaveGoal;
  final Future<void> Function(String goalId) onDeleteGoal;
  final Future<void> Function(Budget budget) onSaveBudget;
  final Future<void> Function(String budgetId) onDeleteBudget;
  final Future<void> Function(SubscriptionModel subscription) onSaveSubscription;
  final Future<void> Function(String subscriptionId) onDeleteSubscription;
  final Future<void> Function(CalendarEventModel event) onSaveCalendarEvent;
  final Future<void> Function(String eventId) onDeleteCalendarEvent;
  final Widget? headerAction;

  @override
  State<CardsPage> createState() => _CardsPageState();
}

enum _PlanningSection {
  structure('Cartões', Icons.credit_card_rounded),
  budgets('Orçamento', Icons.pie_chart_outline_rounded),
  subscriptions('Assinaturas', Icons.repeat_rounded),
  calendar('Calendário', Icons.event_note_rounded),
  goals('Metas', Icons.flag_outlined);

  const _PlanningSection(this.label, this.icon);

  final String label;
  final IconData icon;
}

String _normalizeEventType(String rawType) {
  return switch (rawType) {
    'subscription_charge' || 'card_due' || 'due' || 'vencimento' => 'vencimento',
    'reminder' || 'lembrete' => 'lembrete',
    _ => 'evento',
  };
}

({int backgroundColor, int accentColor}) _resolveBankPalette(String bankName) {
  final normalized = bankName.trim().toLowerCase();

  if (normalized.contains('nubank') || normalized.contains('nu ')) {
    return (backgroundColor: 0xFF7C3AED, accentColor: 0xFFC4B5FD);
  }
  if (normalized.contains('santander')) {
    return (backgroundColor: 0xFFDC2626, accentColor: 0xFFFDA4AF);
  }
  if (normalized.contains('ita') || normalized.contains('itau')) {
    return (backgroundColor: 0xFFF97316, accentColor: 0xFF60A5FA);
  }
  if (normalized.contains('inter')) {
    return (backgroundColor: 0xFFF97316, accentColor: 0xFFFED7AA);
  }
  if (normalized.contains('c6')) {
    return (backgroundColor: 0xFF0F172A, accentColor: 0xFF94A3B8);
  }
  if (normalized.contains('bradesco')) {
    return (backgroundColor: 0xFFBE123C, accentColor: 0xFFF9A8D4);
  }

  return (backgroundColor: 0xFF111827, accentColor: 0xFF94A3B8);
}

class _CardsPageState extends State<CardsPage> {
  _PlanningSection _section = _PlanningSection.structure;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
      children: [
        SectionHeading(
          eyebrow: 'Planejamento',
          title: 'Planejamento',
          trailing: widget.headerAction,
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 46,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final section in _PlanningSection.values)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    avatar: Icon(section.icon, size: 18),
                    label: Text(section.label),
                    showCheckmark: false,
                    selected: _section == section,
                    onSelected: (_) {
                      setState(() {
                        _section = section;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildActiveSection(context),
      ],
    );
  }

  Widget _buildPlanningHighlights(BuildContext context) {
    return SizedBox(
      height: 146,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _PlanningPill(
            label: 'Contas',
            value: widget.accounts.length.toString(),
            caption: widget.accounts.isEmpty ? 'Cadastrar' : 'ativas',
          ),
          _PlanningPill(
            label: 'Cartões',
            value: widget.cards.length.toString(),
            caption: widget.cards.isEmpty ? 'Cadastrar' : 'salvos',
          ),
          _PlanningPill(
            label: 'Orçamentos',
            value: widget.budgets.length.toString(),
            caption: widget.budgets.isEmpty ? 'Criar' : 'ativos',
          ),
          _PlanningPill(
            label: 'Recorrências',
            value: widget.subscriptions.length.toString(),
            caption: widget.subscriptions.isEmpty ? 'Criar' : 'ativas',
          ),
        ],
      ),
    );
  }

  String _billingCycleLabel(String billingCycle) {
    return switch (billingCycle) {
      'yearly' => 'Anual',
      _ => 'Mensal',
    };
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
    );
  }

  Future<void> _openBudgetForm(BuildContext context, {Budget? initialBudget}) async {
    final budget = await _BudgetFormSheet.show(
      context,
      initialBudget: initialBudget,
    );
    if (budget == null) {
      return;
    }
    await widget.onSaveBudget(budget);
  }

  Future<void> _openGoalForm(BuildContext context, {Goal? initialGoal}) async {
    final goal = await _GoalFormSheet.show(
      context,
      initialGoal: initialGoal,
    );
    if (goal == null) {
      return;
    }
    await widget.onSaveGoal(goal);
  }

  Future<void> _openCalendarEventForm(
    BuildContext context, {
    CalendarEventModel? initialEvent,
  }) async {
    final event = await _CalendarEventFormSheet.show(
      context,
      initialEvent: initialEvent,
    );
    if (event == null) {
      return;
    }
    await widget.onSaveCalendarEvent(event);
  }

  Future<void> _openSubscriptionForm(
    BuildContext context, {
    SubscriptionModel? initialSubscription,
  }) async {
    final subscription = await _SubscriptionFormSheet.show(
      context,
      initialSubscription: initialSubscription,
    );
    if (subscription == null) {
      return;
    }
    await widget.onSaveSubscription(subscription);
  }

  Future<void> _openAccountForm(BuildContext context, {Account? initialAccount}) async {
    final account = await _AccountFormSheet.show(
      context,
      initialAccount: initialAccount,
    );
    if (account == null) {
      return;
    }
    await widget.onSaveAccount(account);
  }

  Future<void> _openCardForm(BuildContext context, {PaymentCard? initialCard}) async {
    final card = await _CardFormSheet.show(
      context,
      initialCard: initialCard,
    );
    if (card == null) {
      return;
    }
    await widget.onSaveCard(card);
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
    bool secondary = false,
  }) {
    return Expanded(
      child: AppButton(
        label: label,
        variant: secondary ? AppButtonVariant.secondary : AppButtonVariant.primary,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildBudgetsSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildSectionTitle(context, 'Orçamento mensal')),
              TextButton(
                onPressed: () => _openBudgetForm(context),
                child: const Text('Novo'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (widget.budgets.isEmpty)
            const EmptyState(
              title: 'Nenhum orçamento criado ainda',
              message: 'Defina um limite por categoria para acompanhar o mês.',
            )
          else
            ...widget.budgets.map(
              (budget) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ManageRow(
                  title:
                      '${budget.category} • ${budget.usedAmount.toMoney()} / ${budget.limitAmount.toMoney()}',
                  subtitle:
                      'Restante ${budget.remainingAmount.toMoney()} • alerta ${(budget.alertThresholdPercent).toStringAsFixed(0)}%',
                  onEdit: () => _openBudgetForm(context, initialBudget: budget),
                  onDelete: () => widget.onDeleteBudget(budget.id),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActiveSection(BuildContext context) {
    return switch (_section) {
      _PlanningSection.budgets => _buildBudgetsSection(context),
      _PlanningSection.goals => _buildGoalsSection(context),
      _PlanningSection.calendar => _buildCalendarSection(context),
      _PlanningSection.subscriptions => _buildSubscriptionsSection(context),
      _PlanningSection.structure => _buildStructureSection(context),
    };
  }

  Widget _buildGoalsSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildSectionTitle(context, 'Metas')),
              TextButton(
                onPressed: () => _openGoalForm(context),
                child: const Text('Nova'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (widget.goals.isEmpty)
            const EmptyState(
              title: 'Nenhuma meta salva ainda',
              message: 'Crie metas para acompanhar reserva, viagem ou compra grande.',
            )
          else
            ...widget.goals.map(
              (goal) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ManageRow(
                  title:
                      '${goal.name} • ${goal.currentAmount.toMoney()} / ${goal.targetAmount.toMoney()}',
                  subtitle:
                      'Progresso ${(goal.progress * 100).toStringAsFixed(0)}% • prazo ${goal.estimatedLabel}',
                  onEdit: () => _openGoalForm(context, initialGoal: goal),
                  onDelete: () => widget.onDeleteGoal(goal.id),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildSectionTitle(context, 'Calendário financeiro')),
              TextButton(
                onPressed: () => _openCalendarEventForm(context),
                child: const Text('Novo'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (widget.calendarEvents.isEmpty)
            const EmptyState(
              title: 'Nenhum evento futuro salvo',
              message: 'Registre vencimentos e cobranças para visualizar o mês.',
            )
          else
            ...widget.calendarEvents.map(
              (event) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ManageRow(
                  title: '${event.title} • ${event.eventDate.toShortPtBr()}',
                  subtitle: event.amount == null
                      ? event.description
                      : '${event.description} • ${event.amount!.toMoney()}',
                  onEdit: () => _openCalendarEventForm(context, initialEvent: event),
                  onDelete: () => widget.onDeleteCalendarEvent(event.id),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionsSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildSectionTitle(context, 'Assinaturas')),
              TextButton(
                onPressed: () => _openSubscriptionForm(context),
                child: const Text('Nova'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (widget.subscriptions.isEmpty)
            const EmptyState(
              title: 'Nenhuma assinatura registrada',
              message: 'Cadastre recorrências para ver a próxima cobrança.',
            )
          else
            ...widget.subscriptions.map(
              (subscription) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ManageRow(
                  title: '${subscription.name} • ${subscription.amount.toMoney()}',
                  subtitle:
                      '${_billingCycleLabel(subscription.billingCycle)} • próxima cobrança ${subscription.nextChargeDate.toShortPtBr()}',
                  onEdit: () => _openSubscriptionForm(context, initialSubscription: subscription),
                  onDelete: () => widget.onDeleteSubscription(subscription.id),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStructureSection(BuildContext context) {
    final primaryCard = widget.cards.isEmpty ? null : widget.cards.first;
    final secondaryCards = widget.cards.skip(1).toList();

    return Column(
      children: [
        _buildPlanningHighlights(context),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            _buildActionButton(
              context,
              label: 'Nova conta',
              onPressed: () => _openAccountForm(context),
            ),
            const SizedBox(width: AppSpacing.md),
            _buildActionButton(
              context,
              label: 'Novo cartão',
              secondary: true,
              onPressed: () => _openCardForm(context),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        if (primaryCard != null) ...[
          BankCardWidget(card: primaryCard),
          const SizedBox(height: AppSpacing.lg - 2),
          if (secondaryCards.isNotEmpty)
            Row(
              children: [
                for (final card in secondaryCards)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: card == secondaryCards.first ? 8 : 0,
                        left: card == secondaryCards.last ? 8 : 0,
                      ),
                      child: BankCardWidget(card: card, compact: true),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: AppSpacing.lg - 2),
        ],
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Cartões'),
              const SizedBox(height: 12),
              if (widget.cards.isEmpty)
                const EmptyState(
                  title: 'Nenhum cartão salvo ainda',
                  message: 'Adicione um cartão para acompanhar limite e fatura.',
                )
              else
                ...widget.cards.map(
                  (card) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ManageRow(
                      title: '${card.bankName} • ${card.maskedNumber}',
                      subtitle:
                          'Disponível ${card.availableAmount.toMoney()} • Fatura ${card.currentInvoice.toMoney()}',
                      onEdit: () => _openCardForm(context, initialCard: card),
                      onDelete: () => widget.onDeleteCard(card.id),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg - 2),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Contas'),
              const SizedBox(height: 12),
              if (widget.accounts.isEmpty)
                const EmptyState(
                  title: 'Nenhuma conta salva ainda',
                  message: 'Cadastre uma conta para refletir saldo e origem dos gastos.',
                )
              else
                ...widget.accounts.map(
                  (account) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ManageRow(
                      title: '${account.name} • ${account.type}',
                      subtitle: 'Saldo ${account.balance.toMoney()}',
                      onEdit: () => _openAccountForm(context, initialAccount: account),
                      onDelete: () => widget.onDeleteAccount(account.id),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

}

class _PlanningPill extends StatelessWidget {
  const _PlanningPill({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 152,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 10),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(caption, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ManageRow extends StatelessWidget {
  const _ManageRow({
    required this.title,
    required this.subtitle,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final String subtitle;
  final Future<void> Function() onEdit;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final buttonColor = Theme.of(context).colorScheme.primary.withValues(alpha: 0.12);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.edit_outlined),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetScaffold extends StatelessWidget {
  const _SheetScaffold({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(12, 12, 12, bottom + 12),
        child: AppCard(child: child),
      ),
    );
  }
}

Future<DateTime?> _pickDate(
  BuildContext context, {
  DateTime? initialDate,
}) {
  final now = DateTime.now();
  return showDatePicker(
    context: context,
    initialDate: initialDate ?? now,
    firstDate: DateTime(now.year - 3),
    lastDate: DateTime(now.year + 10),
  );
}

String _formatDateLabel(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month';
}

DateTime _parseDateLabel(String rawValue) {
  final now = DateTime.now();
  final parts = rawValue.trim().split('/');
  if (parts.length != 2) {
    return now;
  }

  return DateTime(
    now.year,
    int.tryParse(parts[1]) ?? now.month,
    int.tryParse(parts[0]) ?? now.day,
  );
}

class _AccountFormSheet extends StatefulWidget {
  const _AccountFormSheet({
    this.initialAccount,
  });

  final Account? initialAccount;

  static Future<Account?> show(
    BuildContext context, {
    Account? initialAccount,
  }) {
    return AppBottomSheet.show<Account>(
      context: context,
      child: _AccountFormSheet(initialAccount: initialAccount),
    );
  }

  @override
  State<_AccountFormSheet> createState() => _AccountFormSheetState();
}

class _AccountFormSheetState extends State<_AccountFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late String _type;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialAccount?.name ?? '');
    _balanceController = TextEditingController(
      text: widget.initialAccount?.balance.toStringAsFixed(2) ?? '0.00',
    );
    _type = widget.initialAccount?.type ?? 'corrente';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialAccount == null ? 'Nova conta' : 'Editar conta',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInput(
              controller: _nameController,
              label: 'Nome',
              hint: 'Conta principal',
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Tipo'),
              items: const [
                DropdownMenuItem(value: 'corrente', child: Text('Corrente')),
                DropdownMenuItem(value: 'poupança', child: Text('Poupança')),
                DropdownMenuItem(value: 'dinheiro', child: Text('Dinheiro')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _type = value);
                }
              },
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _balanceController,
              label: 'Saldo inicial',
              hint: '0.00',
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Salvar conta',
                onPressed: _submit,
              ),
            ),
          ],
        ),
    );
  }

  void _submit() {
    final balance = double.tryParse(_balanceController.text.replaceAll(',', '.'));
    if (_nameController.text.trim().isEmpty || balance == null) {
      return;
    }

    Navigator.of(context).pop(
      Account(
        id: widget.initialAccount?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        type: _type,
        balance: balance,
      ),
    );
  }
}

class _CardFormSheet extends StatefulWidget {
  const _CardFormSheet({
    this.initialCard,
  });

  final PaymentCard? initialCard;

  static Future<PaymentCard?> show(
    BuildContext context, {
    PaymentCard? initialCard,
  }) {
    return AppBottomSheet.show<PaymentCard>(
      context: context,
      child: _CardFormSheet(initialCard: initialCard),
    );
  }

  @override
  State<_CardFormSheet> createState() => _CardFormSheetState();
}

class _CardFormSheetState extends State<_CardFormSheet> {
  late final TextEditingController _bankController;
  late final TextEditingController _nameController;
  late final TextEditingController _limitController;
  late final TextEditingController _invoiceController;
  late final TextEditingController _availableController;
  late final TextEditingController _closingController;
  late final TextEditingController _dueController;
  late String _cardKind;

  void _refreshPreview() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    final card = widget.initialCard;
    _bankController = TextEditingController(text: card?.bankName ?? '');
    _nameController = TextEditingController(text: card?.name ?? '');
    _limitController = TextEditingController(text: card?.limitAmount.toStringAsFixed(2) ?? '0.00');
    _invoiceController = TextEditingController(text: card?.currentInvoice.toStringAsFixed(2) ?? '0.00');
    _availableController = TextEditingController(text: card?.availableAmount.toStringAsFixed(2) ?? '0.00');
    _closingController = TextEditingController(text: card?.closingLabel ?? '10/07');
    _dueController = TextEditingController(text: card?.dueLabel ?? '20/07');
    _cardKind = _resolveCardKind(card?.name);
    _bankController.addListener(_refreshPreview);
    _nameController.addListener(_refreshPreview);
    _limitController.addListener(_refreshPreview);
    _invoiceController.addListener(_refreshPreview);
    _availableController.addListener(_refreshPreview);
    _closingController.addListener(_refreshPreview);
    _dueController.addListener(_refreshPreview);
  }

  @override
  void dispose() {
    _bankController.removeListener(_refreshPreview);
    _nameController.removeListener(_refreshPreview);
    _limitController.removeListener(_refreshPreview);
    _invoiceController.removeListener(_refreshPreview);
    _availableController.removeListener(_refreshPreview);
    _closingController.removeListener(_refreshPreview);
    _dueController.removeListener(_refreshPreview);
    _bankController.dispose();
    _nameController.dispose();
    _limitController.dispose();
    _invoiceController.dispose();
    _availableController.dispose();
    _closingController.dispose();
    _dueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previewPalette = _resolveBankPalette(_bankController.text);
    final previewCard = PaymentCard(
      id: widget.initialCard?.id ?? 'preview',
      bankName: _bankController.text.trim().isEmpty ? 'Banco' : _bankController.text.trim(),
      name: _resolvedCardName(),
      maskedNumber: widget.initialCard?.maskedNumber ?? '•••• 0000',
      limitAmount:
          double.tryParse(_limitController.text.replaceAll(',', '.')) ?? 0,
      availableAmount:
          double.tryParse(_availableController.text.replaceAll(',', '.')) ?? 0,
      currentInvoice:
          double.tryParse(_invoiceController.text.replaceAll(',', '.')) ?? 0,
      closingLabel: _closingController.text.trim(),
      dueLabel: _dueController.text.trim(),
      backgroundColor: previewPalette.backgroundColor,
      accentColor: previewPalette.accentColor,
    );

    return _SheetScaffold(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialCard == null ? 'Novo cartão' : 'Editar cartão',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            BankCardWidget(card: previewCard, compact: true),
            const SizedBox(height: AppSpacing.lg),
            AppInput(
              controller: _bankController,
              label: 'Banco',
              hint: 'Nubank',
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            DropdownButtonFormField<String>(
              key: ValueKey('card-kind-$_cardKind'),
              initialValue: _cardKind,
              decoration: const InputDecoration(labelText: 'Tipo do cartão'),
              items: const [
                DropdownMenuItem(value: 'credito', child: Text('Crédito')),
                DropdownMenuItem(value: 'debito', child: Text('Débito')),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _cardKind = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _nameController,
              label: 'Apelido do cartão',
              hint: 'Opcional, ex.: final 2211',
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _limitController, label: 'Limite total', hint: '4200.00'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _availableController, label: 'Disponível', hint: '1860.00'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _invoiceController, label: 'Fatura atual', hint: '2340.00'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _closingController,
              label: 'Fechamento',
              hint: '10/07',
              readOnly: true,
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
              onTap: () async {
                final selected = await _pickDate(
                  context,
                  initialDate: _parseDateLabel(_closingController.text),
                );
                if (!mounted || selected == null) {
                  return;
                }
                _closingController.text = _formatDateLabel(selected);
              },
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _dueController,
              label: 'Vencimento',
              hint: '20/07',
              readOnly: true,
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
              onTap: () async {
                final selected = await _pickDate(
                  context,
                  initialDate: _parseDateLabel(_dueController.text),
                );
                if (!mounted || selected == null) {
                  return;
                }
                _dueController.text = _formatDateLabel(selected);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Salvar cartão',
                onPressed: _submit,
              ),
            ),
          ],
        ),
    );
  }

  void _submit() {
    final limit = double.tryParse(_limitController.text.replaceAll(',', '.'));
    final available = double.tryParse(_availableController.text.replaceAll(',', '.'));
    final invoice = double.tryParse(_invoiceController.text.replaceAll(',', '.'));
    if (_bankController.text.trim().isEmpty ||
        limit == null ||
        available == null ||
        invoice == null) {
      return;
    }

    Navigator.of(context).pop(
      PaymentCard(
        id: widget.initialCard?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        bankName: _bankController.text.trim(),
        name: _resolvedCardName(),
        maskedNumber: widget.initialCard?.maskedNumber ?? '•••• ${(DateTime.now().millisecond % 9000 + 1000)}',
        limitAmount: limit,
        availableAmount: available,
        currentInvoice: invoice,
        closingLabel: _closingController.text.trim(),
        dueLabel: _dueController.text.trim(),
        backgroundColor: _resolveBankPalette(_bankController.text).backgroundColor,
        accentColor: _resolveBankPalette(_bankController.text).accentColor,
      ),
    );
  }

  String _resolveCardKind(String? cardName) {
    final normalized = (cardName ?? '').trim().toLowerCase();
    if (normalized == 'débito' || normalized == 'debito') {
      return 'debito';
    }
    return 'credito';
  }

  String _resolvedCardName() {
    final alias = _nameController.text.trim();
    final kindLabel = _cardKind == 'debito' ? 'Débito' : 'Crédito';
    return alias.isEmpty ? kindLabel : '$kindLabel • $alias';
  }
}

class _GoalFormSheet extends StatefulWidget {
  const _GoalFormSheet({
    this.initialGoal,
  });

  final Goal? initialGoal;

  static Future<Goal?> show(
    BuildContext context, {
    Goal? initialGoal,
  }) {
    return AppBottomSheet.show<Goal>(
      context: context,
      child: _GoalFormSheet(initialGoal: initialGoal),
    );
  }

  @override
  State<_GoalFormSheet> createState() => _GoalFormSheetState();
}

class _GoalFormSheetState extends State<_GoalFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _targetController;
  late final TextEditingController _currentController;
  late final TextEditingController _etaController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialGoal?.name ?? '');
    _targetController = TextEditingController(
      text: widget.initialGoal?.targetAmount.toStringAsFixed(2) ?? '0.00',
    );
    _currentController = TextEditingController(
      text: widget.initialGoal?.currentAmount.toStringAsFixed(2) ?? '0.00',
    );
    _etaController = TextEditingController(
      text: widget.initialGoal?.estimatedLabel ?? '6 meses',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _currentController.dispose();
    _etaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialGoal == null ? 'Nova meta' : 'Editar meta',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInput(
              controller: _nameController,
              label: 'Nome',
              hint: 'Notebook',
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _targetController,
              label: 'Valor alvo',
              hint: '4000.00',
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _currentController,
              label: 'Valor atual',
              hint: '1200.00',
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _etaController,
              label: 'Prazo estimado',
              hint: '7 meses',
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Salvar meta',
                onPressed: _submit,
              ),
            ),
          ],
        ),
    );
  }

  void _submit() {
    final target = double.tryParse(_targetController.text.replaceAll(',', '.'));
    final current = double.tryParse(_currentController.text.replaceAll(',', '.'));
    if (_nameController.text.trim().isEmpty || target == null || current == null) {
      return;
    }

    Navigator.of(context).pop(
      Goal(
        id: widget.initialGoal?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        targetAmount: target,
        currentAmount: current,
        estimatedLabel: _etaController.text.trim().isEmpty
            ? 'sem prazo'
            : _etaController.text.trim(),
      ),
    );
  }
}

class _BudgetFormSheet extends StatefulWidget {
  const _BudgetFormSheet({
    this.initialBudget,
  });

  final Budget? initialBudget;

  static Future<Budget?> show(
    BuildContext context, {
    Budget? initialBudget,
  }) {
    return AppBottomSheet.show<Budget>(
      context: context,
      child: _BudgetFormSheet(initialBudget: initialBudget),
    );
  }

  @override
  State<_BudgetFormSheet> createState() => _BudgetFormSheetState();
}

class _BudgetFormSheetState extends State<_BudgetFormSheet> {
  late final TextEditingController _categoryController;
  late final TextEditingController _limitController;
  late final TextEditingController _usedController;
  late final TextEditingController _alertController;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(
      text: widget.initialBudget?.category ?? '',
    );
    _limitController = TextEditingController(
      text: widget.initialBudget?.limitAmount.toStringAsFixed(2) ?? '0.00',
    );
    _usedController = TextEditingController(
      text: widget.initialBudget?.usedAmount.toStringAsFixed(2) ?? '0.00',
    );
    _alertController = TextEditingController(
      text: widget.initialBudget?.alertThresholdPercent.toStringAsFixed(0) ?? '80',
    );
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _limitController.dispose();
    _usedController.dispose();
    _alertController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialBudget == null ? 'Novo orçamento' : 'Editar orçamento',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInput(controller: _categoryController, label: 'Categoria', hint: 'Mercado'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _limitController, label: 'Limite do mês', hint: '800.00'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _usedController, label: 'Já utilizado', hint: '0.00'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _alertController, label: 'Alerta (%)', hint: '80'),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: AppButton(label: 'Salvar orçamento', onPressed: _submit),
            ),
          ],
        ),
    );
  }

  void _submit() {
    final limit = double.tryParse(_limitController.text.replaceAll(',', '.'));
    final used = double.tryParse(_usedController.text.replaceAll(',', '.'));
    final alert = double.tryParse(_alertController.text.replaceAll(',', '.'));
    if (_categoryController.text.trim().isEmpty ||
        limit == null ||
        used == null ||
        alert == null) {
      return;
    }

    Navigator.of(context).pop(
      Budget(
        id: widget.initialBudget?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        category: _categoryController.text.trim(),
        periodMonth: widget.initialBudget?.periodMonth ?? DateTime.now().month,
        periodYear: widget.initialBudget?.periodYear ?? DateTime.now().year,
        limitAmount: limit,
        usedAmount: used,
        alertThresholdPercent: alert,
      ),
    );
  }
}

class _SubscriptionFormSheet extends StatefulWidget {
  const _SubscriptionFormSheet({
    this.initialSubscription,
  });

  final SubscriptionModel? initialSubscription;

  static Future<SubscriptionModel?> show(
    BuildContext context, {
      SubscriptionModel? initialSubscription,
    }) {
    return AppBottomSheet.show<SubscriptionModel>(
      context: context,
      child: _SubscriptionFormSheet(initialSubscription: initialSubscription),
    );
  }

  @override
  State<_SubscriptionFormSheet> createState() => _SubscriptionFormSheetState();
}

class _SubscriptionFormSheetState extends State<_SubscriptionFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _nextChargeController;
  late String _billingCycle;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialSubscription?.name ?? '');
    _amountController = TextEditingController(
      text: widget.initialSubscription?.amount.toStringAsFixed(2) ?? '0.00',
    );
    _billingCycle = widget.initialSubscription?.billingCycle ?? 'monthly';
    _nextChargeController = TextEditingController(
      text: widget.initialSubscription == null
          ? '05/07'
          : widget.initialSubscription!.nextChargeDate.toShortPtBr(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _nextChargeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialSubscription == null
                  ? 'Nova assinatura'
                  : 'Editar assinatura',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInput(controller: _nameController, label: 'Nome', hint: 'Spotify'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _amountController, label: 'Valor', hint: '21.90'),
            const SizedBox(height: AppSpacing.lg - 2),
            DropdownButtonFormField<String>(
              initialValue: _billingCycle,
              decoration: const InputDecoration(labelText: 'Ciclo'),
              items: const [
                DropdownMenuItem(value: 'monthly', child: Text('Mensal')),
                DropdownMenuItem(value: 'yearly', child: Text('Anual')),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _billingCycle = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _nextChargeController,
              label: 'Próxima cobrança',
              hint: '05/07',
              readOnly: true,
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
              onTap: () async {
                final selected = await _pickDate(
                  context,
                  initialDate: _parseDateLabel(_nextChargeController.text),
                );
                if (!mounted || selected == null) {
                  return;
                }
                _nextChargeController.text = _formatDateLabel(selected);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: AppButton(label: 'Salvar assinatura', onPressed: _submit),
            ),
          ],
        ),
    );
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (_nameController.text.trim().isEmpty || amount == null) {
      return;
    }
    final nextCharge = _parseDateLabel(_nextChargeController.text);
    Navigator.of(context).pop(
      SubscriptionModel(
        id: widget.initialSubscription?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        amount: amount,
        billingCycle: _billingCycle,
        nextChargeDate: nextCharge,
        isActive: true,
        detectionSource: 'manual',
      ),
    );
  }
}

class _CalendarEventFormSheet extends StatefulWidget {
  const _CalendarEventFormSheet({
    this.initialEvent,
  });

  final CalendarEventModel? initialEvent;

  static Future<CalendarEventModel?> show(
    BuildContext context, {
    CalendarEventModel? initialEvent,
  }) {
    return AppBottomSheet.show<CalendarEventModel>(
      context: context,
      child: _CalendarEventFormSheet(initialEvent: initialEvent),
    );
  }

  @override
  State<_CalendarEventFormSheet> createState() => _CalendarEventFormSheetState();
}

class _CalendarEventFormSheetState extends State<_CalendarEventFormSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  late final TextEditingController _dateController;
  late String _eventType;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialEvent?.title ?? '');
    _eventType = _normalizeEventType(widget.initialEvent?.type ?? 'evento');
    _descriptionController = TextEditingController(
      text: widget.initialEvent?.description ?? '',
    );
    _amountController = TextEditingController(
      text: widget.initialEvent?.amount?.toStringAsFixed(2) ?? '0.00',
    );
    _dateController = TextEditingController(
      text: widget.initialEvent == null
          ? '10/07'
          : widget.initialEvent!.eventDate.toShortPtBr(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialEvent == null ? 'Novo evento' : 'Editar evento',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInput(controller: _titleController, label: 'Título', hint: 'Vencimento do cartão'),
            const SizedBox(height: AppSpacing.lg - 2),
            DropdownButtonFormField<String>(
              initialValue: _eventType,
              decoration: const InputDecoration(labelText: 'Tipo'),
              items: const [
                DropdownMenuItem(value: 'evento', child: Text('Evento')),
                DropdownMenuItem(value: 'vencimento', child: Text('Vencimento')),
                DropdownMenuItem(value: 'lembrete', child: Text('Lembrete')),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _eventType = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _descriptionController, label: 'Descrição', hint: 'Opcional'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _amountController, label: 'Valor', hint: '0.00'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _dateController,
              label: 'Data',
              hint: '10/07',
              readOnly: true,
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
              onTap: () async {
                final selected = await _pickDate(
                  context,
                  initialDate: _parseDateLabel(_dateController.text),
                );
                if (!mounted || selected == null) {
                  return;
                }
                _dateController.text = _formatDateLabel(selected);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: AppButton(label: 'Salvar evento', onPressed: _submit),
            ),
          ],
        ),
    );
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) {
      return;
    }
    final eventDate = _parseDateLabel(_dateController.text);
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    Navigator.of(context).pop(
      CalendarEventModel(
        id: widget.initialEvent?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        type: _eventType,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        eventDate: eventDate,
        amount: amount,
      ),
    );
  }
}
