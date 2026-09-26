import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/failures.dart';

extension AsyncValueFailureX on AsyncValue<Object?> {
  /// Erreur courante sous forme de [Failure] ; une erreur imprévue (bug)
  /// devient une [UnknownFailure] pour que l'UI affiche toujours un état
  /// d'erreur, jamais un chargement sans fin.
  Failure? get failure => switch (error) {
    null => null,
    final Failure f => f,
    _ => const UnknownFailure(),
  };

  /// Message utilisateur de l'erreur courante.
  String? get failureMessage => failure?.message;
}
