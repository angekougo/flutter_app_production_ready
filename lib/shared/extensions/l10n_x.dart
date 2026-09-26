import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../core/error/failures.dart';
import '../../features/actors/domain/entities/actor_details.dart';
import '../../features/auth/domain/validators/auth_validators.dart';
import '../../features/movies/domain/entities/movie_category.dart';
import '../../l10n/app_localizations.dart';

extension L10nContextX on BuildContext {
  /// Traductions de la langue courante : `context.l10n.retry`.
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Traduction des types du domaine (qui ne portent aucun texte).
extension DomainMessagesX on AppLocalizations {
  String failureMessage(Failure failure) => switch (failure) {
    NetworkFailure() => failureNetwork,
    ServerFailure() => failureServer,
    UnauthorizedFailure(reason: UnauthorizedReason.sessionExpired) =>
      failureSessionExpired,
    UnauthorizedFailure(reason: UnauthorizedReason.notSignedIn) =>
      failureNotSignedIn,
    NotFoundFailure(resource: NotFoundResource.movie) => failureMovieNotFound,
    NotFoundFailure(resource: NotFoundResource.actor) => failureActorNotFound,
    CacheFailure() => failureCache,
    AuthFailure(:final reason) => authErrorMessage(reason),
    UnknownFailure() => failureUnknown,
  };

  String authErrorMessage(AuthErrorReason reason) => switch (reason) {
    AuthErrorReason.invalidCredentials => authInvalidCredentials,
    AuthErrorReason.emailNotConfirmed => authEmailNotConfirmed,
    AuthErrorReason.userAlreadyExists => authUserAlreadyExists,
    AuthErrorReason.weakPassword => authWeakPassword(
      AuthValidators.minPasswordLength,
    ),
    AuthErrorReason.invalidEmail => authInvalidEmail,
    AuthErrorReason.rateLimited => authRateLimited,
    AuthErrorReason.signupDisabled => authSignupDisabled,
    AuthErrorReason.unknown => authUnknown,
  };

  /// Message d'un validateur de formulaire (`null` = champ valide).
  String? validationMessage(AuthValidationError? error) => switch (error) {
    null => null,
    AuthValidationError.emailRequired => validationEmailRequired,
    AuthValidationError.emailInvalid => authInvalidEmail,
    AuthValidationError.passwordRequired => validationPasswordRequired,
    AuthValidationError.newPasswordRequired => validationNewPasswordRequired,
    AuthValidationError.passwordTooShort => validationPasswordTooShort(
      AuthValidators.minPasswordLength,
    ),
    AuthValidationError.confirmationRequired => validationConfirmationRequired,
    AuthValidationError.confirmationMismatch => validationPasswordsMismatch,
  };

  String passwordStrengthLabel(PasswordStrength strength) =>
      passwordStrength(strength.name);

  String categoryLabel(MovieCategory category) => switch (category) {
    MovieCategory.popular => categoryPopular,
    MovieCategory.trending => categoryTrending,
    MovieCategory.nowPlaying => categoryNowPlaying,
  };

  /// Département TMDB traduit (« Acting » → « Interprétation »).
  String departmentLabel(String? department) => switch (department) {
    'Acting' => departmentActing,
    'Directing' => departmentDirecting,
    'Writing' => departmentWriting,
    'Production' => departmentProduction,
    'Sound' => departmentSound,
    'Camera' => departmentCamera,
    'Editing' => departmentEditing,
    'Art' => departmentArt,
    'Costume & Make-Up' => departmentCostume,
    'Visual Effects' => departmentVisualEffects,
    'Lighting' => departmentLighting,
    'Crew' => departmentCrew,
    _ => departmentOther,
  };

  /// Clé ICU `select` du genre grammatical (« NÉE » / « NÉ » / « NÉ·E »).
  String genderKey(ActorGender gender) => switch (gender) {
    ActorGender.female => 'female',
    ActorGender.male => 'male',
    ActorGender.unknown => 'other',
  };

  /// Résumé lu par les lecteurs d'écran à la place du visuel d'un film :
  /// « Marée Basse, 2024, Thriller, note 8,2 sur 10 ».
  String movieSummary(
    String title, {
    int? year,
    String? genre,
    double? rating,
  }) => [
    title,
    if (year != null) '$year',
    ?genre,
    if (rating != null) a11yRating(this.rating(rating)),
  ].join(', ');

  /// Salutation selon l'heure : « Bonjour » de 5 h à 18 h, sinon « Bonsoir ».
  String greeting(DateTime now) =>
      (now.hour >= 5 && now.hour < 18) ? greetingDay : greetingEvening;
}

/// Formats dépendant de la langue (décimales, dates, durées relatives).
extension LocaleFormatX on AppLocalizations {
  /// Note : 7.863 → « 7,9 » (FR) / « 7.9 » (EN).
  String rating(double value) => NumberFormat('0.0', localeName).format(value);

  /// Popularité TMDB : 91.43 → « 91,4 » (FR) / « 91.4 » (EN).
  String popularity(double value) =>
      NumberFormat('0.0', localeName).format(value);

  /// « 12.03.24 » (FR) / « 03/12/24 » (EN) : bandeau de la fiche film.
  String shortDate(DateTime date) =>
      DateFormat(shortDatePattern, localeName).format(date);

  /// « 14.03.1988 » (FR) / « Mar 14, 1988 » (EN) : date de naissance.
  String longDate(DateTime date) =>
      DateFormat(longDatePattern, localeName).format(date);

  /// « mars 2026 » (FR) / « March 2026 » (EN).
  String monthYear(DateTime date) => DateFormat.yMMMM(localeName).format(date);

  /// « il y a 2 min » / « 2 min ago ».
  String timeAgo(DateTime date, {DateTime? now}) {
    final diff = (now ?? DateTime.now()).difference(date);
    if (diff.inMinutes < 1) return timeAgoJustNow;
    if (diff.inHours < 1) return timeAgoMinutes(diff.inMinutes);
    if (diff.inDays < 1) return timeAgoHours(diff.inHours);
    return timeAgoDays(diff.inDays);
  }
}
