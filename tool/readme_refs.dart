// Génère la section « Vérification des exigences » du README : pour chaque
// exigence du projet, les fichiers, les numéros de ligne et un aperçu du code.
//
// Les extraits sont repérés par leur contenu, jamais par des numéros écrits à
// la main : les lignes indiquées restent justes quand le code évolue.
//
//   dart run tool/readme_refs.dart           # met à jour README.md
//   dart run tool/readme_refs.dart --check   # échoue si README.md est périmé (CI)
import 'dart:convert';
import 'dart:io';

const _readme = 'README.md';
const _begin = '<!-- REFS:START -->';
const _end = '<!-- REFS:END -->';
const _repo = 'https://github.com/angekougo/flutter_app_production_ready';

// ─── Description des exigences ──────────────────────────────────────────────

List<Requirement> requirements(TestCounts counts) => [
  Requirement(
    'Application fonctionnelle avec au moins 5 écrans',
    '**10 écrans**, déclarés dans le routeur GoRouter (onglets persistants et '
        'redirection selon la session). Tous les écrans sont des widgets '
        'Riverpod ; ceux qui ont un état local utilisent des hooks.',
    [
      Pick(
        'lib/app/router/app_router.dart',
        RegExp(r'builder: \(context, state\) =>'),
        'Les 10 routes et leur écran',
      ),
      for (final page in _pages)
        Pick(page, RegExp(r'^class \w+Page extends'), 'Déclaration de l’écran'),
    ],
  ),
  Requirement(
    'Au moins 10 tests unitaires (logique métier, providers, repositories)',
    '**${counts.unit} tests unitaires** (`test(`) dans `test/`. Extraits : '
        'logique métier (validateurs), repository (réseau, cache, erreurs), '
        'provider (contrôleur de recherche, langue).',
    [
      Pick(
        'test/features/movies/movie_repository_impl_test.dart',
        RegExp(r'^\s*test\('),
        'Repository : réseau d’abord, cache Isar en secours, erreurs HTTP',
      ),
      const Block(
        'test/features/movies/movie_repository_impl_test.dart',
        "test('sans réseau : sert le cache sans appeler TMDB'",
        '    });',
        'Exemple : hors ligne, le cache est servi sans appel réseau',
      ),
      Pick(
        'test/features/auth/auth_validators_test.dart',
        RegExp(r"^\s*test\('"),
        'Logique métier : validation et robustesse du mot de passe',
      ),
      Pick(
        'test/features/movies/movie_search_controller_test.dart',
        RegExp(r'^\s*test\('),
        'Provider (Notifier) : anti-rebond et réponses périmées',
      ),
      Pick(
        'test/core/locale_providers_test.dart',
        RegExp(r'^\s*test\('),
        'Providers de langue et intercepteur TMDB',
      ),
    ],
  ),
  Requirement(
    'Au moins 5 tests de widgets',
    '**${counts.widget} tests de widgets** (`testWidgets(`) dans `test/`. '
        'Extraits : écrans, changement de langue, accessibilité, '
        'reconstructions.',
    [
      Pick(
        'test/features/home/home_page_test.dart',
        RegExp(r'^\s*testWidgets\('),
        'Accueil : en ligne, hors ligne, erreur',
      ),
      Pick(
        'test/features/movies/search_page_test.dart',
        RegExp(r'^\s*testWidgets\('),
        'Recherche : résultats, aucun résultat, hors ligne',
      ),
      Pick(
        'test/l10n/language_switch_test.dart',
        RegExp(r'^\s*testWidgets\('),
        'Changement de langue en direct',
      ),
      const Block(
        'test/l10n/language_switch_test.dart',
        '// Appareil en français',
        "expect(prefs.getString(LocaleController.storageKey), 'en');",
        'Exemple : l’interface passe en anglais et le choix est mémorisé',
      ),
    ],
  ),
  Requirement(
    'Au moins 2 tests d’intégration',
    '**${counts.integration} tests d’intégration** sur l’application complète '
        '(routeur, thème, traductions) avec un backend en mémoire : 2 parcours '
        'utilisateur et 1 mesure de performance. Exécutés en CI sur un bureau '
        'Linux.',
    [
      Pick(
        'integration_test/app_journeys_test.dart',
        RegExp(r'^\s*testWidgets\(|^\s*IntegrationTestWidgetsFlutterBinding'),
        'Point d’entrée : binding d’intégration et parcours',
      ),
      const Block(
        'integration_test/support/journeys.dart',
        '// 2. Bon mot de passe',
        'expect(backend.favorites.items, hasLength(1));',
        'Parcours 1 : connexion → fiche du n°1 → ajout aux favoris',
      ),
      const Block(
        'integration_test/support/fake_backend.dart',
        'await tester.pumpWidget(',
        'child: const CinethequeApp(),',
        'L’application réelle, avec les dépôts remplacés par des faux',
      ),
      Pick(
        '.github/workflows/ci.yml',
        RegExp(r'app_journeys_test|scroll_performance_test'),
        'Exécution en CI',
      ),
    ],
  ),
  const Requirement(
    'Performance : aucun jank visible (60 fps constant)',
    'Le défilement de l’accueil et d’une grille de 60 affiches est mesuré en '
        '**mode profile** dans la CI (`watchPerformance`). Le test échoue si le '
        '90ᵉ centile de construction dépasse 16 ms ou si plus de 5 % des '
        'images sortent du budget. Dernière mesure : **p90 4,55 ms, 0 image '
        'hors budget sur 350** (voir [§ 5](#5-performance)).',
    [
      Block(
        'integration_test/scroll_performance_test.dart',
        'binding.framePolicy',
        'expect(missed / frames, lessThan(0.05));',
        'Mesure et seuils du 60 fps',
      ),
      Block(
        'integration_test/support/journeys.dart',
        'Future<void> scrollCatalog(',
        'await tester.fling(grid, const Offset(0, 2700), 4000);',
        'Scénario de défilement mesuré',
      ),
    ],
  ),
  Requirement(
    'Performance : images optimisées et lazy-loadées',
    'Chaque image est téléchargée dans la plus petite taille TMDB qui couvre '
        'l’affichage et décodée à sa taille réelle à l’écran '
        '(`memCacheWidth`), puis mise en cache sur disque. Toutes les listes '
        'sont construites à la demande (`builder`).',
    [
      const Block(
        'lib/core/network/api_constants.dart',
        'static String posterSizeFor(',
        '  };',
        'Taille d’affiche TMDB selon les pixels affichés',
      ),
      const Block(
        'lib/shared/extensions/image_x.dart',
        'extension ImageDecodeX',
        '}',
        'Largeur de décodage = largeur affichée × densité',
      ),
      const Block(
        'lib/shared/widgets/poster_card.dart',
        ': LayoutBuilder(',
        'memCacheWidth: pixels,',
        'Affiche : taille adaptée, décodage réduit, cache disque',
      ),
      Pick(
        'lib/shared/widgets/poster_grid.dart',
        RegExp(r'SliverGrid\.builder'),
        'Grilles construites à la demande',
      ),
      const Block(
        'lib/features/movies/presentation/pages/movie_details_page.dart',
        '// Construit à la demande',
        'itemCount: cast.length + 1,',
        'Casting complet : portraits chargés quand ils deviennent visibles',
      ),
    ],
  ),
  Requirement(
    'Performance : pas de rebuilds inutiles (flutter_hooks ou const)',
    '**flutter_hooks** (via `hooks_riverpod`) pour tout l’état local, '
        '`select` et égalité par valeur pour ignorer les recalculs sans '
        'changement, widgets `const` imposés par le lint. Les reconstructions '
        'sont **mesurées par des tests** : la frappe ne reconstruit plus les '
        'écrans (3 → 0 et 1 → 0).',
    [
      const Block(
        'lib/features/auth/presentation/pages/register_page.dart',
        'class _LivePasswordStrength extends HookWidget',
        '  }',
        'Hook : seule la jauge écoute le champ mot de passe',
      ),
      Pick(
        'pubspec.yaml',
        RegExp(r'^\s*(flutter_hooks|hooks_riverpod):'),
        'Dépendances',
      ),
      const Block(
        'lib/features/home/presentation/pages/home_page.dart',
        'final firstName = ref.watch(',
        ');',
        '`select` : le rafraîchissement du JWT ne reconstruit pas l’accueil',
      ),
      const Block(
        'lib/shared/widgets/skeleton.dart',
        'final controller = useAnimationController(',
        'opacity: controller,',
        'Squelette animé sans aucun build (FadeTransition + RepaintBoundary)',
      ),
      Pick(
        'analysis_options.yaml',
        RegExp(
          r'prefer_const|unnecessary_const|use_colored_box|use_decorated_box',
        ),
        'Lints `const` et widgets légers',
      ),
      const Block(
        'test/performance/rebuilds_test.dart',
        'final counter = RebuildCounter();',
        'expect(counter.of(RegisterPage), 0);',
        'Test : la frappe ne reconstruit pas l’écran d’inscription',
      ),
    ],
  ),
  Requirement(
    'Accessibilité : semantic labels sur les éléments interactifs',
    'Chaque élément interactif a un libellé explicite (affiches, cartes, '
        'casting annoncés comme boutons avec un résumé), les titres sont des '
        'en-têtes, la bannière hors ligne est une zone live, les cibles '
        'tactiles font au moins 48 dp. Vérifié par les règles Flutter sur 6 '
        'écrans et par des tests de libellés FR/EN.',
    [
      const Block(
        'lib/shared/widgets/poster_card.dart',
        'return Semantics(',
        'semanticLabel ?? context.l10n.movieSummary(title, rating: rating),',
        'Affiche : bouton au libellé « Titre, note 8,2 sur 10 »',
      ),
      const Block(
        'lib/features/home/presentation/widgets/featured_movie_card.dart',
        'return Semantics(',
        '      ),\n      child: Padding(',
        'Carte à la une : une seule annonce complète',
        maxLines: 14,
      ),
      const Block(
        'lib/shared/widgets/offline_banner.dart',
        'return Semantics(',
        'liveRegion: true,',
        'Bannière hors ligne annoncée dès qu’elle apparaît',
      ),
      const Block(
        'lib/features/movies/presentation/pages/movie_details_page.dart',
        'MergeSemantics(',
        'toggled: isFavorite,',
        'État du favori (activé / désactivé)',
      ),
      Pick(
        'test/a11y/accessibility_guidelines_test.dart',
        RegExp(r'meetsGuideline'),
        'Règles Flutter vérifiées sur 6 écrans',
      ),
      Pick(
        'test/a11y/semantic_labels_test.dart',
        RegExp(r"find\.bySemanticsLabel\(\s*'|^\s*'N°1"),
        'Libellés exacts attendus',
      ),
    ],
  ),
  Requirement(
    'Internationalisation : support FR + EN minimum',
    'Traductions ARB générées par `flutter gen-l10n` (**${counts.arbKeys} '
        'textes**), pluriels et accords en ICU, formats de nombres et de dates '
        'selon la langue. Langue de l’appareil par défaut, choix persistant '
        'dans le Profil ; les contenus TMDB suivent la langue.',
    [
      const Block(
        'l10n.yaml',
        'arb-dir:',
        'nullable-getter: false',
        'Configuration',
      ),
      Pick(
        'lib/l10n/app_fr.arb',
        RegExp(r'"(searchResultCount|actorBorn|favoriteAdd)"'),
        'Français (modèle) : pluriel, accord en genre',
      ),
      Pick(
        'lib/l10n/app_en.arb',
        RegExp(r'"(searchResultCount|actorBorn|favoriteAdd)"'),
        'Anglais',
      ),
      Pick(
        'lib/app/app.dart',
        RegExp(r'locale:|supportedLocales:|localizationsDelegates:'),
        'Branchement dans MaterialApp',
      ),
      const Block(
        'lib/core/l10n/locale_providers.dart',
        'Locale resolveAppLocale(',
        '  return supportedAppLocales.first;',
        'Résolution de la langue (choix → appareil → anglais)',
      ),
      const Block(
        'lib/shared/extensions/l10n_x.dart',
        'String failureMessage(Failure failure)',
        '  };',
        'Le domaine n’a pas de texte : chaque erreur est traduite ici',
      ),
    ],
  ),
  Requirement(
    'CI/CD configuré (GitHub Actions) avec lint + tests automatiques',
    'Trois jobs à chaque push, pull request et tag : **qualité** (format, '
        'traductions à jour, analyse, tests avec couverture), **intégration** '
        '(parcours et performance sur bureau Linux), **APK** (release GitHub '
        'sur les tags `v*`).',
    [
      const Block(
        '.github/workflows/ci.yml',
        'on:',
        'workflow_dispatch:',
        'Déclencheurs : push, pull request, tags de version',
      ),
      Pick(
        '.github/workflows/ci.yml',
        RegExp(
          r'^  (quality|integration|android):$|^    name: |^      - name: ',
        ),
        'Les 3 jobs et leurs étapes',
      ),
    ],
  ),
  Requirement(
    'Analyse statique sans warnings (`flutter analyze` propre)',
    '`flutter analyze --fatal-infos --fatal-warnings` en CI : la moindre '
        'remarque fait échouer le build. Base `flutter_lints`, mode strict du '
        'typage et règles supplémentaires.',
    [
      const Block(
        'analysis_options.yaml',
        'language:',
        'strict-raw-types: true',
        'Typage strict',
      ),
      const Block(
        'analysis_options.yaml',
        'linter:',
        'require_trailing_commas',
        'Règles ajoutées',
      ),
      Pick(
        '.github/workflows/ci.yml',
        RegExp(r'flutter analyze'),
        'Échec de la CI au moindre avertissement',
      ),
    ],
  ),
  Requirement(
    'README professionnel : architecture, setup, captures d’écran, badges CI',
    'Ce document : badges (CI, tests, couverture, langues, APK), captures, '
        '[architecture](#3-architecture), [installation](#10-installation), '
        '[commandes](#11-commandes). Les captures sont générées depuis '
        'l’application (`tool/screenshots`) et cette section par '
        '`tool/readme_refs.dart`, vérifiée par la CI.',
    [
      Pick(
        'tool/screenshots/screenshots_test.dart',
        RegExp(r"capture\(tester, '"),
        'Génération des captures d’écran',
      ),
      Pick(
        '.github/workflows/ci.yml',
        RegExp(r'readme_refs'),
        'La CI vérifie que les références du README sont à jour',
      ),
    ],
  ),
  Requirement(
    'CHANGELOG.md avec au moins 3 versions documentées',
    '3 versions au format *Keep a Changelog*, chacune taguée dans git '
        '(`v1.0.0`, `v1.1.0`, `v2.0.0`).',
    [Pick('CHANGELOG.md', RegExp(r'^## \['), 'Versions documentées')],
  ),
  Requirement(
    'Livraison : repo GitHub public avec CI verte, README complet et APK de '
        'démonstration',
    'Repo public, CI verte, **APK construit par la CI et attaché à la '
        '[release v2.0.0]($_repo/releases/tag/v2.0.0)**. Les clés de l’app '
        'viennent des secrets du dépôt, jamais du code.',
    [
      const Block(
        '.github/workflows/ci.yml',
        '- name: Build APK release',
        'generate_release_notes: true',
        'Build de l’APK et publication de la release',
      ),
      Pick(
        'android/app/src/main/AndroidManifest.xml',
        RegExp(r'uses-permission'),
        'Permissions réseau de la version release',
      ),
      const Block(
        'android/app/build.gradle.kts',
        'signingConfigs {',
        'if (hasReleaseKeystore) "release" else "debug",',
        'Signature de release (keystore fourni par la CI)',
      ),
    ],
  ),
];

