import 'package:flutter/material.dart';

import '../../../../app/theme/app_dimensions.dart';

/// Mise en page commune Login/Register : contenu défilant, pied de page
/// (« Créer un compte » / « Se connecter ») collé en bas quand il y a la place.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.body, required this.footer});

  final Widget body;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    body,
                    const Spacer(),
                    const SizedBox(height: AppDimensions.xxl),
                    footer,
                    const SizedBox(height: AppDimensions.xl),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
