import 'package:equatable/equatable.dart';

/// Film tel qu'affiché dans les listes (carrousels, recherche, favoris…).
class Movie extends Equatable {
  const Movie({
    required this.id,
    required this.title,
    this.originalTitle,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage = 0,
    this.voteCount = 0,
    this.popularity = 0,
    this.genreIds = const [],
  });

  final int id;
  final String title;
  final String? originalTitle;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? releaseDate;

  /// Note moyenne sur 10.
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final List<int> genreIds;

  int? get year => releaseDate?.year;

  /// Un film sans vote n'a pas de note pertinente à afficher.
  bool get hasRating => voteCount > 0 && voteAverage > 0;

  @override
  List<Object?> get props => [
    id,
    title,
    originalTitle,
    overview,
    posterPath,
    backdropPath,
    releaseDate,
    voteAverage,
    voteCount,
    popularity,
    genreIds,
  ];
}
