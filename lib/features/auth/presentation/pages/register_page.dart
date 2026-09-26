import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/extensions/async_value_x.dart';
import '../../../../shared/extensions/l10n_x.dart';
import '../../../../shared/widgets/app_snack_bar.dart';
import '../../domain/entities/sign_up_result.dart';
import '../../domain/validators/auth_validators.dart';
import '../providers/auth_controllers.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/form_feedback.dart';
import '../widgets/labeled_text_field.dart';
import '../widgets/password_strength_indicator.dart';

/// Inscription.
///
/// Les contrôleurs de saisie sont des hooks (créés et libérés avec l'écran).
/// L'écran ne les écoute pas : seuls la jauge de robustesse et le champ de
/// confirmation se reconstruisent pendant la frappe.
class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final fullName = useTextEditingController();
    final email = useTextEditingController();
    final password = useTextEditingController();
    final confirmation = useTextEditingController();

    void submit() {
      FocusScope.of(context).unfocus();
      if (!formKey.currentState!.validate()) return;
      ref
          .read(registerControllerProvider.notifier)
          .submit(
            email: email.text,
            password: password.text,
            fullName: fullName.text,
          );
    }

    void clearServerError(String _) =>
        ref.read(registerControllerProvider.notifier).clearError();

    // Si une session est ouverte, le routeur redirige seul vers l'accueil.
    ref.listen(registerControllerProvider, (previous, next) {
      final result = next.value;
      final justSubmitted = previous?.isLoading ?? false;
      if (!justSubmitted || result is! SignUpResult) return;
      if (result.emailConfirmationRequired) {
        _showConfirmEmailDialog(context, result.user.email);
      } else {
        showAppSnackBar(
          ScaffoldMessenger.of(context),
          context.l10n.registerSuccess(result.user.firstName),
          tone: SnackTone.success,
        );
      }
    });

    final state = ref.watch(registerControllerProvider);
    final l10n = context.l10n;
    final serverError = switch (state.failure) {
      final failure? => l10n.failureMessage(failure),
      null => null,
    };

    return AuthScaffold(
      body: Form(
        key: formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.md),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: l10n.back,
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
              Semantics(
                header: true,
                child: Text(
                  l10n.registerTitle,
                  style: AppTypography.display.copyWith(fontSize: 40),
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              Text(
                l10n.registerSubtitle,
                style: AppTypography.body.copyWith(fontSize: 16),
              ),
              const SizedBox(height: AppDimensions.xxl),
              LabeledTextField(
                label: l10n.fieldFullName,
                optionalHint: l10n.fieldOptional,
                controller: fullName,
                hint: l10n.fieldFullNameHint,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
              ),
              const SizedBox(height: AppDimensions.xl),
              LabeledTextField(
                label: l10n.fieldEmail,
                controller: email,
                hint: l10n.fieldEmailHint,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: (v) =>
                    l10n.validationMessage(AuthValidators.email(v)),
                onChanged: clearServerError,
              ),
              const SizedBox(height: AppDimensions.xl),
              LabeledTextField(
                label: l10n.fieldPassword,
                controller: password,
                isPassword: true,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                validator: (v) =>
                    l10n.validationMessage(AuthValidators.newPassword(v)),
                onChanged: clearServerError,
              ),
              _LivePasswordStrength(password: password),
              const SizedBox(height: AppDimensions.xl),
              _ConfirmationField(
                password: password,
                confirmation: confirmation,
                onSubmitted: submit,
              ),
              if (serverError != null) FormErrorMessage(serverError),
              const SizedBox(height: AppDimensions.xxl),
              LoadingFilledButton(
                label: l10n.registerButton,
                isLoading: state.isLoading,
                onPressed: submit,
              ),
            ],
          ),
        ),
      ),
      footer: AuthFooterLink(
        question: l10n.registerAlreadyMember,
        action: l10n.loginButton,
        onTap: () =>
            context.canPop() ? context.pop() : context.go(RoutePaths.login),
      ),
    );
  }

  Future<void> _showConfirmEmailDialog(
    BuildContext context,
    String email,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.velours,
        title: Text(
          context.l10n.confirmEmailTitle,
          style: AppTypography.section,
        ),
        content: Text(
          context.l10n.confirmEmailBody(email),
          style: AppTypography.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.gotIt),
          ),
        ],
      ),
    );
    if (context.mounted) context.go(RoutePaths.login);
  }
}

/// Jauge de robustesse : seul widget reconstruit à la frappe du mot de passe.
class _LivePasswordStrength extends HookWidget {
  const _LivePasswordStrength({required this.password});

  final TextEditingController password;

  @override
  Widget build(BuildContext context) {
    final text = useValueListenable(password).text;
    return PasswordStrengthIndicator(strength: PasswordStrength.evaluate(text));
  }
}

/// Champ de confirmation : bordure verte/rouge et message selon qu'il
/// correspond au mot de passe. Écoute les deux champs.
class _ConfirmationField extends HookWidget {
  const _ConfirmationField({
    required this.password,
    required this.confirmation,
    required this.onSubmitted,
  });

  final TextEditingController password;
  final TextEditingController confirmation;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    useListenable(
      useMemoized(() => Listenable.merge([password, confirmation]), [
        password,
        confirmation,
      ]),
    );
    final l10n = context.l10n;
    final typed = confirmation.text;
    final matches = typed.isNotEmpty && typed == password.text;
    final mismatch =
        typed.isNotEmpty && typed.length >= password.text.length && !matches;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledTextField(
          label: l10n.fieldPasswordConfirmation,
          controller: confirmation,
          isPassword: true,
          textInputAction: TextInputAction.done,
          validator: (v) => l10n.validationMessage(
            AuthValidators.confirmation(v, password.text),
          ),
          onSubmitted: (_) => onSubmitted(),
          highlight: matches
              ? AppColors.menthe
              : (mismatch ? AppColors.signal : null),
          suffix: matches
              ? const Icon(Icons.check_rounded, color: AppColors.menthe)
              : null,
        ),
        if (matches || mismatch)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.md),
            child: Text(
              matches ? l10n.passwordsMatch : l10n.validationPasswordsMismatch,
              style: AppTypography.caption.copyWith(
                fontSize: 14,
                color: matches ? AppColors.menthe : AppColors.signal,
              ),
            ),
          ),
      ],
    );
  }
}