const _pages = [
  'lib/features/auth/presentation/pages/splash_page.dart',
  'lib/features/auth/presentation/pages/login_page.dart',
  'lib/features/auth/presentation/pages/register_page.dart',
  'lib/features/home/presentation/pages/home_page.dart',
  'lib/features/movies/presentation/pages/movie_list_page.dart',
  'lib/features/movies/presentation/pages/search_page.dart',
  'lib/features/movies/presentation/pages/movie_details_page.dart',
  'lib/features/actors/presentation/pages/actor_details_page.dart',
  'lib/features/favorites/presentation/pages/favorites_page.dart',
  'lib/features/profile/presentation/pages/profile_page.dart',
];

// ─── Modèle ─────────────────────────────────────────────────────────────────

class Requirement {
  const Requirement(this.title, this.summary, this.refs);
  final String title;
  final String summary;
  final List<Ref> refs;
}

sealed class Ref {
  const Ref(this.path, this.description);
  final String path;
  final String description;

  /// Lignes retenues (numéros à partir de 1).
  List<int> resolve(List<String> lines);
}

/// Bloc continu : de la ligne contenant [start] à la ligne contenant [end]
/// (qui peut s'étendre sur plusieurs lignes, séparées par `\n`).
class Block extends Ref {
  const Block(
    super.path,
    this.start,
    this.end,
    super.description, {
    this.maxLines = 40,
  });

