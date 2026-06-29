import 'package:fluxa/core/theme/radius.dart';
import 'package:fluxa/core/sync/sync_status.dart';
import 'package:fluxa/core/extensions/date_extension.dart';
import 'package:fluxa/core/extensions/money_extension.dart';
import 'package:fluxa/core/theme/spacing.dart';
import 'package:fluxa/features/auth/email_auth_sheet.dart';
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
import 'package:supabase_flutter/supabase_flutter.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({
    super.key,
    required this.accounts,
    required this.cards,
    required this.categories,
    required this.goals,
    required this.budgets,
    required this.subscriptions,
    required this.calendarEvents,
    required this.onSaveAccount,
    required this.onDeleteAccount,
    required this.onSaveCard,
    required this.onDeleteCard,
    required this.onSaveCategory,
    required this.onDeleteCategory,
    required this.onSaveGoal,
    required this.onDeleteGoal,
    required this.onSaveBudget,
    required this.onDeleteBudget,
    required this.onSaveSubscription,
    required this.onDeleteSubscription,
    required this.onSaveCalendarEvent,
    required this.onDeleteCalendarEvent,
    required this.onExportData,
    required this.onImportData,
    required this.currentSession,
    required this.onSignInWithGoogle,
    required this.onSignOut,
    required this.onEmailAuthRequested,
    required this.syncStatus,
    required this.onSyncNow,
  });

  final List<Account> accounts;
  final List<PaymentCard> cards;
  final List<String> categories;
  final List<Goal> goals;
  final List<Budget> budgets;
  final List<SubscriptionModel> subscriptions;
  final List<CalendarEventModel> calendarEvents;
  final Future<void> Function(Account account) onSaveAccount;
  final Future<void> Function(String accountId) onDeleteAccount;
  final Future<void> Function(PaymentCard card) onSaveCard;
  final Future<void> Function(String cardId) onDeleteCard;
  final Future<void> Function(String category) onSaveCategory;
  final Future<void> Function(String category) onDeleteCategory;
  final Future<void> Function(Goal goal) onSaveGoal;
  final Future<void> Function(String goalId) onDeleteGoal;
  final Future<void> Function(Budget budget) onSaveBudget;
  final Future<void> Function(String budgetId) onDeleteBudget;
  final Future<void> Function(SubscriptionModel subscription) onSaveSubscription;
  final Future<void> Function(String subscriptionId) onDeleteSubscription;
  final Future<void> Function(CalendarEventModel event) onSaveCalendarEvent;
  final Future<void> Function(String eventId) onDeleteCalendarEvent;
  final Future<String> Function() onExportData;
  final Future<void> Function(String rawData) onImportData;
  final Session? currentSession;
  final Future<void> Function() onSignInWithGoogle;
  final Future<void> Function() onSignOut;
  final Future<void> Function(EmailAuthResult result) onEmailAuthRequested;
  final SyncStatus syncStatus;
  final Future<void> Function() onSyncNow;

  @override
  State<CardsPage> createState() => _CardsPageState();
}

enum _PlanningSection {
  budgets('Orçamento', Icons.pie_chart_outline_rounded),
  goals('Metas', Icons.flag_outlined),
  calendar('Calendário', Icons.event_note_rounded),
  subscriptions('Assinaturas', Icons.repeat_rounded),
  structure('Cartões', Icons.credit_card_rounded);

