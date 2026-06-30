import 'package:fluxa/core/theme/brand.dart';
import 'package:fluxa/core/theme/colors.dart';
import 'package:fluxa/core/theme/spacing.dart';
import 'package:fluxa/models/user_preferences.dart';
import 'package:fluxa/shared/widgets/app_button.dart';
import 'package:fluxa/shared/widgets/app_card.dart';
import 'package:fluxa/shared/widgets/app_input.dart';
import 'package:fluxa/shared/widgets/section_heading.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
    required this.initialPreferences,
    required this.onContinueLocal,
    required this.onSyncWithGoogle,
    required this.onSyncWithEmail,
  });

  final UserPreferences initialPreferences;
  final Future<void> Function(UserPreferences preferences) onContinueLocal;
  final Future<void> Function(UserPreferences preferences) onSyncWithGoogle;
  final Future<void> Function(UserPreferences preferences) onSyncWithEmail;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late final TextEditingController _controller;
  late AppAppearance _appearance;
  bool _isSubmitting = false;
  static const _occupationOptions = [
    'Estudante',
    'CLT',
    'Autônomo',
    'Empreendedor',
  ];
  String? _selectedOccupation;

  @override
  void initState() {
    super.initState();
    final sanitizedName = widget.initialPreferences.displayName.trim().toLowerCase() == 'nik'
        ? ''
        : widget.initialPreferences.displayName;
    _controller = TextEditingController(text: sanitizedName);
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
              title: 'No fluxo certo desde o começo',
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/brand/fluxa-adaptive-foreground.png',
                        height: 48,
                        width: 48,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          AppBrand.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppBrand.tagline,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
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
                    'Com o que você trabalha?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _occupationOptions.map((occupation) {
                      return ChoiceChip(
                        label: Text(occupation),
                        selected: _selectedOccupation == occupation,
                        showCheckmark: false,
                        onSelected: (_) {
                          setState(() => _selectedOccupation = occupation);
                        },
                      );
                    }).toList(),
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
                        showCheckmark: false,
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
              onPressed: _isSubmitting ? null : _continueLocal,
              label: 'Continuar neste aparelho',
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: _isSubmitting ? null : _syncWithGoogle,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        children: [
                          TextSpan(text: 'G', style: TextStyle(color: Color(0xFF4285F4))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('Entrar com Google'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: TextButton(
                onPressed: _isSubmitting ? null : _syncWithEmail,
                child: const Text('Usar e-mail para sincronização'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _continueLocal() async {
    await _runSubmit(() => widget.onContinueLocal(_preferences));
  }

  Future<void> _syncWithGoogle() async {
    await _runSubmit(() => widget.onSyncWithGoogle(_preferences));
  }

  Future<void> _syncWithEmail() async {
    await _runSubmit(() => widget.onSyncWithEmail(_preferences));
  }

  Future<void> _runSubmit(Future<void> Function() action) async {
    setState(() {
      _isSubmitting = true;
    });
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
