import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTagline.
  ///
  /// In fr, this message translates to:
  /// **'Le cinéma, même hors connexion.'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get navSearch;

  /// No description provided for @navFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get navFavorites;

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @seeAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout voir'**
  String get seeAll;

  /// No description provided for @seeMyFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Voir mes favoris'**
  String get seeMyFavorites;

  /// No description provided for @undo.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get undo;

  /// No description provided for @gotIt.
  ///
  /// In fr, this message translates to:
  /// **'Compris'**
  String get gotIt;

  /// No description provided for @loadErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les données.'**
  String get loadErrorTitle;

  /// No description provided for @cachedTag.
  ///
  /// In fr, this message translates to:
  /// **'EN CACHE'**
  String get cachedTag;

  /// No description provided for @notAvailable.
  ///
  /// In fr, this message translates to:
  /// **'—'**
  String get notAvailable;

  /// No description provided for @shortDatePattern.
  ///
  /// In fr, this message translates to:
  /// **'dd.MM.yy'**
  String get shortDatePattern;

  /// No description provided for @longDatePattern.
  ///
  /// In fr, this message translates to:
  /// **'dd.MM.yyyy'**
  String get longDatePattern;

  /// No description provided for @failureNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes hors connexion.'**
  String get failureNetwork;

  /// No description provided for @failureServer.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de contacter le serveur.'**
  String get failureServer;

  /// No description provided for @failureSessionExpired.
  ///
  /// In fr, this message translates to:
  /// **'Votre session a expiré.'**
  String get failureSessionExpired;

  /// No description provided for @failureNotSignedIn.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour gérer vos favoris.'**
  String get failureNotSignedIn;

  /// No description provided for @failureMovieNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Film introuvable.'**
  String get failureMovieNotFound;

  /// No description provided for @failureActorNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Acteur introuvable.'**
  String get failureActorNotFound;

  /// No description provided for @failureCache.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les données. Aucune donnée hors ligne n’est disponible.'**
  String get failureCache;

  /// No description provided for @failureUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur inattendue est survenue. Réessayez dans un instant.'**
  String get failureUnknown;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In fr, this message translates to:
  /// **'Email ou mot de passe incorrect.'**
  String get authInvalidCredentials;

  /// No description provided for @authEmailNotConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Confirmez votre adresse email avant de vous connecter.'**
  String get authEmailNotConfirmed;

  /// No description provided for @authUserAlreadyExists.
  ///
  /// In fr, this message translates to:
  /// **'Un compte existe déjà avec cet email.'**
  String get authUserAlreadyExists;

  /// No description provided for @authWeakPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe trop faible ({min} caractères minimum).'**
  String authWeakPassword(int min);

  /// No description provided for @authInvalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Adresse email invalide.'**
  String get authInvalidEmail;

  /// No description provided for @authRateLimited.
  ///
  /// In fr, this message translates to:
  /// **'Trop de tentatives. Réessayez dans quelques minutes.'**
  String get authRateLimited;

  /// No description provided for @authSignupDisabled.
  ///
  /// In fr, this message translates to:
  /// **'Les inscriptions sont désactivées.'**
  String get authSignupDisabled;

  /// No description provided for @authUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Authentification impossible. Réessayez.'**
  String get authUnknown;

  /// No description provided for @validationEmailRequired.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre email.'**
  String get validationEmailRequired;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre mot de passe.'**
  String get validationPasswordRequired;

  /// No description provided for @validationNewPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un mot de passe.'**
  String get validationNewPasswordRequired;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In fr, this message translates to:
  /// **'{min} caractères minimum.'**
  String validationPasswordTooShort(int min);

  /// No description provided for @validationConfirmationRequired.
  ///
  /// In fr, this message translates to:
  /// **'Confirmez le mot de passe.'**
  String get validationConfirmationRequired;

  /// No description provided for @validationPasswordsMismatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas.'**
  String get validationPasswordsMismatch;

  /// No description provided for @passwordsMatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe correspondent.'**
  String get passwordsMatch;

  /// No description provided for @passwordMinLength.
  ///
  /// In fr, this message translates to:
  /// **'{min} caractères minimum'**
  String passwordMinLength(int min);

  /// No description provided for @passwordStrength.
  ///
  /// In fr, this message translates to:
  /// **'{level, select, weak{robustesse faible} fair{robustesse moyenne} good{robustesse correcte} strong{robustesse forte} other{}}'**
  String passwordStrength(String level);

  /// No description provided for @loginWelcomeBack.
  ///
  /// In fr, this message translates to:
  /// **'Bon retour.'**
  String get loginWelcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour retrouver vos films et vos favoris.'**
  String get loginSubtitle;

  /// No description provided for @loginButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginButton;

  /// No description provided for @loginNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get loginNoAccount;

  /// No description provided for @loginSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Connexion réussie. Bonne séance, {name} !'**
  String loginSuccess(String name);

  /// No description provided for @fieldEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'vous@exemple.com'**
  String get fieldEmailHint;

  /// No description provided for @fieldPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get fieldPassword;

  /// No description provided for @fieldFullName.
  ///
  /// In fr, this message translates to:
  /// **'Nom et prénom'**
  String get fieldFullName;

  /// No description provided for @fieldFullNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Awa Konan'**
  String get fieldFullNameHint;

  /// No description provided for @fieldOptional.
  ///
  /// In fr, this message translates to:
  /// **'(facultatif)'**
  String get fieldOptional;

  /// No description provided for @fieldPasswordConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Confirmation du mot de passe'**
  String get fieldPasswordConfirmation;

  /// No description provided for @showPassword.
  ///
  /// In fr, this message translates to:
  /// **'Afficher le mot de passe'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In fr, this message translates to:
  /// **'Masquer le mot de passe'**
  String get hidePassword;

  /// No description provided for @registerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos favoris vous suivront partout, même sans réseau.'**
  String get registerSubtitle;

  /// No description provided for @registerButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get registerButton;

  /// No description provided for @registerAlreadyMember.
  ///
  /// In fr, this message translates to:
  /// **'Déjà inscrit ?'**
  String get registerAlreadyMember;

  /// No description provided for @registerSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Compte créé. Bienvenue, {name} !'**
  String registerSuccess(String name);

  /// No description provided for @confirmEmailTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez vos emails'**
  String get confirmEmailTitle;

  /// No description provided for @confirmEmailBody.
  ///
  /// In fr, this message translates to:
  /// **'Un lien de confirmation a été envoyé à {email}. Validez votre adresse puis connectez-vous.'**
  String confirmEmailBody(String email);

  /// No description provided for @greetingDay.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour'**
  String get greetingDay;

  /// No description provided for @greetingEvening.
  ///
  /// In fr, this message translates to:
  /// **'Bonsoir'**
  String get greetingEvening;

  /// No description provided for @searchMovieTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un film'**
  String get searchMovieTooltip;

  /// No description provided for @homeNoMovieForGenre.
  ///
  /// In fr, this message translates to:
  /// **'Aucun film de ce genre dans cette sélection.'**
  String get homeNoMovieForGenre;

  /// No description provided for @homeNoMovies.
  ///
  /// In fr, this message translates to:
  /// **'Aucun film pour le moment.'**
  String get homeNoMovies;

  /// No description provided for @homeOfflineNoData.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée hors ligne n’est disponible. Vérifiez votre connexion puis réessayez.'**
  String get homeOfflineNoData;

  /// No description provided for @featuredBadge.
  ///
  /// In fr, this message translates to:
  /// **'N°1 DES TENDANCES'**
  String get featuredBadge;

  /// No description provided for @genreAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get genreAll;

  /// No description provided for @categoryPopular.
  ///
  /// In fr, this message translates to:
  /// **'Populaires'**
  String get categoryPopular;

  /// No description provided for @categoryTrending.
  ///
  /// In fr, this message translates to:
  /// **'Tendances'**
  String get categoryTrending;

  /// No description provided for @categoryNowPlaying.
  ///
  /// In fr, this message translates to:
  /// **'Nouveautés'**
  String get categoryNowPlaying;

  /// No description provided for @offlineBanner.
  ///
  /// In fr, this message translates to:
  /// **'Hors connexion — affichage des dernières données disponibles.'**
  String get offlineBanner;

  /// No description provided for @offlineUpdated.
  ///
  /// In fr, this message translates to:
  /// **'MISES À JOUR {ago}'**
  String offlineUpdated(String ago);

  /// No description provided for @timeAgoJustNow.
  ///
  /// In fr, this message translates to:
  /// **'à l’instant'**
  String get timeAgoJustNow;

  /// No description provided for @timeAgoMinutes.
  ///
  /// In fr, this message translates to:
  /// **'il y a {count} min'**
  String timeAgoMinutes(int count);

  /// No description provided for @timeAgoHours.
  ///
  /// In fr, this message translates to:
  /// **'il y a {count} h'**
  String timeAgoHours(int count);

  /// No description provided for @timeAgoDays.
  ///
  /// In fr, this message translates to:
  /// **'il y a {count} j'**
  String timeAgoDays(int count);

  /// No description provided for @favoritesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes favoris'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun favori pour l’instant'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Touchez le cœur sur la fiche d’un film pour le garder ici. Vos favoris restent accessibles sans connexion.'**
  String get favoritesEmptyMessage;

  /// No description provided for @favoritesDiscover.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir des films'**
  String get favoritesDiscover;

  /// No description provided for @favoritesLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger vos favoris.'**
  String get favoritesLoadError;

  /// No description provided for @favoritesOfflineCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 film · disponible hors connexion} other{{count} films · disponibles hors connexion}}'**
  String favoritesOfflineCount(int count);

  /// No description provided for @favoriteRemovedNamed.
  ///
  /// In fr, this message translates to:
  /// **'« {title} » retiré des favoris.'**
  String favoriteRemovedNamed(String title);

  /// No description provided for @favoriteAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux favoris'**
  String get favoriteAdd;

  /// No description provided for @favoriteRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer des favoris'**
  String get favoriteRemove;

  /// No description provided for @favoriteAdded.
  ///
  /// In fr, this message translates to:
  /// **'Ajouté aux favoris · disponible hors connexion.'**
  String get favoriteAdded;

  /// No description provided for @favoriteRemoved.
  ///
  /// In fr, this message translates to:
  /// **'Retiré des favoris.'**
  String get favoriteRemoved;

  /// No description provided for @listEnd.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{FIN DE LA LISTE · 1 FILM} other{FIN DE LA LISTE · {count} FILMS}}'**
  String listEnd(int count);

  /// No description provided for @searchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get searchTitle;

  /// No description provided for @searchFieldLabel.
  ///
  /// In fr, this message translates to:
  /// **'TITRE DU FILM'**
  String get searchFieldLabel;

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un film…'**
  String get searchHint;

  /// No description provided for @searchClear.
  ///
  /// In fr, this message translates to:
  /// **'Effacer la recherche'**
  String get searchClear;

  /// No description provided for @searchOfflineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recherche indisponible hors connexion'**
  String get searchOfflineTitle;

  /// No description provided for @searchOfflineMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette recherche n’a pas encore été effectuée : aucun résultat n’est disponible hors ligne.'**
  String get searchOfflineMessage;

  /// No description provided for @searchFailedTitle.
  ///
  /// In fr, this message translates to:
  /// **'La recherche a échoué'**
  String get searchFailedTitle;

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get searchNoResultsTitle;

  /// No description provided for @searchNoResultsMessage.
  ///
  /// In fr, this message translates to:
  /// **'Aucun film ne correspond à « {query} ». Vérifiez l’orthographe ou essayez un autre titre.'**
  String searchNoResultsMessage(String query);

  /// No description provided for @searchMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez au moins {min} caractères.'**
  String searchMinLength(int min);

  /// No description provided for @searchIdleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez votre prochain film'**
  String get searchIdleTitle;

  /// No description provided for @searchIdleMessage.
  ///
  /// In fr, this message translates to:
  /// **'Recherchez parmi des milliers de films par leur titre.'**
  String get searchIdleMessage;

  /// No description provided for @searchRecent.
  ///
  /// In fr, this message translates to:
  /// **'RECHERCHES RÉCENTES'**
  String get searchRecent;

  /// No description provided for @searchResultCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{0 résultat} =1{1 résultat} other{{count} résultats}}'**
  String searchResultCount(int count);

  /// No description provided for @searchPage.
  ///
  /// In fr, this message translates to:
  /// **'PAGE {page} SUR {total}'**
  String searchPage(int page, int total);

  /// No description provided for @synopsis.
  ///
  /// In fr, this message translates to:
  /// **'Synopsis'**
  String get synopsis;

  /// No description provided for @synopsisUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Synopsis non disponible pour ce film.'**
  String get synopsisUnavailable;

  /// No description provided for @cast.
  ///
  /// In fr, this message translates to:
  /// **'Distribution'**
  String get cast;

  /// No description provided for @similarMovies.
  ///
  /// In fr, this message translates to:
  /// **'Films similaires'**
  String get similarMovies;

  /// No description provided for @movieNotFoundMessage.
  ///
  /// In fr, this message translates to:
  /// **'Ce film n’existe pas ou a été retiré de TMDB.'**
  String get movieNotFoundMessage;

  /// No description provided for @detailsOfflineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Fiche indisponible hors connexion'**
  String get detailsOfflineTitle;

  /// No description provided for @detailsOfflineMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette fiche n’a pas encore été consultée : elle n’est pas disponible hors ligne.'**
  String get detailsOfflineMessage;

  /// No description provided for @statRelease.
  ///
  /// In fr, this message translates to:
  /// **'SORTIE'**
  String get statRelease;

  /// No description provided for @statRuntime.
  ///
  /// In fr, this message translates to:
  /// **'DURÉE'**
  String get statRuntime;

  /// No description provided for @statRating.
  ///
  /// In fr, this message translates to:
  /// **'NOTE'**
  String get statRating;

  /// No description provided for @statPopularity.
  ///
  /// In fr, this message translates to:
  /// **'POPULARITÉ'**
  String get statPopularity;

  /// No description provided for @actorNotFoundMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette fiche n’existe pas ou a été retirée de TMDB.'**
  String get actorNotFoundMessage;

  /// No description provided for @actorBorn.
  ///
  /// In fr, this message translates to:
  /// **'{gender, select, female{NÉE LE {date}} male{NÉ LE {date}} other{NÉ·E LE {date}}}'**
  String actorBorn(String gender, String date);

  /// No description provided for @actorDied.
  ///
  /// In fr, this message translates to:
  /// **'{gender, select, female{DÉCÉDÉE LE {date}} male{DÉCÉDÉ LE {date}} other{DÉCÉDÉ·E LE {date}}}'**
  String actorDied(String gender, String date);

  /// No description provided for @actorKnownFor.
  ///
  /// In fr, this message translates to:
  /// **'{gender, select, female{CONNUE POUR} other{CONNU POUR}}'**
  String actorKnownFor(String gender);

  /// No description provided for @actorFilms.
  ///
  /// In fr, this message translates to:
  /// **'FILMS'**
  String get actorFilms;

  /// No description provided for @biography.
  ///
  /// In fr, this message translates to:
  /// **'Biographie'**
  String get biography;

  /// No description provided for @biographyUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune biographie disponible.'**
  String get biographyUnavailable;

  /// No description provided for @filmography.
  ///
  /// In fr, this message translates to:
  /// **'Filmographie'**
  String get filmography;

  /// No description provided for @filmCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 FILM} other{{count} FILMS}}'**
  String filmCount(int count);

  /// No description provided for @readMore.
  ///
  /// In fr, this message translates to:
  /// **'Lire la suite'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In fr, this message translates to:
  /// **'Réduire'**
  String get readLess;

  /// No description provided for @departmentActing.
  ///
  /// In fr, this message translates to:
  /// **'Interprétation'**
  String get departmentActing;

  /// No description provided for @departmentDirecting.
  ///
  /// In fr, this message translates to:
  /// **'Réalisation'**
  String get departmentDirecting;

  /// No description provided for @departmentWriting.
  ///
  /// In fr, this message translates to:
  /// **'Scénario'**
  String get departmentWriting;

  /// No description provided for @departmentProduction.
  ///
  /// In fr, this message translates to:
  /// **'Production'**
  String get departmentProduction;

  /// No description provided for @departmentSound.
  ///
  /// In fr, this message translates to:
  /// **'Musique & son'**
  String get departmentSound;

  /// No description provided for @departmentCamera.
  ///
  /// In fr, this message translates to:
  /// **'Image'**
  String get departmentCamera;

  /// No description provided for @departmentEditing.
  ///
  /// In fr, this message translates to:
  /// **'Montage'**
  String get departmentEditing;

  /// No description provided for @departmentArt.
  ///
  /// In fr, this message translates to:
  /// **'Direction artistique'**
  String get departmentArt;

  /// No description provided for @departmentCostume.
  ///
  /// In fr, this message translates to:
  /// **'Costumes & maquillage'**
  String get departmentCostume;

  /// No description provided for @departmentVisualEffects.
  ///
  /// In fr, this message translates to:
  /// **'Effets visuels'**
  String get departmentVisualEffects;

  /// No description provided for @departmentLighting.
  ///
  /// In fr, this message translates to:
  /// **'Éclairage'**
  String get departmentLighting;

  /// No description provided for @departmentCrew.
  ///
  /// In fr, this message translates to:
  /// **'Équipe technique'**
  String get departmentCrew;

  /// No description provided for @departmentOther.
  ///
  /// In fr, this message translates to:
  /// **'Cinéma'**
  String get departmentOther;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @profileAccount.
  ///
  /// In fr, this message translates to:
  /// **'COMPTE'**
  String get profileAccount;

  /// No description provided for @profileEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileMemberSince.
  ///
  /// In fr, this message translates to:
  /// **'Membre depuis'**
  String get profileMemberSince;

  /// No description provided for @profileSession.
  ///
  /// In fr, this message translates to:
  /// **'SESSION'**
  String get profileSession;

  /// No description provided for @profileState.
  ///
  /// In fr, this message translates to:
  /// **'État'**
  String get profileState;

  /// No description provided for @profileAuthentication.
  ///
  /// In fr, this message translates to:
  /// **'Authentification'**
  String get profileAuthentication;

  /// No description provided for @profileAccessToken.
  ///
  /// In fr, this message translates to:
  /// **'Jeton d’accès'**
  String get profileAccessToken;

  /// No description provided for @profileOfflineData.
  ///
  /// In fr, this message translates to:
  /// **'DONNÉES HORS CONNEXION'**
  String get profileOfflineData;

  /// No description provided for @profileCachedMovies.
  ///
  /// In fr, this message translates to:
  /// **'Films en cache'**
  String get profileCachedMovies;

  /// No description provided for @profileFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get profileFavorites;

  /// No description provided for @profileLastUpdate.
  ///
  /// In fr, this message translates to:
  /// **'Dernière mise à jour'**
  String get profileLastUpdate;

  /// No description provided for @profileNever.
  ///
  /// In fr, this message translates to:
  /// **'JAMAIS'**
  String get profileNever;

  /// No description provided for @profilePreferences.
  ///
  /// In fr, this message translates to:
  /// **'PRÉFÉRENCES'**
  String get profilePreferences;

  /// No description provided for @profileLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get profileLanguage;

  /// No description provided for @sessionActive.
  ///
  /// In fr, this message translates to:
  /// **'Active'**
  String get sessionActive;

  /// No description provided for @sessionExpired.
  ///
  /// In fr, this message translates to:
  /// **'Expirée'**
  String get sessionExpired;

  /// No description provided for @tokenExpired.
  ///
  /// In fr, this message translates to:
  /// **'EXPIRÉ'**
  String get tokenExpired;

  /// No description provided for @tokenExpiresInMinutes.
  ///
  /// In fr, this message translates to:
  /// **'EXPIRE DANS {minutes} MIN'**
  String tokenExpiresInMinutes(int minutes);

  /// No description provided for @tokenExpiresInHours.
  ///
  /// In fr, this message translates to:
  /// **'EXPIRE DANS {hours} H {minutes}'**
  String tokenExpiresInHours(int hours, String minutes);

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logout;

  /// No description provided for @logoutSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes déconnecté. À bientôt !'**
  String get logoutSuccess;

  /// No description provided for @reconnect.
  ///
  /// In fr, this message translates to:
  /// **'Se reconnecter'**
  String get reconnect;

  /// No description provided for @tmdbDisclaimer.
  ///
  /// In fr, this message translates to:
  /// **'Ce produit utilise l’API TMDB mais n’est ni approuvé ni certifié par TMDB.'**
  String get tmdbDisclaimer;

  /// No description provided for @languageSheetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Langue de l’application'**
  String get languageSheetTitle;

  /// No description provided for @languageSystem.
  ///
  /// In fr, this message translates to:
  /// **'Langue de l’appareil'**
  String get languageSystem;

  /// No description provided for @languageFrench.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageEnglish.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @a11yRating.
  ///
  /// In fr, this message translates to:
  /// **'note {rating} sur 10'**
  String a11yRating(String rating);

  /// No description provided for @a11yFeatured.
  ///
  /// In fr, this message translates to:
  /// **'N°1 des tendances : {summary}'**
  String a11yFeatured(String summary);

  /// No description provided for @a11yCastMember.
  ///
  /// In fr, this message translates to:
  /// **'{name}, dans le rôle de {character}'**
  String a11yCastMember(String name, String character);

  /// No description provided for @a11yLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement en cours'**
  String get a11yLoading;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
