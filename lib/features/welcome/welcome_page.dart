import 'package:financas/core/theme/spacing.dart';
import 'package:financas/models/user_preferences.dart';
import 'package:financas/shared/widgets/app_button.dart';
import 'package:financas/shared/widgets/app_card.dart';
import 'package:financas/shared/widgets/app_input.dart';
import 'package:financas/shared/widgets/section_heading.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
    required this.initialPreferences,
    required this.onContinueLocal,
    required this.onSyncWithGoogle,
  });

  final UserPreferences initialPreferences;
  final ValueChanged<UserPreferences> onContinueLocal;
  final ValueChanged<UserPreferences> onSyncWithGoogle;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late final TextEditingController _controller;
  late AppAppearance _appearance;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialPreferences.displayName);
    _appearance = widget.initialPreferences.appearance;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  UserPreferences get _preferences => UserPreferences(
        displayName: _controller.text.trim(),
        appearance: _appearance,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
          children: [
            const SectionHeading(
              eyebrow: 'Primeiro acesso',
              title: 'Olá, bem-vindo',
              description:
                  'Organize sua vida financeira com leveza. O app guarda seus dados financeiros e suas preferências, não dados pessoais sensíveis.',
            ),
            const SizedBox(height: AppSpacing.lg + 8),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Como você quer ser chamado?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 14),
                  AppInput(
                    controller: _controller,
                    hint: 'Nome de exibição opcional',
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Aparência',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: AppAppearance.values.map((appearance) {
                      final selected = appearance == _appearance;
                      return ChoiceChip(
                        label: Text(appearance.label),
                        selected: selected,
                        onSelected: (_) {
                          setState(() => _appearance = appearance);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacidade primeiro',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Não salvamos número completo de cartão, CVV ou credenciais bancárias. Entrar com Google serve apenas para sincronizar seus dados entre aparelhos.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg + 8),
            AppButton(
              onPressed: () => widget.onContinueLocal(_preferences),
              label: 'Continuar neste aparelho',
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              onPressed: () => widget.onSyncWithGoogle(_preferences),
              label: 'Sincronizar com Google',
              variant: AppButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
