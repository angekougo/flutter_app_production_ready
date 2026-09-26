import 'package:equatable/equatable.dart';

enum ActorGender { female, male, unknown }

/// Fiche d'un acteur (ou d'un membre de l'équipe) et sa filmographie.
class ActorDetails extends Equatable {
  const ActorDetails({
    required this.id,
    required this.name,
    this.biography,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    this.profilePath,
    this.knownForDepartment,
    this.gender = ActorGender.unknown,
    this.credits = const [],
  });

  final int id;
  final String name;
  final String? biography;
  final DateTime? birthday;
  final DateTime? deathday;
  final String? placeOfBirth;
  final String? profilePath;

  /// Département TMDB (« Acting », « Directing »…).
  final String? knownForDepartment;
  final ActorGender gender;

  /// Filmographie, du plus récent au plus ancien, sans doublon.
  final List<ActorCredit> credits;

  @override
  List<Object?> get props => [
    id,
    name,
    biography,
    birthday,
    deathday,
    placeOfBirth,
    profilePath,
    knownForDepartment,
    gender,
    credits,
  ];
}

/// Participation à un film : rôle joué (ou poste occupé).
class ActorCredit extends Equatable {
  const ActorCredit({
    required this.movieId,
    required this.title,
    this.role,
    this.releaseDate,
    this.posterPath,
    this.voteAverage = 0,
  });

  final int movieId;
  final String title;

  /// Personnage, ou poste pour l'équipe technique (« Réalisateur »…).
  final String? role;
  final DateTime? releaseDate;
  final String? posterPath;
  final double voteAverage;

  int? get year => releaseDate?.year;

  @override
  List<Object?> get props => [
    movieId,
    title,
    role,
    releaseDate,
    posterPath,
    voteAverage,
  ];
}