  final String start;
  final String end;
  final int maxLines;

  @override
  List<int> resolve(List<String> lines) {
    final from = lines.indexWhere((l) => l.contains(start));
    if (from < 0) throw StateError('« $start » introuvable dans $path');
    final endParts = end.split('\n');
    for (var i = from; i < lines.length; i++) {
      final matches = [
        for (var k = 0; k < endParts.length; k++)
          i + k < lines.length && _endMatches(lines[i + k], endParts[k]),
      ].every((ok) => ok);
      if (matches) {
        final to = i + endParts.length - 1;
        final last = (to - from + 1 > maxLines) ? from + maxLines - 1 : to;
        return [for (var n = from; n <= last; n++) n + 1];
      }
    }
    throw StateError('Fin « $end » introuvable dans $path après « $start »');
  }
}

/// Fin de bloc : une fin indentée (« `  }` ») doit correspondre à la ligne
/// exacte, sinon la première accolade venue terminerait le bloc.
bool _endMatches(String line, String end) =>
    end.startsWith(' ') ? line.trimRight() == end : line.contains(end.trim());

/// Lignes isolées correspondant à [pattern].
class Pick extends Ref {
  const Pick(super.path, this.pattern, super.description);

  final RegExp pattern;

  @override
  List<int> resolve(List<String> lines) {
    final picked = [
      for (var i = 0; i < lines.length; i++)
        if (pattern.hasMatch(lines[i])) i + 1,
    ];
    if (picked.isEmpty) {
      throw StateError('Aucune ligne « $pattern » dans $path');
    }
    return picked;
  }
}

