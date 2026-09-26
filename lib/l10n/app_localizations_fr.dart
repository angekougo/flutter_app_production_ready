// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTagline => 'Le cinéma, même hors connexion.';

  @override
  String get navHome => 'Accueil';

  @override
  String get navSearch => 'Recherche';

  @override
  String get navFavorites => 'Favoris';

  @override
  String get navProfile => 'Profil';

  @override
  String get retry => 'Réessayer';

  @override
  String get back => 'Retour';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get seeMyFavorites => 'Voir mes favoris';

  @override
  String get undo => 'Annuler';

  @override
  String get gotIt => 'Compris';

  @override
  String get loadErrorTitle => 'Impossible de charger les données.';

  @override
  String get cachedTag => 'EN CACHE';

  @override
  String get notAvailable => '—';

  @override
  String get shortDatePattern => 'dd.MM.yy';

  @override
  String get longDatePattern => 'dd.MM.yyyy';

  @override
  String get failureNetwork => 'Vous êtes hors connexion.';

  @override
  String get failureServer => 'Impossible de contacter le serveur.';

  @override
  String get failureSessionExpired => 'Votre session a expiré.';

  @override
  String get failureNotSignedIn => 'Connectez-vous pour gérer vos favoris.';

  @override
  String get failureMovieNotFound => 'Film introuvable.';

  @override
  String get failureActorNotFound => 'Acteur introuvable.';

  @override
  String get failureCache =>
      'Impossible de charger les données. Aucune donnée hors ligne n’est disponible.';

  @override
  String get failureUnknown =>
      'Une erreur inattendue est survenue. Réessayez dans un instant.';

  @override
  String get authInvalidCredentials => 'Email ou mot de passe incorrect.';

  @override
  String get authEmailNotConfirmed =>
      'Confirmez votre adresse email avant de vous connecter.';

  @override
  String get authUserAlreadyExists => 'Un compte existe déjà avec cet email.';

  @override
  String authWeakPassword(int min) {
    return 'Mot de passe trop faible ($min caractères minimum).';
  }

  @override
  String get authInvalidEmail => 'Adresse email invalide.';

  @override
  String get authRateLimited =>
      'Trop de tentatives. Réessayez dans quelques minutes.';

  @override
  String get authSignupDisabled => 'Les inscriptions sont désactivées.';

  @override
  String get authUnknown => 'Authentification impossible. Réessayez.';

  @override
  String get validationEmailRequired => 'Saisissez votre email.';

  @override
  String get validationPasswordRequired => 'Saisissez votre mot de passe.';

  @override
  String get validationNewPasswordRequired => 'Choisissez un mot de passe.';

  @override
  String validationPasswordTooShort(int min) {
    return '$min caractères minimum.';
  }

  @override
  String get validationConfirmationRequired => 'Confirmez le mot de passe.';

  @override
  String get validationPasswordsMismatch =>
      'Les mots de passe ne correspondent pas.';

  @override
  String get passwordsMatch => 'Les mots de passe correspondent.';

  @override
  String passwordMinLength(int min) {
    return '$min caractères minimum';
  }

  @override
  String passwordStrength(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'weak': 'robustesse faible',
      'fair': 'robustesse moyenne',
      'good': 'robustesse correcte',
      'strong': 'robustesse forte',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get loginWelcomeBack => 'Bon retour.';

  @override
  String get loginSubtitle =>
      'Connectez-vous pour retrouver vos films et vos favoris.';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginNoAccount => 'Pas encore de compte ?';

  @override
  String loginSuccess(String name) {
    return 'Connexion réussie. Bonne séance, $name !';
  }

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldEmailHint => 'vous@exemple.com';

  @override
  String get fieldPassword => 'Mot de passe';

  @override
  String get fieldFullName => 'Nom et prénom';

  @override
  String get fieldFullNameHint => 'Awa Konan';

  @override
  String get fieldOptional => '(facultatif)';

  @override
  String get fieldPasswordConfirmation => 'Confirmation du mot de passe';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get registerTitle => 'Créer un compte';

  @override
  String get registerSubtitle =>
      'Vos favoris vous suivront partout, même sans réseau.';

  @override
  String get registerButton => 'Créer mon compte';

  @override
  String get registerAlreadyMember => 'Déjà inscrit ?';

  @override
  String registerSuccess(String name) {
    return 'Compte créé. Bienvenue, $name !';
  }

  @override
  String get confirmEmailTitle => 'Vérifiez vos emails';

  @override
  String confirmEmailBody(String email) {
    return 'Un lien de confirmation a été envoyé à $email. Validez votre adresse puis connectez-vous.';
  }

  @override
  String get greetingDay => 'Bonjour';

  @override
  String get greetingEvening => 'Bonsoir';

  @override
  String get searchMovieTooltip => 'Rechercher un film';

  @override
  String get homeNoMovieForGenre =>
      'Aucun film de ce genre dans cette sélection.';

  @override
  String get homeNoMovies => 'Aucun film pour le moment.';

  @override
  String get homeOfflineNoData =>
      'Aucune donnée hors ligne n’est disponible. Vérifiez votre connexion puis réessayez.';

  @override
  String get featuredBadge => 'N°1 DES TENDANCES';

  @override
  String get genreAll => 'Tous';

  @override
  String get categoryPopular => 'Populaires';

  @override
  String get categoryTrending => 'Tendances';

  @override
  String get categoryNowPlaying => 'Nouveautés';

  @override
  String get offlineBanner =>
      'Hors connexion — affichage des dernières données disponibles.';

  @override
  String offlineUpdated(String ago) {
    return 'MISES À JOUR $ago';
  }

  @override
  String get timeAgoJustNow => 'à l’instant';

  @override
  String timeAgoMinutes(int count) {
    return 'il y a $count min';
  }

  @override
  String timeAgoHours(int count) {
    return 'il y a $count h';
  }

  @override
  String timeAgoDays(int count) {
    return 'il y a $count j';
  }

  @override
  String get favoritesTitle => 'Mes favoris';

  @override
  String get favoritesEmptyTitle => 'Aucun favori pour l’instant';

  @override
  String get favoritesEmptyMessage =>
      'Touchez le cœur sur la fiche d’un film pour le garder ici. Vos favoris restent accessibles sans connexion.';

  @override
  String get favoritesDiscover => 'Découvrir des films';

  @override
  String get favoritesLoadError => 'Impossible de charger vos favoris.';

  @override
  String favoritesOfflineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count films · disponibles hors connexion',
      one: '1 film · disponible hors connexion',
    );
    return '$_temp0';
  }

  @override
  String favoriteRemovedNamed(String title) {
    return '« $title » retiré des favoris.';
  }

  @override
  String get favoriteAdd => 'Ajouter aux favoris';

  @override
  String get favoriteRemove => 'Retirer des favoris';

  @override
  String get favoriteAdded => 'Ajouté aux favoris · disponible hors connexion.';

  @override
  String get favoriteRemoved => 'Retiré des favoris.';

  @override
  String listEnd(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'FIN DE LA LISTE · $count FILMS',
      one: 'FIN DE LA LISTE · 1 FILM',
    );
    return '$_temp0';
  }

  @override
  String get searchTitle => 'Recherche';

  @override
  String get searchFieldLabel => 'TITRE DU FILM';

  @override
  String get searchHint => 'Rechercher un film…';

  @override
  String get searchClear => 'Effacer la recherche';

  @override
  String get searchOfflineTitle => 'Recherche indisponible hors connexion';

  @override
  String get searchOfflineMessage =>
      'Cette recherche n’a pas encore été effectuée : aucun résultat n’est disponible hors ligne.';

  @override
  String get searchFailedTitle => 'La recherche a échoué';

  @override
  String get searchNoResultsTitle => 'Aucun résultat';

  @override
  String searchNoResultsMessage(String query) {
    return 'Aucun film ne correspond à « $query ». Vérifiez l’orthographe ou essayez un autre titre.';
  }

  @override
  String searchMinLength(int min) {
    return 'Saisissez au moins $min caractères.';
  }

  @override
  String get searchIdleTitle => 'Trouvez votre prochain film';

  @override
  String get searchIdleMessage =>
      'Recherchez parmi des milliers de films par leur titre.';

  @override
  String get searchRecent => 'RECHERCHES RÉCENTES';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count résultats',
      one: '1 résultat',
      zero: '0 résultat',
    );
    return '$_temp0';
  }

  @override
  String searchPage(int page, int total) {
    return 'PAGE $page SUR $total';
  }

  @override
  String get synopsis => 'Synopsis';

  @override
  String get synopsisUnavailable => 'Synopsis non disponible pour ce film.';

  @override
  String get cast => 'Distribution';

  @override
  String get similarMovies => 'Films similaires';

  @override
  String get movieNotFoundMessage =>
      'Ce film n’existe pas ou a été retiré de TMDB.';

  @override
  String get detailsOfflineTitle => 'Fiche indisponible hors connexion';

  @override
  String get detailsOfflineMessage =>
      'Cette fiche n’a pas encore été consultée : elle n’est pas disponible hors ligne.';

  @override
  String get statRelease => 'SORTIE';

  @override
  String get statRuntime => 'DURÉE';

  @override
  String get statRating => 'NOTE';

  @override
  String get statPopularity => 'POPULARITÉ';

  @override
  String get actorNotFoundMessage =>
      'Cette fiche n’existe pas ou a été retirée de TMDB.';

  @override
  String actorBorn(String gender, String date) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'NÉE LE $date',
      'male': 'NÉ LE $date',
      'other': 'NÉ·E LE $date',
    });
    return '$_temp0';
  }

  @override
  String actorDied(String gender, String date) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'DÉCÉDÉE LE $date',
      'male': 'DÉCÉDÉ LE $date',
      'other': 'DÉCÉDÉ·E LE $date',
    });
    return '$_temp0';
  }

  @override
  String actorKnownFor(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'CONNUE POUR',
      'other': 'CONNU POUR',
    });
    return '$_temp0';
  }

  @override
  String get actorFilms => 'FILMS';

  @override
  String get biography => 'Biographie';

  @override
  String get biographyUnavailable => 'Aucune biographie disponible.';

  @override
  String get filmography => 'Filmographie';

  @override
  String filmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count FILMS',
      one: '1 FILM',
    );
    return '$_temp0';
  }

  @override
  String get readMore => 'Lire la suite';

  @override
  String get readLess => 'Réduire';

  @override
  String get departmentActing => 'Interprétation';

  @override
  String get departmentDirecting => 'Réalisation';

  @override
  String get departmentWriting => 'Scénario';

  @override
  String get departmentProduction => 'Production';

  @override
  String get departmentSound => 'Musique & son';

  @override
  String get departmentCamera => 'Image';

  @override
  String get departmentEditing => 'Montage';

  @override
  String get departmentArt => 'Direction artistique';

  @override
  String get departmentCostume => 'Costumes & maquillage';

  @override
  String get departmentVisualEffects => 'Effets visuels';

  @override
  String get departmentLighting => 'Éclairage';

  @override
  String get departmentCrew => 'Équipe technique';

  @override
  String get departmentOther => 'Cinéma';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileAccount => 'COMPTE';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileMemberSince => 'Membre depuis';

  @override
  String get profileSession => 'SESSION';

  @override
  String get profileState => 'État';

  @override
  String get profileAuthentication => 'Authentification';

  @override
  String get profileAccessToken => 'Jeton d’accès';

  @override
  String get profileOfflineData => 'DONNÉES HORS CONNEXION';

  @override
  String get profileCachedMovies => 'Films en cache';

  @override
  String get profileFavorites => 'Favoris';

  @override
  String get profileLastUpdate => 'Dernière mise à jour';

  @override
  String get profileNever => 'JAMAIS';

  @override
  String get profilePreferences => 'PRÉFÉRENCES';

  @override
  String get profileLanguage => 'Langue';

  @override
  String get sessionActive => 'Active';

  @override
  String get sessionExpired => 'Expirée';

  @override
  String get tokenExpired => 'EXPIRÉ';

  @override
  String tokenExpiresInMinutes(int minutes) {
    return 'EXPIRE DANS $minutes MIN';
  }

  @override
  String tokenExpiresInHours(int hours, String minutes) {
    return 'EXPIRE DANS $hours H $minutes';
  }

  @override
  String get logout => 'Se déconnecter';

  @override
  String get logoutSuccess => 'Vous êtes déconnecté. À bientôt !';

  @override
  String get reconnect => 'Se reconnecter';

  @override
  String get tmdbDisclaimer =>
      'Ce produit utilise l’API TMDB mais n’est ni approuvé ni certifié par TMDB.';

  @override
  String get languageSheetTitle => 'Langue de l’application';

  @override
  String get languageSystem => 'Langue de l’appareil';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'English';
}
