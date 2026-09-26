# Changelog

Toutes les évolutions notables de Cinéthèque sont documentées ici.

Format : [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/) ·
Versionnage : [Semantic Versioning](https://semver.org/lang/fr/).

## [2.0.0] – 2026-09-26

Version **production-ready** : performance mesurée, tests de bout en bout,
intégration et livraison continues.

### Ajouté

- **Tests d'intégration** (`integration_test/`) sur l'application complète avec
  un backend en mémoire :
  - connexion (échec puis succès) → fiche film → favori → onglet Favoris →
    retrait annulé ;
  - session restaurée → recherche → fiche → passage en anglais → déconnexion.
- **Mesure du défilement à 60 fps** (`watchPerformance`, mode profile) : accueil
  et grille de 60 affiches ; échec si le 90ᵉ centile de construction d'image
  dépasse 16 ms ou si plus de 5 % des images sortent du budget.
- **CI/CD GitHub Actions** : format, traductions à jour, `flutter analyze
  --fatal-infos`, tests avec couverture, tests d'intégration sur bureau Linux,
  APK de release ; release GitHub avec l'APK sur chaque tag `v*`.
- **Signature de release** Android via `key.properties` (keystore fourni par
  les secrets de la CI, clé de debug à défaut).
- **Polices embarquées** (Manrope, Fraunces, IBM Plex Mono, licences OFL
  enregistrées) : aucun téléchargement au premier lancement.
- Captures d'écran générées depuis l'application (`tool/screenshots`).
- Tests de reconstructions (`test/performance/`) et de contraste WCAG de la
  palette.

### Modifié

- **flutter_hooks** (via `hooks_riverpod`) pour tout l'état local : contrôleurs
  de saisie, animations, bascules. Plus aucun `StatefulWidget` dans les écrans.
- **Reconstructions ciblées** : la frappe ne reconstruit plus les écrans
  Inscription et Recherche (3 → 0 et 1 → 0 reconstructions mesurées) ;
  `select` et égalité par valeur sur l'accueil ; horloge du Profil isolée.
- **Images** téléchargées et décodées à la taille affichée (taille d'affiche
  TMDB adaptée, `memCacheWidth` selon la densité d'écran).
- Squelettes de chargement animés sans reconstruction (`FadeTransition` +
  `RepaintBoundary`) ; casting complet construit à la demande.
- Étoile des notes dessinée avec l'icône Material : rendu identique sur tous
  les appareils (aucune police de l'app ne contient « ★ »).
- Identifiant Android `io.github.angekougo.cinetheque` : **installation
  distincte de la 1.x** (changement majeur).

### Corrigé

- **Permission `INTERNET` absente du manifeste principal** : l'APK de release
  ne pouvait joindre ni TMDB ni Supabase.
- Profil : valeurs mal alignées et email tronqué (le libellé réservait la
  moitié de la ligne).
- Fiche film : libellé « POPULARITÉ » coupé sur deux lignes sur écran étroit.

## [1.1.0] – 2026-09-26

### Ajouté

- **Internationalisation français / anglais** (`flutter gen-l10n`, fichiers
  ARB) : pluriels et accords en genre en ICU, nombres et dates au format de la
  langue.
- **Choix de la langue** dans le Profil (langue de l'appareil par défaut),
  mémorisé ; les contenus TMDB (titres, synopsis, genres) suivent la langue.
- **Accessibilité** : affiches, cartes et casting annoncés comme boutons avec un
  résumé (« Titre, 2024, Drame, note 8,2 sur 10 ») ; titres en en-têtes ;
  bannière hors ligne en zone live ; état du favori ; chargement annoncé.
- Tests : traductions, formats, changement de langue, règles d'accessibilité
  Flutter sur 6 écrans, libellés sémantiques FR/EN.

### Modifié

- Le domaine ne contient plus aucun texte : `Failure` et validateurs exposent
  des types, traduits par la présentation.
- Cibles tactiles portées à 48 dp (« Tout voir », « Lire la suite », liens des
  formulaires).

## [1.0.0] – 2026-09-26

Version issue de la certification « Flutter — App connectée avec backend
réel » ([angekougo/cinetheque](https://github.com/angekougo/cinetheque)).

### Ajouté

- Authentification Supabase (inscription, connexion, déconnexion), session
  chiffrée, garde de navigation GoRouter, rafraîchissement du JWT.
- Films TMDB : accueil (tendances, populaires, nouveautés, filtres par genre),
  « Tout voir » paginé, recherche avec anti-rebond, fiche film, fiche acteur.
- Favoris locaux par utilisateur ; profil (compte, session, données hors ligne).
- Cache Isar et stratégie « réseau d'abord, cache en secours » : application
  utilisable hors connexion.
- Clean Architecture feature-first, Riverpod 3, chaîne d'erreurs
  `AppException → Failure → Result`.
- 94 tests unitaires et de widgets.

[2.0.0]: https://github.com/angekougo/flutter_app_production_ready/compare/v1.1.0...v2.0.0
[1.1.0]: https://github.com/angekougo/flutter_app_production_ready/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/angekougo/flutter_app_production_ready/releases/tag/v1.0.0