class TestCounts {
  TestCounts()
    : unit = _count('test', RegExp(r'^\s*test\(')),
      widget = _count('test', RegExp(r'^\s*testWidgets\(')),
      integration = _count('integration_test', RegExp(r'^\s*testWidgets\(')),
      arbKeys = LineSplitter.split(
        File('lib/l10n/app_fr.arb').readAsStringSync(),
      ).where((l) => RegExp(r'^\s*"[a-zA-Z0-9]+":').hasMatch(l)).length;

  final int unit;
  final int widget;
  final int integration;
  final int arbKeys;

  static int _count(String dir, RegExp pattern) =>
      Directory(dir)
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('_test.dart'))
          .expand((f) => f.readAsLinesSync())
          .where(pattern.hasMatch)
          .length;
}

// ─── Rendu ──────────────────────────────────────────────────────────────────

const _summaryBegin = '<!-- REFS:SUMMARY:START -->';
const _summaryEnd = '<!-- REFS:SUMMARY:END -->';
const _generated =
    '<!-- Généré par `dart run tool/readme_refs.dart` : ne pas modifier à la '
    'main. -->';

typedef _Resolved = (Ref ref, List<String> lines, List<int> numbers);

List<_Resolved> _resolve(Requirement r) => [
  for (final ref in r.refs)
    (ref, _lines(ref.path), ref.resolve(_lines(ref.path))),
];

