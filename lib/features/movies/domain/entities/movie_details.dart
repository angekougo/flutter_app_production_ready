import 'package:equatable/equatable.dart';

import 'movie.dart';

/// Fiche complète d'un film : résumé + durée, genres, casting, similaires.
class MovieDetails extends Equatable {
  const MovieDetails({
    required this.movie,
    this.runtime,
    this.tagline,
    this.genres = const [],
    this.cast = const [],
    this.similar = const [],
  });

  final Movie movie;

  /// Durée en minutes.
  final int? runtime;
  final String? tagline;
  final List<String> genres;

  /// Acteurs principaux, dans l'ordre du générique.
  final List<CastMember> cast;
  final List<Movie> similar;

  @override
  List<Object?> get props => [movie, runtime, tagline, genres, cast, similar];
}

class CastMember extends Equatable {
  const CastMember({
    required this.id,
    required this.name,
    this.character,
    this.profilePath,
  });

  /// Id TMDB de la personne (fiche acteur).
  final int id;
  final String name;
  final String? character;
  final String? profilePath;

  /// Initiales pour l'avatar sans photo (« CS »).
  String get initials => initialsOf(name);

  @override
  List<Object?> get props => [id, name, character, profilePath];
}

/// « Camille Serre » → « CS » ; « Zendaya » → « Z ».
String initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  if (parts.isEmpty) return '?';
  final first = parts.first[0];
  final last = parts.length > 1 ? parts.last[0] : '';
  return (first + last).toUpperCase();
}
