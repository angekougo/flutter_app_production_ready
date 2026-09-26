import '../../../domain/entities/genre.dart';
import '../../local/models/cached_genre.dart';

class GenreModel {
  const GenreModel({required this.id, required this.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      GenreModel(id: json['id'] as int, name: json['name'] as String);

  factory GenreModel.fromCached(CachedGenre cached) =>
      GenreModel(id: cached.id, name: cached.name);

  final int id;
  final String name;

  Genre toEntity() => Genre(id: id, name: name);

  CachedGenre toCached() => CachedGenre()
    ..id = id
    ..name = name
    ..cachedAt = DateTime.now();
}
