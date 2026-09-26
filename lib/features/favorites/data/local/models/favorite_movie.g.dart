// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_movie.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFavoriteMovieCollection on Isar {
  IsarCollection<FavoriteMovie> get favoriteMovies => this.collection();
}

const FavoriteMovieSchema = CollectionSchema(
  name: r'FavoriteMovie',
  id: 4711810972251588754,
  properties: {
    r'addedAt': PropertySchema(
      id: 0,
      name: r'addedAt',
      type: IsarType.dateTime,
    ),
    r'backdropPath': PropertySchema(
      id: 1,
      name: r'backdropPath',
      type: IsarType.string,
    ),
    r'genreNames': PropertySchema(
      id: 2,
      name: r'genreNames',
      type: IsarType.stringList,
    ),
    r'movieId': PropertySchema(id: 3, name: r'movieId', type: IsarType.long),
    r'originalTitle': PropertySchema(
      id: 4,
      name: r'originalTitle',
      type: IsarType.string,
    ),
    r'ownerId': PropertySchema(id: 5, name: r'ownerId', type: IsarType.string),
    r'posterPath': PropertySchema(
      id: 6,
      name: r'posterPath',
      type: IsarType.string,
    ),
    r'releaseDate': PropertySchema(
      id: 7,
      name: r'releaseDate',
      type: IsarType.string,
    ),
    r'title': PropertySchema(id: 8, name: r'title', type: IsarType.string),
    r'voteAverage': PropertySchema(
      id: 9,
      name: r'voteAverage',
      type: IsarType.double,
    ),
  },

  estimateSize: _favoriteMovieEstimateSize,
  serialize: _favoriteMovieSerialize,
  deserialize: _favoriteMovieDeserialize,
  deserializeProp: _favoriteMovieDeserializeProp,
  idName: r'id',
  indexes: {
    r'ownerId_movieId': IndexSchema(
      id: -1310939765976121133,
      name: r'ownerId_movieId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'ownerId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'movieId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'addedAt': IndexSchema(
      id: -8595779697745674092,
      name: r'addedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'addedAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _favoriteMovieGetId,
  getLinks: _favoriteMovieGetLinks,
  attach: _favoriteMovieAttach,
  version: '3.3.2',
);

int _favoriteMovieEstimateSize(
  FavoriteMovie object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.backdropPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.genreNames.length * 3;
  {
    for (var i = 0; i < object.genreNames.length; i++) {
      final value = object.genreNames[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.originalTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.ownerId.length * 3;
  {
    final value = object.posterPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.releaseDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _favoriteMovieSerialize(
  FavoriteMovie object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.addedAt);
  writer.writeString(offsets[1], object.backdropPath);
  writer.writeStringList(offsets[2], object.genreNames);
  writer.writeLong(offsets[3], object.movieId);
  writer.writeString(offsets[4], object.originalTitle);
  writer.writeString(offsets[5], object.ownerId);
  writer.writeString(offsets[6], object.posterPath);
  writer.writeString(offsets[7], object.releaseDate);
  writer.writeString(offsets[8], object.title);
  writer.writeDouble(offsets[9], object.voteAverage);
}

FavoriteMovie _favoriteMovieDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FavoriteMovie();
  object.addedAt = reader.readDateTime(offsets[0]);
  object.backdropPath = reader.readStringOrNull(offsets[1]);
  object.genreNames = reader.readStringList(offsets[2]) ?? [];
  object.id = id;
  object.movieId = reader.readLong(offsets[3]);
  object.originalTitle = reader.readStringOrNull(offsets[4]);
  object.ownerId = reader.readString(offsets[5]);
  object.posterPath = reader.readStringOrNull(offsets[6]);
  object.releaseDate = reader.readStringOrNull(offsets[7]);
  object.title = reader.readString(offsets[8]);
  object.voteAverage = reader.readDouble(offsets[9]);
  return object;
}

P _favoriteMovieDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _favoriteMovieGetId(FavoriteMovie object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _favoriteMovieGetLinks(FavoriteMovie object) {
  return [];
}

void _favoriteMovieAttach(
  IsarCollection<dynamic> col,
  Id id,
  FavoriteMovie object,
) {
  object.id = id;
}

extension FavoriteMovieByIndex on IsarCollection<FavoriteMovie> {
  Future<FavoriteMovie?> getByOwnerIdMovieId(String ownerId, int movieId) {
    return getByIndex(r'ownerId_movieId', [ownerId, movieId]);
  }

  FavoriteMovie? getByOwnerIdMovieIdSync(String ownerId, int movieId) {
    return getByIndexSync(r'ownerId_movieId', [ownerId, movieId]);
  }

  Future<bool> deleteByOwnerIdMovieId(String ownerId, int movieId) {
    return deleteByIndex(r'ownerId_movieId', [ownerId, movieId]);
  }

  bool deleteByOwnerIdMovieIdSync(String ownerId, int movieId) {
    return deleteByIndexSync(r'ownerId_movieId', [ownerId, movieId]);
  }

  Future<List<FavoriteMovie?>> getAllByOwnerIdMovieId(
    List<String> ownerIdValues,
    List<int> movieIdValues,
  ) {
    final len = ownerIdValues.length;
    assert(
      movieIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([ownerIdValues[i], movieIdValues[i]]);
    }

    return getAllByIndex(r'ownerId_movieId', values);
  }

  List<FavoriteMovie?> getAllByOwnerIdMovieIdSync(
    List<String> ownerIdValues,
    List<int> movieIdValues,
  ) {
    final len = ownerIdValues.length;
    assert(
      movieIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([ownerIdValues[i], movieIdValues[i]]);
    }

    return getAllByIndexSync(r'ownerId_movieId', values);
  }

  Future<int> deleteAllByOwnerIdMovieId(
    List<String> ownerIdValues,
    List<int> movieIdValues,
  ) {
    final len = ownerIdValues.length;
    assert(
      movieIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([ownerIdValues[i], movieIdValues[i]]);
    }

    return deleteAllByIndex(r'ownerId_movieId', values);
  }

  int deleteAllByOwnerIdMovieIdSync(
    List<String> ownerIdValues,
    List<int> movieIdValues,
  ) {
    final len = ownerIdValues.length;
    assert(
      movieIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([ownerIdValues[i], movieIdValues[i]]);
    }

    return deleteAllByIndexSync(r'ownerId_movieId', values);
  }

  Future<Id> putByOwnerIdMovieId(FavoriteMovie object) {
    return putByIndex(r'ownerId_movieId', object);
  }

  Id putByOwnerIdMovieIdSync(FavoriteMovie object, {bool saveLinks = true}) {
    return putByIndexSync(r'ownerId_movieId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByOwnerIdMovieId(List<FavoriteMovie> objects) {
    return putAllByIndex(r'ownerId_movieId', objects);
  }

  List<Id> putAllByOwnerIdMovieIdSync(
    List<FavoriteMovie> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'ownerId_movieId', objects, saveLinks: saveLinks);
  }
}

extension FavoriteMovieQueryWhereSort
    on QueryBuilder<FavoriteMovie, FavoriteMovie, QWhere> {
  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhere> anyAddedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'addedAt'),
      );
    });
  }
}

extension FavoriteMovieQueryWhere
    on QueryBuilder<FavoriteMovie, FavoriteMovie, QWhereClause> {
  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause>
  ownerIdEqualToAnyMovieId(String ownerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'ownerId_movieId',
          value: [ownerId],
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause>
  ownerIdNotEqualToAnyMovieId(String ownerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerId_movieId',
                lower: [],
                upper: [ownerId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerId_movieId',
                lower: [ownerId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerId_movieId',
                lower: [ownerId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerId_movieId',
                lower: [],
                upper: [ownerId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause>
  ownerIdMovieIdEqualTo(String ownerId, int movieId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'ownerId_movieId',
          value: [ownerId, movieId],
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause>
  ownerIdEqualToMovieIdNotEqualTo(String ownerId, int movieId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerId_movieId',
                lower: [ownerId],
                upper: [ownerId, movieId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerId_movieId',
                lower: [ownerId, movieId],
                includeLower: false,
                upper: [ownerId],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerId_movieId',
                lower: [ownerId, movieId],
                includeLower: false,
                upper: [ownerId],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerId_movieId',
                lower: [ownerId],
                upper: [ownerId, movieId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause>
  ownerIdEqualToMovieIdGreaterThan(
    String ownerId,
    int movieId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'ownerId_movieId',
          lower: [ownerId, movieId],
          includeLower: include,
          upper: [ownerId],
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause>
  ownerIdEqualToMovieIdLessThan(
    String ownerId,
    int movieId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'ownerId_movieId',
          lower: [ownerId],
          upper: [ownerId, movieId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause>
  ownerIdEqualToMovieIdBetween(
    String ownerId,
    int lowerMovieId,
    int upperMovieId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'ownerId_movieId',
          lower: [ownerId, lowerMovieId],
          includeLower: includeLower,
          upper: [ownerId, upperMovieId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause> addedAtEqualTo(
    DateTime addedAt,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'addedAt', value: [addedAt]),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause>
  addedAtNotEqualTo(DateTime addedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'addedAt',
                lower: [],
                upper: [addedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'addedAt',
                lower: [addedAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'addedAt',
                lower: [addedAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'addedAt',
                lower: [],
                upper: [addedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause>
  addedAtGreaterThan(DateTime addedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'addedAt',
          lower: [addedAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause> addedAtLessThan(
    DateTime addedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'addedAt',
          lower: [],
          upper: [addedAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterWhereClause> addedAtBetween(
    DateTime lowerAddedAt,
    DateTime upperAddedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'addedAt',
          lower: [lowerAddedAt],
          includeLower: includeLower,
          upper: [upperAddedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension FavoriteMovieQueryFilter
    on QueryBuilder<FavoriteMovie, FavoriteMovie, QFilterCondition> {
  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  addedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'addedAt', value: value),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  addedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'addedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  addedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'addedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  addedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'addedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  backdropPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'backdropPath'),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  backdropPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'backdropPath'),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  backdropPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'backdropPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  backdropPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backdropPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  backdropPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backdropPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  backdropPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backdropPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  backdropPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'backdropPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  backdropPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'backdropPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  backdropPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'backdropPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  backdropPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'backdropPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  backdropPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backdropPath', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  backdropPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'backdropPath', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'genreNames',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'genreNames',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'genreNames',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'genreNames',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'genreNames',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'genreNames',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'genreNames',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'genreNames',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'genreNames', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'genreNames', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genreNames', length, true, length, true);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genreNames', 0, true, 0, true);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genreNames', 0, false, 999999, true);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genreNames', 0, true, length, include);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genreNames', length, include, 999999, true);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  genreNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genreNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  movieIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'movieId', value: value),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  movieIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'movieId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  movieIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'movieId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  movieIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'movieId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  originalTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'originalTitle'),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  originalTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'originalTitle'),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  originalTitleEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'originalTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  originalTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'originalTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  originalTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'originalTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  originalTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'originalTitle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  originalTitleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'originalTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  originalTitleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'originalTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  originalTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'originalTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  originalTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'originalTitle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  originalTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'originalTitle', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  originalTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'originalTitle', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  ownerIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'ownerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  ownerIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ownerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  ownerIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ownerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  ownerIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ownerId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  ownerIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'ownerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  ownerIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'ownerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  ownerIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'ownerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  ownerIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'ownerId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  ownerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ownerId', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  ownerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'ownerId', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  posterPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'posterPath'),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  posterPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'posterPath'),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  posterPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'posterPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  posterPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'posterPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  posterPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'posterPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  posterPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'posterPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  posterPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'posterPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  posterPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'posterPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  posterPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'posterPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  posterPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'posterPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  posterPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'posterPath', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  posterPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'posterPath', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  releaseDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'releaseDate'),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  releaseDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'releaseDate'),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  releaseDateEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'releaseDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  releaseDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'releaseDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  releaseDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'releaseDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  releaseDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'releaseDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  releaseDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'releaseDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  releaseDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'releaseDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  releaseDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'releaseDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  releaseDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'releaseDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  releaseDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'releaseDate', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  releaseDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'releaseDate', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  titleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  voteAverageEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'voteAverage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  voteAverageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'voteAverage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  voteAverageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'voteAverage',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterFilterCondition>
  voteAverageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'voteAverage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension FavoriteMovieQueryObject
    on QueryBuilder<FavoriteMovie, FavoriteMovie, QFilterCondition> {}

extension FavoriteMovieQueryLinks
    on QueryBuilder<FavoriteMovie, FavoriteMovie, QFilterCondition> {}

extension FavoriteMovieQuerySortBy
    on QueryBuilder<FavoriteMovie, FavoriteMovie, QSortBy> {
  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> sortByAddedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> sortByAddedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy>
  sortByBackdropPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy>
  sortByBackdropPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> sortByMovieId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> sortByMovieIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy>
  sortByOriginalTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalTitle', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy>
  sortByOriginalTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalTitle', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> sortByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> sortByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> sortByPosterPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy>
  sortByPosterPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> sortByReleaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy>
  sortByReleaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> sortByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy>
  sortByVoteAverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.desc);
    });
  }
}

extension FavoriteMovieQuerySortThenBy
    on QueryBuilder<FavoriteMovie, FavoriteMovie, QSortThenBy> {
  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> thenByAddedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> thenByAddedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addedAt', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy>
  thenByBackdropPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy>
  thenByBackdropPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backdropPath', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> thenByMovieId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> thenByMovieIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movieId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy>
  thenByOriginalTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalTitle', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy>
  thenByOriginalTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalTitle', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> thenByOwnerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> thenByOwnerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerId', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> thenByPosterPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy>
  thenByPosterPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posterPath', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> thenByReleaseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy>
  thenByReleaseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'releaseDate', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> thenByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.asc);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy>
  thenByVoteAverageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voteAverage', Sort.desc);
    });
  }
}

extension FavoriteMovieQueryWhereDistinct
    on QueryBuilder<FavoriteMovie, FavoriteMovie, QDistinct> {
  QueryBuilder<FavoriteMovie, FavoriteMovie, QDistinct> distinctByAddedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'addedAt');
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QDistinct> distinctByBackdropPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backdropPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QDistinct> distinctByGenreNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genreNames');
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QDistinct> distinctByMovieId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movieId');
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QDistinct>
  distinctByOriginalTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'originalTitle',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QDistinct> distinctByOwnerId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QDistinct> distinctByPosterPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posterPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QDistinct> distinctByReleaseDate({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'releaseDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteMovie, FavoriteMovie, QDistinct>
  distinctByVoteAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voteAverage');
    });
  }
}

extension FavoriteMovieQueryProperty
    on QueryBuilder<FavoriteMovie, FavoriteMovie, QQueryProperty> {
  QueryBuilder<FavoriteMovie, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FavoriteMovie, DateTime, QQueryOperations> addedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'addedAt');
    });
  }

  QueryBuilder<FavoriteMovie, String?, QQueryOperations>
  backdropPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backdropPath');
    });
  }

  QueryBuilder<FavoriteMovie, List<String>, QQueryOperations>
  genreNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genreNames');
    });
  }

  QueryBuilder<FavoriteMovie, int, QQueryOperations> movieIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movieId');
    });
  }

  QueryBuilder<FavoriteMovie, String?, QQueryOperations>
  originalTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalTitle');
    });
  }

  QueryBuilder<FavoriteMovie, String, QQueryOperations> ownerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerId');
    });
  }

  QueryBuilder<FavoriteMovie, String?, QQueryOperations> posterPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posterPath');
    });
  }

  QueryBuilder<FavoriteMovie, String?, QQueryOperations> releaseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'releaseDate');
    });
  }

  QueryBuilder<FavoriteMovie, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<FavoriteMovie, double, QQueryOperations> voteAverageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voteAverage');
    });
  }
}
