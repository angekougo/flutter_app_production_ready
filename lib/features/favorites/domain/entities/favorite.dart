import 'package:equatable/equatable.dart';

import '../../../movies/domain/entities/movie.dart';

/// Film enregistré dans les favoris de l'utilisateur. Autonome : il porte
/// tout ce qu'il faut pour être affiché hors ligne.
class Favorite extends Equatable {
  const Favorite({
    required this.movieId,
    required this.title,
    required this.addedAt,
    this.originalTitle,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage = 0,
    this.genres = const [],
  });

  factory Favorite.fromMovie(
    Movie movie, {
    List<String> genres = const [],
    DateTime? addedAt,
  }) => Favorite(
    movieId: movie.id,
    title: movie.title,
    originalTitle: movie.originalTitle,
    posterPath: movie.posterPath,
    backdropPath: movie.backdropPath,
    releaseDate: movie.releaseDate,
    voteAverage: movie.voteAverage,
    genres: genres,
    addedAt: addedAt ?? DateTime.now(),
  );

  final int movieId;
  final String title;
  final String? originalTitle;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? releaseDate;
  final double voteAverage;
  final List<String> genres;
  final DateTime addedAt;

  int? get year => releaseDate?.year;

  /// Aperçu pour ouvrir la fiche instantanément (même hors ligne).
  Movie toMovie() => Movie(
    id: movieId,
    title: title,
    originalTitle: originalTitle,
    posterPath: posterPath,
    backdropPath: backdropPath,
    releaseDate: releaseDate,
    voteAverage: voteAverage,
    voteCount: voteAverage > 0 ? 1 : 0,
  );

  @override
  List<Object?> get props => [
    movieId,
    title,
    originalTitle,
    posterPath,
    backdropPath,
    releaseDate,
    voteAverage,
    genres,
    addedAt,
  ];
}
