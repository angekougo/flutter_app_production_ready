import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/extensions/async_value_x.dart';
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
          'Connexion réussie. Bonne séance, ${user.firstName} !',
          tone: SnackTone.success,
        );
      }
    });

    final state = ref.watch(loginControllerProvider);
    final serverError = state.failureMessage;

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
              Text('Bon retour.', style: AppTypography.display),
              const SizedBox(height: AppDimensions.md),
              Text(
                'Connectez-vous pour retrouver vos films et vos favoris.',
                style: AppTypography.body.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 40),
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
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                validator: AuthValidators.requiredPassword,
                onChanged: _clearServerError,
                onSubmitted: (_) => _submit(),
                highlight: serverError != null ? AppColors.signal : null,
              ),
              if (serverError != null) FormErrorMessage(serverError),
              const SizedBox(height: AppDimensions.xxl),
              LoadingFilledButton(
                label: 'Se connecter',
                isLoading: state.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
      footer: AuthFooterLink(
        question: 'Pas encore de compte ?',
        action: 'Créer un compte',
        onTap: () => context.push(RoutePaths.register),
      ),
    );
  }
}