/// Tableau récapitulatif (§ 1) : une ligne par exigence, preuve principale.
String renderSummary(List<Requirement> reqs) {
  final out = StringBuffer()
    ..writeln(_summaryBegin)
    ..writeln(_generated)
    ..writeln()
    ..writeln('| # | Exigence du projet | Preuve principale | Détail |')
    ..writeln('|---:|---|---|:---:|');
  for (final (i, r) in reqs.indexed) {
    final (ref, _, numbers) = _resolve(r).first;
    out.writeln(
      '| ${i + 1} | ${r.title} | '
      '[`${ref.path.split('/').last}` ${_shortRange(numbers)}]'
      '(${_link(ref.path, numbers)}) | [✅ voir](#${_anchor(i, r)}) |',
    );
  }
  return (out..write(_summaryEnd)).toString();
}

/// Annexe : chaque exigence en titre, puis fichiers, lignes et code.
String renderAnnex(List<Requirement> reqs) {
  final out = StringBuffer()
    ..writeln(_begin)
    ..writeln(_generated)
    ..writeln();
  for (final (i, r) in reqs.indexed) {
    final resolved = _resolve(r);
    out
      ..writeln('### ${_heading(i, r)}')
      ..writeln()
      ..writeln(r.summary)
      ..writeln()
      ..writeln('| Fichier | Lignes | Rôle |')
      ..writeln('|---|---|---|');
    for (final (ref, lines, numbers) in resolved) {
      // Référence d'une seule ligne : le code tient dans le tableau.
      final inline = numbers.length == 1
          ? ' — `${lines[numbers.first - 1].trim().replaceAll('|', r'\|')}`'
          : '';
      out.writeln(
        '| [`${ref.path}`](${_link(ref.path, numbers)}) | '
        '${_range(numbers)} | ${ref.description}$inline |',
      );
    }
    out.writeln();
    for (final (ref, lines, numbers) in resolved) {
      if (numbers.length == 1) continue;
      out
        ..writeln(
          '**[`${ref.path}`](${_link(ref.path, numbers)})** · '
          '${_range(numbers)} — ${ref.description}',
        )
        ..writeln()
        ..writeln('```${_language(ref.path)}')
        ..write(_excerpt(lines, numbers, contiguous: ref is Block))
        ..writeln('```')
        ..writeln();
    }
  }
  return (out..write(_end)).toString();
}