  const _PlanningSection(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _CardsPageState extends State<CardsPage> {
  _PlanningSection _section = _PlanningSection.budgets;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
      children: [
        Row(
          children: [
            const Expanded(
              child: SectionHeading(
                eyebrow: 'Planejamento',
                title: 'Planejamento',
              ),
            ),
            if (widget.currentSession == null)
              IconButton(
                tooltip: 'Entrar',
                onPressed: _openAccountAccess,
                icon: const Icon(Icons.person_outline_rounded),
              )
            else
              PopupMenuButton<_AccountAction>(
                tooltip: 'Conta',
                onSelected: (action) async {
                  if (action == _AccountAction.refresh) {
                    await widget.onSyncNow();
                    return;
                  }
                  await widget.onSignOut();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _AccountAction.refresh,
                    child: Text('Atualizar dados'),
                  ),
                  PopupMenuItem(
                    value: _AccountAction.signOut,
                    child: Text('Sair da conta'),
                  ),
                ],
                icon: const Icon(Icons.person_rounded),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildAccountCard(context),
        const SizedBox(height: AppSpacing.lg - 2),
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

  Widget _buildAccountCard(BuildContext context) {
    if (widget.currentSession == null) {
      return AppCard(
        child: Row(
          children: [
            const Expanded(
              child: Text('Entre na sua conta para carregar seus dados em outros aparelhos.'),
            ),
            const SizedBox(width: AppSpacing.md),
            AppButton(
              label: 'Entrar',
              onPressed: _openAccountAccess,
            ),
          ],
        ),
      );
    }

    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.currentSession!.user.email ?? 'Conta conectada',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Seus dados ficam vinculados a esta conta.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: widget.onSignOut,
            child: const Text('Sair'),
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

  Widget _buildBudgetsSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Orçamento mensal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final budget = await _BudgetFormSheet.show(context);
                  if (budget == null) {
                    return;
                  }
                  await widget.onSaveBudget(budget);
                },
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
                  onEdit: () async {
                    final updated = await _BudgetFormSheet.show(
                      context,
                      initialBudget: budget,
                    );
                    if (updated == null) {
                      return;
                    }
                    await widget.onSaveBudget(updated);
                  },
                  onDelete: () => widget.onDeleteBudget(budget.id),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Metas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final goal = await _GoalFormSheet.show(context);
                  if (goal == null) {
                    return;
                  }
                  await widget.onSaveGoal(goal);
                },
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
                  onEdit: () async {
                    final updated = await _GoalFormSheet.show(
                      context,
                      initialGoal: goal,
                    );
                    if (updated == null) {
                      return;
                    }
                    await widget.onSaveGoal(updated);
                  },
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
              Expanded(
                child: Text(
                  'Calendário financeiro',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final event = await _CalendarEventFormSheet.show(context);
                  if (event == null) {
                    return;
                  }
                  await widget.onSaveCalendarEvent(event);
                },
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
                  onEdit: () async {
                    final updated = await _CalendarEventFormSheet.show(
                      context,
                      initialEvent: event,
                    );
                    if (updated == null) {
                      return;
                    }
                    await widget.onSaveCalendarEvent(updated);
                  },
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
              Expanded(
                child: Text(
                  'Assinaturas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final subscription = await _SubscriptionFormSheet.show(context);
                  if (subscription == null) {
                    return;
                  }
                  await widget.onSaveSubscription(subscription);
                },
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
                      'Ciclo ${subscription.billingCycle} • próxima cobrança ${subscription.nextChargeDate.toShortPtBr()}',
                  onEdit: () async {
                    final updated = await _SubscriptionFormSheet.show(
                      context,
                      initialSubscription: subscription,
                    );
                    if (updated == null) {
                      return;
                    }
                    await widget.onSaveSubscription(updated);
                  },
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
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Nova conta',
                onPressed: () async {
                  final account = await _AccountFormSheet.show(context);
                  if (account == null) {
                    return;
                  }
                  await widget.onSaveAccount(account);
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppButton(
                label: 'Novo cartão',
                variant: AppButtonVariant.secondary,
                onPressed: () async {
                  final card = await _CardFormSheet.show(context);
                  if (card == null) {
                    return;
                  }
                  await widget.onSaveCard(card);
                },
              ),
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
              Text(
                'Cartões',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
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
                      onEdit: () async {
                        final updated = await _CardFormSheet.show(
                          context,
                          initialCard: card,
                        );
                        if (updated == null) {
                          return;
                        }
                        await widget.onSaveCard(updated);
                      },
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
              Text(
                'Contas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
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
                      onEdit: () async {
                        final updated = await _AccountFormSheet.show(
                          context,
                          initialAccount: account,
                        );
                        if (updated == null) {
                          return;
                        }
                        await widget.onSaveAccount(updated);
                      },
                      onDelete: () => widget.onDeleteAccount(account.id),
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
              Row(
                children: [
                  const Expanded(
                    child: Text('Categorias'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final category = await _CategoryFormSheet.show(context);
                      if (category == null) {
                        return;
                      }
                      await widget.onSaveCategory(category);
                    },
                    child: const Text('Nova'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: widget.categories
                    .map(
                      (category) => InputChip(
                        label: Text(category),
                        onDeleted: () => widget.onDeleteCategory(category),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _openAccountAccess() async {
    final action = await showModalBottomSheet<_SignInAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(12),
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                title: const Text('Entrar com Google'),
                onTap: () => Navigator.of(context).pop(_SignInAction.google),
              ),
              ListTile(
                leading: const Icon(Icons.alternate_email_rounded),
                title: const Text('Entrar com e-mail'),
                onTap: () => Navigator.of(context).pop(_SignInAction.email),
              ),
            ],
          ),
        ),
      ),
    );

    if (action == null) {
      return;
    }
    if (!mounted) {
      return;
    }

    if (action == _SignInAction.google) {
      await widget.onSignInWithGoogle();
      return;
    }

    final result = await EmailAuthSheet.show(context);
    if (!mounted) {
      return;
    }
    if (result == null) {
      return;
    }
    await widget.onEmailAuthRequested(result);
  }
}

enum _AccountAction { refresh, signOut }
enum _SignInAction { google, email }

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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
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
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
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
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, bottom + 12),
      child: AppCard(
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

  @override
  void initState() {
    super.initState();
    final card = widget.initialCard;
    _bankController = TextEditingController(text: card?.bankName ?? '');
    _nameController = TextEditingController(text: card?.name ?? 'Crédito');
    _limitController = TextEditingController(text: card?.limitAmount.toStringAsFixed(2) ?? '0.00');
    _invoiceController = TextEditingController(text: card?.currentInvoice.toStringAsFixed(2) ?? '0.00');
    _availableController = TextEditingController(text: card?.availableAmount.toStringAsFixed(2) ?? '0.00');
    _closingController = TextEditingController(text: card?.closingLabel ?? '10 jul');
    _dueController = TextEditingController(text: card?.dueLabel ?? '20 jul');
  }

  @override
  void dispose() {
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
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, bottom + 12),
      child: AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialCard == null ? 'Novo cartão' : 'Editar cartão',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInput(controller: _bankController, label: 'Banco', hint: 'Nubank'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _nameController, label: 'Nome do cartão', hint: 'Crédito'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _limitController, label: 'Limite total', hint: '4200.00'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _availableController, label: 'Disponível', hint: '1860.00'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _invoiceController, label: 'Fatura atual', hint: '2340.00'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _closingController, label: 'Fechamento', hint: '10 jul'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _dueController, label: 'Vencimento', hint: '20 jul'),
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
        name: _nameController.text.trim().isEmpty
            ? 'Crédito'
            : _nameController.text.trim(),
        maskedNumber: widget.initialCard?.maskedNumber ?? '•••• ${(DateTime.now().millisecond % 9000 + 1000)}',
        limitAmount: limit,
        availableAmount: available,
        currentInvoice: invoice,
        closingLabel: _closingController.text.trim(),
        dueLabel: _dueController.text.trim(),
        backgroundColor: widget.initialCard?.backgroundColor ?? 0xFF111827,
        accentColor: widget.initialCard?.accentColor ?? 0xFF94A3B8,
      ),
    );
  }
}

class _CategoryFormSheet extends StatefulWidget {
  const _CategoryFormSheet();

  static Future<String?> show(BuildContext context) {
    return AppBottomSheet.show<String>(
      context: context,
      child: const _CategoryFormSheet(),
    );
  }

  @override
  State<_CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends State<_CategoryFormSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, bottom + 12),
      child: AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nova categoria',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInput(
              controller: _controller,
              label: 'Nome',
              hint: 'Ex.: Educação',
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Salvar categoria',
                onPressed: () {
                  final value = _controller.text.trim();
                  if (value.isEmpty) {
                    return;
                  }
                  Navigator.of(context).pop(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
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
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, bottom + 12),
      child: AppCard(
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
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, bottom + 12),
      child: AppCard(
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
  late final TextEditingController _billingController;
  late final TextEditingController _nextChargeController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialSubscription?.name ?? '');
    _amountController = TextEditingController(
      text: widget.initialSubscription?.amount.toStringAsFixed(2) ?? '0.00',
    );
    _billingController = TextEditingController(
      text: widget.initialSubscription?.billingCycle ?? 'monthly',
    );
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
    _billingController.dispose();
    _nextChargeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, bottom + 12),
      child: AppCard(
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
            AppInput(
              controller: _billingController,
              label: 'Ciclo',
              hint: 'monthly ou yearly',
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _nextChargeController,
              label: 'Próxima cobrança',
              hint: '05/07',
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: AppButton(label: 'Salvar assinatura', onPressed: _submit),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (_nameController.text.trim().isEmpty || amount == null) {
      return;
    }
    final now = DateTime.now();
    final parts = _nextChargeController.text.trim().split('/');
    final nextCharge = parts.length == 2
        ? DateTime(now.year, int.tryParse(parts[1]) ?? now.month, int.tryParse(parts[0]) ?? now.day)
        : now;
    Navigator.of(context).pop(
      SubscriptionModel(
        id: widget.initialSubscription?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        amount: amount,
        billingCycle: _billingController.text.trim().isEmpty
            ? 'monthly'
            : _billingController.text.trim(),
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
  late final TextEditingController _typeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialEvent?.title ?? '');
    _typeController =
        TextEditingController(text: widget.initialEvent?.type ?? 'custom');
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
    _typeController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 12, 12, bottom + 12),
      child: AppCard(
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
            AppInput(controller: _typeController, label: 'Tipo', hint: 'card_due'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _descriptionController, label: 'Descrição', hint: 'Opcional'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _amountController, label: 'Valor', hint: '0.00'),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(controller: _dateController, label: 'Data', hint: '10/07'),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: AppButton(label: 'Salvar evento', onPressed: _submit),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) {
      return;
    }
    final now = DateTime.now();
    final parts = _dateController.text.trim().split('/');
    final eventDate = parts.length == 2
        ? DateTime(now.year, int.tryParse(parts[1]) ?? now.month, int.tryParse(parts[0]) ?? now.day)
        : now;
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    Navigator.of(context).pop(
      CalendarEventModel(
        id: widget.initialEvent?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        type: _typeController.text.trim().isEmpty
            ? 'custom'
            : _typeController.text.trim(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        eventDate: eventDate,
        amount: amount,
      ),
    );
  }
}
