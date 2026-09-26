import 'package:flutter/widgets.dart';
import 'package:flutter_app_production_ready/core/error/failures.dart';
import 'package:flutter_app_production_ready/features/actors/domain/entities/actor_details.dart';
import 'package:flutter_app_production_ready/features/actors/presentation/pages/actor_details_page.dart';
import 'package:flutter_app_production_ready/features/auth/domain/validators/auth_validators.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_category.dart';
import 'package:flutter_app_production_ready/l10n/app_localizations.dart';
import 'package:flutter_app_production_ready/shared/extensions/l10n_x.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Traductions et formats, sans widget : la présentation ne doit jamais
/// afficher un message vide ni un texte dans la mauvaise langue.
void main() {
  final fr = lookupAppLocalizations(const Locale('fr'));
  final en = lookupAppLocalizations(const Locale('en'));

  setUpAll(initializeDateFormatting);

  const allFailures = <Failure>[
    NetworkFailure(),
    ServerFailure(),
    UnauthorizedFailure(),
    UnauthorizedFailure(UnauthorizedReason.notSignedIn),
    NotFoundFailure(),
    NotFoundFailure(NotFoundResource.actor),
    CacheFailure(),
    AuthFailure(),
    AuthFailure(AuthErrorReason.rateLimited),
    UnknownFailure(),
  ];

  group('messages d’erreur', () {
    test(
      'chaque Failure a un message distinct et non vide, en FR et en EN',
      () {
        for (final l10n in [fr, en]) {
          final messages = allFailures.map(l10n.failureMessage).toList();
          expect(messages, everyElement(isNotEmpty));
          expect(messages.toSet(), hasLength(messages.length));
        }
      },
    );

    test('le message suit la langue et la ressource manquante', () {
      expect(
        fr.failureMessage(const NetworkFailure()),
        'Vous êtes hors connexion.',
      );
      expect(en.failureMessage(const NetworkFailure()), 'You are offline.');
      expect(
        fr.failureMessage(const NotFoundFailure(NotFoundResource.actor)),
        'Acteur introuvable.',
      );
      expect(
        en.failureMessage(const AuthFailure(AuthErrorReason.weakPassword)),
        'Password too weak (at least 8 characters).',
      );
    });
  });

  test('erreurs de validation traduites (null = champ valide)', () {
    expect(fr.validationMessage(null), isNull);
    expect(
      fr.validationMessage(AuthValidators.email('awa@')),
      'Adresse email invalide.',
    );
    expect(
      en.validationMessage(AuthValidators.newPassword('1234')),
      'At least 8 characters.',
    );
    expect(
      en.validationMessage(AuthValidators.confirmation('a', 'b')),
      'Passwords do not match.',
    );
  });

  group('formats selon la langue', () {
    test('séparateur décimal des notes', () {
      expect(fr.rating(7.863), '7,9');
      expect(en.rating(7.863), '7.9');
    });

    test('dates courtes et longues', () {
      final date = DateTime(2024, 3, 12);
      expect(fr.shortDate(date), '12.03.24');
      expect(en.shortDate(date), '03/12/24');
      expect(fr.longDate(date), '12.03.2024');
      expect(en.longDate(date), 'Mar 12, 2024');
    });

    test('durée relative', () {
      final now = DateTime(2026, 9, 26, 12);
      expect(fr.timeAgo(now, now: now), 'à l’instant');
      expect(
        fr.timeAgo(now.subtract(const Duration(minutes: 5)), now: now),
        'il y a 5 min',
      );
      expect(
        en.timeAgo(now.subtract(const Duration(hours: 3)), now: now),
        '3 h ago',
      );
    });

    test('pluriels', () {
      expect(fr.searchResultCount(1), '1 résultat');
      expect(fr.searchResultCount(12), '12 résultats');
      expect(en.searchResultCount(1), '1 result');
      expect(en.favoritesOfflineCount(3), '3 movies · available offline');
    });
  });

  test('libellés des catégories dans les deux langues', () {
    expect(MovieCategory.values.map(fr.categoryLabel), [
      'Populaires',
      'Tendances',
      'Nouveautés',
    ]);
    expect(MovieCategory.values.map(en.categoryLabel), [
      'Popular',
      'Trending',
      'Now playing',
    ]);
  });

  test('fiche acteur : accord en genre (FR) et date localisée (EN)', () {
    final actress = ActorDetails(
      id: 1,
      name: 'Awa',
      gender: ActorGender.female,
      birthday: DateTime(1988, 3, 14),
      placeOfBirth: 'Lyon, France',
    );
    expect(actorBirthLine(actress, fr), 'NÉE LE 14.03.1988 · LYON');
    expect(actorBirthLine(actress, en), 'BORN MAR 14, 1988 · LYON');
    expect(fr.actorKnownFor(fr.genderKey(ActorGender.male)), 'CONNU POUR');
    expect(fr.departmentLabel('Directing'), 'Réalisation');
    expect(en.departmentLabel('Unknown dept'), 'Film');
  });

  test('salutation selon l’heure', () {
    expect(fr.greeting(DateTime(2026, 1, 1, 9)), 'Bonjour');
    expect(fr.greeting(DateTime(2026, 1, 1, 21)), 'Bonsoir');
    expect(en.greeting(DateTime(2026, 1, 1, 21)), 'Good evening');
  });
}
