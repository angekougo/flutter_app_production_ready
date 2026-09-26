import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/extensions/async_value_x.dart';
import '../../../../shared/extensions/l10n_x.dart';
import '../../../../shared/widgets/app_snack_bar.dart';
import '../../domain/validators/auth_validators.dart';
import '../providers/auth_controllers.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/form_feedback.dart';
import '../widgets/labeled_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(loginControllerProvider.notifier)
        .submit(email: _email.text, password: _password.text);
  }

  void _clearServerError(String _) =>
      ref.read(loginControllerProvider.notifier).clearError();

  @override
  Widget build(BuildContext context) {
    // Le routeur redirige seul vers l'accueil ; on confirme la connexion.
    ref.listen(loginControllerProvider, (previous, next) {
      final user = next.value;
      if ((previous?.isLoading ?? false) && user != null) {
        showAppSnackBar(
          ScaffoldMessenger.of(context),
          context.l10n.loginSuccess(user.firstName),
          tone: SnackTone.success,
        );
      }
    });

    final state = ref.watch(loginControllerProvider);
    final l10n = context.l10n;
    final serverError = switch (state.failure) {
      final failure? => l10n.failureMessage(failure),
      null => null,
    };

    return AuthScaffold(
      body: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.xxl + 8),
              Text(
                AppConstants.appName,
                style: AppTypography.section.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 72),
              Text(l10n.loginWelcomeBack, style: AppTypography.display),
              const SizedBox(height: AppDimensions.md),
              Text(
                l10n.loginSubtitle,
                style: AppTypography.body.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 40),
              LabeledTextField(
                label: l10n.fieldEmail,
                controller: _email,
                hint: l10n.fieldEmailHint,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: (v) =>
                    l10n.validationMessage(AuthValidators.email(v)),
                onChanged: _clearServerError,
              ),
              const SizedBox(height: AppDimensions.xl),
              LabeledTextField(
                label: l10n.fieldPassword,
                controller: _password,
                isPassword: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                validator: (v) =>
                    l10n.validationMessage(AuthValidators.requiredPassword(v)),
                onChanged: _clearServerError,
                onSubmitted: (_) => _submit(),
                highlight: serverError != null ? AppColors.signal : null,
              ),
              if (serverError != null) FormErrorMessage(serverError),
              const SizedBox(height: AppDimensions.xxl),
              LoadingFilledButton(
                label: l10n.loginButton,
                isLoading: state.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
      footer: AuthFooterLink(
        question: l10n.loginNoAccount,
        action: l10n.registerTitle,
        onTap: () => context.push(RoutePaths.register),
      ),
    );
  }
}
