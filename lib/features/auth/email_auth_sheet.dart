import 'package:financas/core/theme/spacing.dart';
import 'package:financas/shared/widgets/app_bottom_sheet.dart';
import 'package:financas/shared/widgets/app_button.dart';
import 'package:financas/shared/widgets/app_card.dart';
import 'package:financas/shared/widgets/app_input.dart';
import 'package:flutter/material.dart';

enum EmailAuthMode { signIn, signUp }

class EmailAuthResult {
  const EmailAuthResult({
    required this.mode,
    required this.email,
    required this.password,
  });

  final EmailAuthMode mode;
  final String email;
  final String password;
}

class EmailAuthSheet extends StatefulWidget {
  const EmailAuthSheet({super.key});

  static Future<EmailAuthResult?> show(BuildContext context) {
    return AppBottomSheet.show<EmailAuthResult>(
      context: context,
      child: const EmailAuthSheet(),
    );
  }

  @override
  State<EmailAuthSheet> createState() => _EmailAuthSheetState();
}

class _EmailAuthSheetState extends State<EmailAuthSheet> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  EmailAuthMode _mode = EmailAuthMode.signIn;

  bool get _isSignUp => _mode == EmailAuthMode.signUp;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              _isSignUp ? 'Criar conta de sincronização' : 'Entrar para sincronizar',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'O acesso por e-mail só serve para restaurar seus dados em outro aparelho.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInput(
              controller: _emailController,
              label: 'E-mail',
              hint: 'voce@email.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            AppInput(
              controller: _passwordController,
              label: 'Senha',
              hint: 'Mínimo de 6 caracteres',
            ),
            const SizedBox(height: AppSpacing.lg - 2),
            SegmentedButton<EmailAuthMode>(
              segments: const [
                ButtonSegment(
                  value: EmailAuthMode.signIn,
                  label: Text('Entrar'),
                ),
                ButtonSegment(
                  value: EmailAuthMode.signUp,
                  label: Text('Criar conta'),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (selection) {
                setState(() {
                  _mode = selection.first;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: _submit,
                label: _isSignUp ? 'Criar conta' : 'Entrar',
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
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (!email.contains('@') || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Use um e-mail válido e uma senha com pelo menos 6 caracteres.'),
        ),
      );
      return;
    }

    Navigator.of(context).pop(
      EmailAuthResult(
        mode: _mode,
        email: email,
        password: password,
      ),
    );
  }
}
