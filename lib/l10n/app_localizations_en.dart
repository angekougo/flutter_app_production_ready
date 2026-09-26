// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTagline => 'Movies, even offline.';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navProfile => 'Profile';

  @override
  String get retry => 'Retry';

  @override
  String get back => 'Back';

  @override
  String get seeAll => 'See all';

  @override
  String get seeMyFavorites => 'See my favorites';

  @override
  String get undo => 'Undo';

  @override
  String get gotIt => 'Got it';

  @override
  String get loadErrorTitle => 'Unable to load data.';

  @override
  String get cachedTag => 'CACHED';

  @override
  String get notAvailable => '—';

  @override
  String get shortDatePattern => 'MM/dd/yy';

  @override
  String get longDatePattern => 'MMM d, yyyy';

  @override
  String get failureNetwork => 'You are offline.';

  @override
  String get failureServer => 'Unable to reach the server.';

  @override
  String get failureSessionExpired => 'Your session has expired.';

  @override
  String get failureNotSignedIn => 'Sign in to manage your favorites.';

  @override
  String get failureMovieNotFound => 'Movie not found.';

  @override
  String get failureActorNotFound => 'Actor not found.';

  @override
  String get failureCache =>
      'Unable to load data. No offline data is available.';

  @override
  String get failureUnknown =>
      'An unexpected error occurred. Please try again in a moment.';

  @override
  String get authInvalidCredentials => 'Incorrect email or password.';

  @override
  String get authEmailNotConfirmed =>
      'Please confirm your email address before signing in.';

  @override
  String get authUserAlreadyExists =>
      'An account already exists with this email.';

  @override
  String authWeakPassword(int min) {
    return 'Password too weak (at least $min characters).';
  }

  @override
  String get authInvalidEmail => 'Invalid email address.';

  @override
  String get authRateLimited =>
      'Too many attempts. Please try again in a few minutes.';

  @override
  String get authSignupDisabled => 'Sign-ups are disabled.';

  @override
  String get authUnknown => 'Authentication failed. Please try again.';

  @override
  String get validationEmailRequired => 'Enter your email.';

  @override
  String get validationPasswordRequired => 'Enter your password.';

  @override
  String get validationNewPasswordRequired => 'Choose a password.';

  @override
  String validationPasswordTooShort(int min) {
    return 'At least $min characters.';
  }

  @override
  String get validationConfirmationRequired => 'Confirm your password.';

  @override
  String get validationPasswordsMismatch => 'Passwords do not match.';

  @override
  String get passwordsMatch => 'Passwords match.';

  @override
  String passwordMinLength(int min) {
    return 'At least $min characters';
  }

  @override
  String passwordStrength(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'weak': 'weak strength',
      'fair': 'fair strength',
      'good': 'good strength',
      'strong': 'strong strength',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get loginWelcomeBack => 'Welcome back.';

  @override
  String get loginSubtitle =>
      'Sign in to get back to your movies and favorites.';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginNoAccount => 'No account yet?';

  @override
  String loginSuccess(String name) {
    return 'Signed in. Enjoy the show, $name!';
  }

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldEmailHint => 'you@example.com';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldFullName => 'Full name';

  @override
  String get fieldFullNameHint => 'Awa Konan';

  @override
  String get fieldOptional => '(optional)';

  @override
  String get fieldPasswordConfirmation => 'Confirm password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get registerTitle => 'Create an account';

  @override
  String get registerSubtitle =>
      'Your favorites follow you everywhere, even offline.';

  @override
  String get registerButton => 'Create my account';

  @override
  String get registerAlreadyMember => 'Already have an account?';

  @override
  String registerSuccess(String name) {
    return 'Account created. Welcome, $name!';
  }

  @override
  String get confirmEmailTitle => 'Check your inbox';

  @override
  String confirmEmailBody(String email) {
    return 'A confirmation link was sent to $email. Confirm your address, then sign in.';
  }

  @override
  String get greetingDay => 'Hello';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get searchMovieTooltip => 'Search for a movie';

  @override
  String get homeNoMovieForGenre =>
      'No movies of this genre in this selection.';

  @override
  String get homeNoMovies => 'No movies at the moment.';

  @override
  String get homeOfflineNoData =>
      'No offline data is available. Check your connection and try again.';

  @override
  String get featuredBadge => '#1 TRENDING';

  @override
  String get genreAll => 'All';

  @override
  String get categoryPopular => 'Popular';

  @override
  String get categoryTrending => 'Trending';

  @override
  String get categoryNowPlaying => 'Now playing';

  @override
  String get offlineBanner => 'Offline — showing the latest available data.';

  @override
  String offlineUpdated(String ago) {
    return 'UPDATED $ago';
  }

  @override
  String get timeAgoJustNow => 'just now';

  @override
  String timeAgoMinutes(int count) {
    return '$count min ago';
  }

  @override
  String timeAgoHours(int count) {
    return '$count h ago';
  }

  @override
  String timeAgoDays(int count) {
    return '$count d ago';
  }

  @override
  String get favoritesTitle => 'My favorites';

  @override
  String get favoritesEmptyTitle => 'No favorites yet';

  @override
  String get favoritesEmptyMessage =>
      'Tap the heart on a movie page to keep it here. Your favorites stay available offline.';

  @override
  String get favoritesDiscover => 'Discover movies';

  @override
  String get favoritesLoadError => 'Unable to load your favorites.';

  @override
  String favoritesOfflineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count movies · available offline',
      one: '1 movie · available offline',
    );
    return '$_temp0';
  }

  @override
  String favoriteRemovedNamed(String title) {
    return '“$title” removed from favorites.';
  }

  @override
  String get favoriteAdd => 'Add to favorites';

  @override
  String get favoriteRemove => 'Remove from favorites';

  @override
  String get favoriteAdded => 'Added to favorites · available offline.';

  @override
  String get favoriteRemoved => 'Removed from favorites.';

  @override
  String listEnd(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'END OF LIST · $count MOVIES',
      one: 'END OF LIST · 1 MOVIE',
    );
    return '$_temp0';
  }

  @override
  String get searchTitle => 'Search';

  @override
  String get searchFieldLabel => 'MOVIE TITLE';

  @override
  String get searchHint => 'Search for a movie…';

  @override
  String get searchClear => 'Clear search';

  @override
  String get searchOfflineTitle => 'Search unavailable offline';

  @override
  String get searchOfflineMessage =>
      'This search has not been run before: no results are available offline.';

  @override
  String get searchFailedTitle => 'Search failed';

  @override
  String get searchNoResultsTitle => 'No results';

  @override
  String searchNoResultsMessage(String query) {
    return 'No movie matches “$query”. Check the spelling or try another title.';
  }

  @override
  String searchMinLength(int min) {
    return 'Type at least $min characters.';
  }

  @override
  String get searchIdleTitle => 'Find your next movie';

  @override
  String get searchIdleMessage => 'Search thousands of movies by title.';

  @override
  String get searchRecent => 'RECENT SEARCHES';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
    );
    return '$_temp0';
  }

  @override
  String searchPage(int page, int total) {
    return 'PAGE $page OF $total';
  }

  @override
  String get synopsis => 'Overview';

  @override
  String get synopsisUnavailable => 'No overview available for this movie.';

  @override
  String get cast => 'Cast';

  @override
  String get similarMovies => 'Similar movies';

  @override
  String get movieNotFoundMessage =>
      'This movie does not exist or was removed from TMDB.';

  @override
  String get detailsOfflineTitle => 'Page unavailable offline';

  @override
  String get detailsOfflineMessage =>
      'You have not opened this page before: it is not available offline.';

  @override
  String get statRelease => 'RELEASE';

  @override
  String get statRuntime => 'RUNTIME';

  @override
  String get statRating => 'RATING';

  @override
  String get statPopularity => 'POPULARITY';

  @override
  String get actorNotFoundMessage =>
      'This page does not exist or was removed from TMDB.';

  @override
  String actorBorn(String gender, String date) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'BORN $date',
      'male': 'BORN $date',
      'other': 'BORN $date',
    });
    return '$_temp0';
  }

  @override
  String actorDied(String gender, String date) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'DIED $date',
      'male': 'DIED $date',
      'other': 'DIED $date',
    });
    return '$_temp0';
  }

  @override
  String actorKnownFor(String gender) {
    String _temp0 = intl.Intl.selectLogic(gender, {
      'female': 'KNOWN FOR',
      'other': 'KNOWN FOR',
    });
    return '$_temp0';
  }

  @override
  String get actorFilms => 'MOVIES';

  @override
  String get biography => 'Biography';

  @override
  String get biographyUnavailable => 'No biography available.';

  @override
  String get filmography => 'Filmography';

  @override
  String filmCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count MOVIES',
      one: '1 MOVIE',
    );
    return '$_temp0';
  }

  @override
  String get readMore => 'Read more';

  @override
  String get readLess => 'Show less';

  @override
  String get departmentActing => 'Acting';

  @override
  String get departmentDirecting => 'Directing';

  @override
  String get departmentWriting => 'Writing';

  @override
  String get departmentProduction => 'Production';

  @override
  String get departmentSound => 'Sound';

  @override
  String get departmentCamera => 'Camera';

  @override
  String get departmentEditing => 'Editing';

  @override
  String get departmentArt => 'Art direction';

  @override
  String get departmentCostume => 'Costume & make-up';

  @override
  String get departmentVisualEffects => 'Visual effects';

  @override
  String get departmentLighting => 'Lighting';

  @override
  String get departmentCrew => 'Crew';

  @override
  String get departmentOther => 'Film';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileAccount => 'ACCOUNT';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileMemberSince => 'Member since';

  @override
  String get profileSession => 'SESSION';

  @override
  String get profileState => 'Status';

  @override
  String get profileAuthentication => 'Authentication';

  @override
  String get profileAccessToken => 'Access token';

  @override
  String get profileOfflineData => 'OFFLINE DATA';

  @override
  String get profileCachedMovies => 'Cached movies';

  @override
  String get profileFavorites => 'Favorites';

  @override
  String get profileLastUpdate => 'Last update';

  @override
  String get profileNever => 'NEVER';

  @override
  String get profilePreferences => 'PREFERENCES';

  @override
  String get profileLanguage => 'Language';

  @override
  String get sessionActive => 'Active';

  @override
  String get sessionExpired => 'Expired';

  @override
  String get tokenExpired => 'EXPIRED';

  @override
  String tokenExpiresInMinutes(int minutes) {
    return 'EXPIRES IN $minutes MIN';
  }

  @override
  String tokenExpiresInHours(int hours, String minutes) {
    return 'EXPIRES IN $hours H $minutes';
  }

  @override
  String get logout => 'Sign out';

  @override
  String get logoutSuccess => 'You are signed out. See you soon!';

  @override
  String get reconnect => 'Sign in again';

  @override
  String get tmdbDisclaimer =>
      'This product uses the TMDB API but is not endorsed or certified by TMDB.';

  @override
  String get languageSheetTitle => 'App language';

  @override
  String get languageSystem => 'Device language';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'English';
}
