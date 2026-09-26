import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/extensions/async_value_x.dart';
import '../../../../shared/widgets/app_snack_bar.dart';
import '../../domain/entities/sign_up_result.dart';
import '../../domain/validators/auth_validators.dart';
import '../providers/auth_controllers.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/form_feedback.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/password_strength_indicator.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Rafraîchit la jauge de robustesse et l'état de la confirmation.
    _password.addListener(_refresh);
    _confirmation.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    for (final c in [_fullName, _email, _password, _confirmation]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(registerControllerProvider.notifier)
        .submit(
          email: _email.text,
          password: _password.text,
          fullName: _fullName.text,
        );
  }

  void _clearServerError(String _) =>
      ref.read(registerControllerProvider.notifier).clearError();

  Future<void> _showConfirmEmailDialog(String email) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.velours,
        title: Text('Vérifiez vos emails', style: AppTypography.section),
        content: Text(
          'Un lien de confirmation a été envoyé à $email. '
          'Validez votre adresse puis connectez-vous.',
          style: AppTypography.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
    if (mounted) context.go(RoutePaths.login);
  }

  @override
  Widget build(BuildContext context) {
    // Si une session est ouverte, le routeur redirige seul vers l'accueil.
    ref.listen(registerControllerProvider, (previous, next) {
      final result = next.value;
      final justSubmitted = previous?.isLoading ?? false;
      if (!justSubmitted || result is! SignUpResult) return;
      if (result.emailConfirmationRequired) {
        _showConfirmEmailDialog(result.user.email);
      } else {
        showAppSnackBar(
          ScaffoldMessenger.of(context),
          'Compte créé. Bienvenue, ${result.user.firstName} !',
          tone: SnackTone.success,
        );
      }
    });

    final state = ref.watch(registerControllerProvider);
    final serverError = state.failureMessage;
    final strength = PasswordStrength.evaluate(_password.text);
    final confirmationMatches =
        _confirmation.text.isNotEmpty && _confirmation.text == _password.text;
    final confirmationMismatch =
        _confirmation.text.length >= _password.text.length &&
        _confirmation.text.isNotEmpty &&
        !confirmationMatches;

    return AuthScaffold(
      body: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.md),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: 'Retour',
                  onPressed: () => context.canPop()
                      ? context.pop()
                      : context.go(RoutePaths.login),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.xl),
              Text(
                'Créer un compte',
                style: AppTypography.display.copyWith(fontSize: 40),
              ),
              const SizedBox(height: AppDimensions.md),
              Text(
                'Vos favoris vous suivront partout, même sans réseau.',
                style: AppTypography.body.copyWith(fontSize: 16),
              ),
              const SizedBox(height: AppDimensions.xxl),
              LabeledTextField(
                label: 'Nom et prénom',
                optionalHint: '(facultatif)',
                controller: _fullName,
                hint: 'Awa Konan',
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
              ),
              const SizedBox(height: AppDimensions.xl),
              LabeledTextField(
                label: 'Email',
                controller: _email,
                hint: 'vous@exemple.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: AuthValidators.email,
                onChanged: _clearServerError,
              ),
              const SizedBox(height: AppDimensions.xl),
              LabeledTextField(
                label: 'Mot de passe',
                controller: _password,
                isPassword: true,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                validator: AuthValidators.newPassword,
                onChanged: _clearServerError,
              ),
              PasswordStrengthIndicator(strength: strength),
              const SizedBox(height: AppDimensions.xl),
              LabeledTextField(
                label: 'Confirmation du mot de passe',
                controller: _confirmation,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    AuthValidators.confirmation(v, _password.text),
                onSubmitted: (_) => _submit(),
                highlight: confirmationMatches
                    ? AppColors.menthe
                    : (confirmationMismatch ? AppColors.signal : null),
                suffix: confirmationMatches
                    ? const Icon(Icons.check_rounded, color: AppColors.menthe)
                    : null,
              ),
              if (confirmationMatches || confirmationMismatch)
                Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.md),
                  child: Text(
                    confirmationMatches
                        ? 'Les mots de passe correspondent.'
                        : 'Les mots de passe ne correspondent pas.',
                    style: AppTypography.caption.copyWith(
                      fontSize: 14,
                      color: confirmationMatches
                          ? AppColors.menthe
                          : AppColors.signal,
                    ),
                  ),
                ),
              if (serverError != null) FormErrorMessage(serverError),
              const SizedBox(height: AppDimensions.xxl),
              LoadingFilledButton(
                label: 'Créer mon compte',
                isLoading: state.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
      footer: AuthFooterLink(
        question: 'Déjà inscrit ?',
        action: 'Se connecter',
        onTap: () =>
            context.canPop() ? context.pop() : context.go(RoutePaths.login),
      ),
    );
  }
}