final _cache = <String, List<String>>{};
List<String> _lines(String path) =>
    _cache[path] ??= LineSplitter.split(File(path).readAsStringSync()).toList();

String _heading(int i, Requirement r) => 'A${i + 1}. ${r.title}';

/// Ancre GitHub d'un titre : minuscules, sans ponctuation, espaces → tirets.
String _anchor(int i, Requirement r) => _heading(i, r)
    .toLowerCase()
    .replaceAll(RegExp(r'[^\p{L}\p{N} _-]', unicode: true), '')
    .replaceAll(' ', '-');

/// Version courte pour le récapitulatif : « L54 … L136 (10 lignes) ».
String _shortRange(List<int> n) =>
    n.length > 3 && n.last - n.first + 1 != n.length
    ? 'L${n.first} … L${n.last} (${n.length} lignes)'
    : _range(n);

String _range(List<int> n) {
  if (n.length == 1) return 'L${n.first}';
  final contiguous = n.last - n.first + 1 == n.length;
  return contiguous ? 'L${n.first}–${n.last}' : n.map((x) => 'L$x').join(', ');
}

String _link(String path, List<int> n) {
  // Les fichiers Markdown s'affichent rendus : ?plain=1 pour cibler les lignes.
  final plain = path.endsWith('.md') ? '?plain=1' : '';
  final anchor = n.length == 1 || n.last - n.first + 1 != n.length
      ? '#L${n.first}'
      : '#L${n.first}-L${n.last}';
  return '$path$plain$anchor';
}

String _language(String path) => switch (path.split('.').last) {
  'dart' => 'dart',
  'yaml' || 'yml' => 'yaml',
  'arb' => 'json',
  'kts' => 'kotlin',
  'xml' => 'xml',
  'md' => 'markdown',
  _ => 'text',
};

/// Code numéroté, indentation commune retirée ; « ⋮ » entre lignes éloignées.
String _excerpt(
  List<String> lines,
  List<int> numbers, {
  required bool contiguous,
}) {
  final text = [for (final n in numbers) lines[n - 1]];
  final indent =
      text
          .where((l) => l.trim().isNotEmpty)
          .map((l) => l.length - l.trimLeft().length)
          .fold<int?>(null, (m, x) => m == null || x < m ? x : m) ??
      0;
  final width = '${numbers.last}'.length;
  final out = StringBuffer();
  for (final (k, n) in numbers.indexed) {
    if (!contiguous && k > 0 && n != numbers[k - 1] + 1) {
      out.writeln('${' ' * width}  ⋮');
    }
    final line = lines[n - 1];
    final body = line.length >= indent
        ? line.substring(indent)
        : line.trimLeft();
    out.writeln('${'$n'.padLeft(width)}  $body'.trimRight());
  }
  return out.toString();
}

/// Remplace le contenu entre [begin] et [end] (marqueurs inclus).
String _replace(String text, String begin, String end, String block) {
  final start = text.indexOf(begin);
  final stop = text.indexOf(end);
  if (start < 0 || stop < start) {
    stderr.writeln('Marqueurs $begin / $end absents de $_readme.');
    exit(2);
  }
  return text.substring(0, start) + block + text.substring(stop + end.length);
}

// ─── Point d'entrée ─────────────────────────────────────────────────────────

void main(List<String> args) {
  final readme = File(_readme).readAsStringSync();
  final reqs = requirements(TestCounts());
  final updated = _replace(
    _replace(readme, _summaryBegin, _summaryEnd, renderSummary(reqs)),
    _begin,
    _end,
    renderAnnex(reqs),
  );

  if (args.contains('--check')) {
    if (updated != readme) {
      stderr.writeln(
        '$_readme n’est pas à jour : lancez `dart run tool/readme_refs.dart`.',
      );
      exit(1);
    }
    stdout.writeln('$_readme : références à jour.');
    return;
  }
  File(_readme).writeAsStringSync(updated);
  stdout.writeln('$_readme mis à jour.');
}
