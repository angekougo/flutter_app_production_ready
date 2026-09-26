// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_movie_details.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCachedMovieDetailsCollection on Isar {
  IsarCollection<CachedMovieDetails> get cachedMovieDetails =>
      this.collection();
}

const CachedMovieDetailsSchema = CollectionSchema(
  name: r'CachedMovieDetails',
  id: -1854604056396157070,
  properties: {
    r'cachedAt': PropertySchema(
      id: 0,
      name: r'cachedAt',
      type: IsarType.dateTime,
    ),
    r'cast': PropertySchema(
      id: 1,
      name: r'cast',
      type: IsarType.objectList,

      target: r'CachedCastMember',
    ),
    r'genreNames': PropertySchema(
      id: 2,
      name: r'genreNames',
      type: IsarType.stringList,
    ),
    r'runtime': PropertySchema(id: 3, name: r'runtime', type: IsarType.long),
    r'similarIds': PropertySchema(
      id: 4,
      name: r'similarIds',
      type: IsarType.longList,
    ),
    r'tagline': PropertySchema(id: 5, name: r'tagline', type: IsarType.string),
  },

  estimateSize: _cachedMovieDetailsEstimateSize,
  serialize: _cachedMovieDetailsSerialize,
  deserialize: _cachedMovieDetailsDeserialize,
  deserializeProp: _cachedMovieDetailsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'CachedCastMember': CachedCastMemberSchema},

  getId: _cachedMovieDetailsGetId,
  getLinks: _cachedMovieDetailsGetLinks,
  attach: _cachedMovieDetailsAttach,
  version: '3.3.2',
);

int _cachedMovieDetailsEstimateSize(
  CachedMovieDetails object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cast.length * 3;
  {
    final offsets = allOffsets[CachedCastMember]!;
    for (var i = 0; i < object.cast.length; i++) {
      final value = object.cast[i];
      bytesCount += CachedCastMemberSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  bytesCount += 3 + object.genreNames.length * 3;
  {
    for (var i = 0; i < object.genreNames.length; i++) {
      final value = object.genreNames[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.similarIds.length * 8;
  {
    final value = object.tagline;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _cachedMovieDetailsSerialize(
  CachedMovieDetails object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.cachedAt);
  writer.writeObjectList<CachedCastMember>(
    offsets[1],
    allOffsets,
    CachedCastMemberSchema.serialize,
    object.cast,
  );
  writer.writeStringList(offsets[2], object.genreNames);
  writer.writeLong(offsets[3], object.runtime);
  writer.writeLongList(offsets[4], object.similarIds);
  writer.writeString(offsets[5], object.tagline);
}

CachedMovieDetails _cachedMovieDetailsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CachedMovieDetails();
  object.cachedAt = reader.readDateTime(offsets[0]);
  object.cast =
      reader.readObjectList<CachedCastMember>(
        offsets[1],
        CachedCastMemberSchema.deserialize,
        allOffsets,
        CachedCastMember(),
      ) ??
      [];
  object.genreNames = reader.readStringList(offsets[2]) ?? [];
  object.id = id;
  object.runtime = reader.readLongOrNull(offsets[3]);
  object.similarIds = reader.readLongList(offsets[4]) ?? [];
  object.tagline = reader.readStringOrNull(offsets[5]);
  return object;
}

P _cachedMovieDetailsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readObjectList<CachedCastMember>(
                offset,
                CachedCastMemberSchema.deserialize,
                allOffsets,
                CachedCastMember(),
              ) ??
              [])
          as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongList(offset) ?? []) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cachedMovieDetailsGetId(CachedMovieDetails object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cachedMovieDetailsGetLinks(
  CachedMovieDetails object,
) {
  return [];
}

void _cachedMovieDetailsAttach(
  IsarCollection<dynamic> col,
  Id id,
  CachedMovieDetails object,
) {
  object.id = id;
}

extension CachedMovieDetailsQueryWhereSort
    on QueryBuilder<CachedMovieDetails, CachedMovieDetails, QWhere> {
  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CachedMovieDetailsQueryWhere
    on QueryBuilder<CachedMovieDetails, CachedMovieDetails, QWhereClause> {
  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterWhereClause>
  idBetween(
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
}

extension CachedMovieDetailsQueryFilter
    on QueryBuilder<CachedMovieDetails, CachedMovieDetails, QFilterCondition> {
  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  cachedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cachedAt', value: value),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  cachedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'cachedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  cachedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'cachedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  cachedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'cachedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  castLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cast', length, true, length, true);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  castIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cast', 0, true, 0, true);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  castIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cast', 0, false, 999999, true);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  castLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cast', 0, true, length, include);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  castLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'cast', length, include, 999999, true);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  castLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'cast',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
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

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
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

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
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

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
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

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
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

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
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

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
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

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
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

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  genreNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'genreNames', value: ''),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  genreNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'genreNames', value: ''),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  genreNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genreNames', length, true, length, true);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  genreNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genreNames', 0, true, 0, true);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  genreNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genreNames', 0, false, 999999, true);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  genreNamesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genreNames', 0, true, length, include);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  genreNamesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genreNames', length, include, 999999, true);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
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

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
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

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  idBetween(
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

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  runtimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'runtime'),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  runtimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'runtime'),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  runtimeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'runtime', value: value),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  runtimeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'runtime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  runtimeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'runtime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  runtimeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'runtime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  similarIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'similarIds', value: value),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  similarIdsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'similarIds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  similarIdsElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'similarIds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  similarIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'similarIds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  similarIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'similarIds', length, true, length, true);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  similarIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'similarIds', 0, true, 0, true);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  similarIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'similarIds', 0, false, 999999, true);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  similarIdsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'similarIds', 0, true, length, include);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  similarIdsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'similarIds', length, include, 999999, true);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  similarIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'similarIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  taglineIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'tagline'),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  taglineIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'tagline'),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  taglineEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tagline',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  taglineGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tagline',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  taglineLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tagline',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  taglineBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tagline',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  taglineStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'tagline',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  taglineEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'tagline',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  taglineContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'tagline',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  taglineMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'tagline',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  taglineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tagline', value: ''),
      );
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  taglineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tagline', value: ''),
      );
    });
  }
}

extension CachedMovieDetailsQueryObject
    on QueryBuilder<CachedMovieDetails, CachedMovieDetails, QFilterCondition> {
  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterFilterCondition>
  castElement(FilterQuery<CachedCastMember> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'cast');
    });
  }
}

extension CachedMovieDetailsQueryLinks
    on QueryBuilder<CachedMovieDetails, CachedMovieDetails, QFilterCondition> {}

extension CachedMovieDetailsQuerySortBy
    on QueryBuilder<CachedMovieDetails, CachedMovieDetails, QSortBy> {
  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterSortBy>
  sortByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterSortBy>
  sortByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterSortBy>
  sortByRuntime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtime', Sort.asc);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterSortBy>
  sortByRuntimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtime', Sort.desc);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterSortBy>
  sortByTagline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagline', Sort.asc);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterSortBy>
  sortByTaglineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagline', Sort.desc);
    });
  }
}

extension CachedMovieDetailsQuerySortThenBy
    on QueryBuilder<CachedMovieDetails, CachedMovieDetails, QSortThenBy> {
  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterSortBy>
  thenByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterSortBy>
  thenByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterSortBy>
  thenByRuntime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtime', Sort.asc);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterSortBy>
  thenByRuntimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtime', Sort.desc);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterSortBy>
  thenByTagline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagline', Sort.asc);
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QAfterSortBy>
  thenByTaglineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagline', Sort.desc);
    });
  }
}

extension CachedMovieDetailsQueryWhereDistinct
    on QueryBuilder<CachedMovieDetails, CachedMovieDetails, QDistinct> {
  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QDistinct>
  distinctByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAt');
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QDistinct>
  distinctByGenreNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genreNames');
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QDistinct>
  distinctByRuntime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runtime');
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QDistinct>
  distinctBySimilarIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'similarIds');
    });
  }

  QueryBuilder<CachedMovieDetails, CachedMovieDetails, QDistinct>
  distinctByTagline({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tagline', caseSensitive: caseSensitive);
    });
  }
}

extension CachedMovieDetailsQueryProperty
    on QueryBuilder<CachedMovieDetails, CachedMovieDetails, QQueryProperty> {
  QueryBuilder<CachedMovieDetails, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CachedMovieDetails, DateTime, QQueryOperations>
  cachedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAt');
    });
  }

  QueryBuilder<CachedMovieDetails, List<CachedCastMember>, QQueryOperations>
  castProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cast');
    });
  }

  QueryBuilder<CachedMovieDetails, List<String>, QQueryOperations>
  genreNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genreNames');
    });
  }

  QueryBuilder<CachedMovieDetails, int?, QQueryOperations> runtimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runtime');
    });
  }

  QueryBuilder<CachedMovieDetails, List<int>, QQueryOperations>
  similarIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'similarIds');
    });
  }

  QueryBuilder<CachedMovieDetails, String?, QQueryOperations>
  taglineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tagline');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CachedCastMemberSchema = Schema(
  name: r'CachedCastMember',
  id: 8006327705287522925,
  properties: {
    r'character': PropertySchema(
      id: 0,
      name: r'character',
      type: IsarType.string,
    ),
    r'id': PropertySchema(id: 1, name: r'id', type: IsarType.long),
    r'name': PropertySchema(id: 2, name: r'name', type: IsarType.string),
    r'order': PropertySchema(id: 3, name: r'order', type: IsarType.long),
    r'profilePath': PropertySchema(
      id: 4,
      name: r'profilePath',
      type: IsarType.string,
    ),
  },

  estimateSize: _cachedCastMemberEstimateSize,
  serialize: _cachedCastMemberSerialize,
  deserialize: _cachedCastMemberDeserialize,
  deserializeProp: _cachedCastMemberDeserializeProp,
);

int _cachedCastMemberEstimateSize(
  CachedCastMember object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.character;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.profilePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _cachedCastMemberSerialize(
  CachedCastMember object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.character);
  writer.writeLong(offsets[1], object.id);
  writer.writeString(offsets[2], object.name);
  writer.writeLong(offsets[3], object.order);
  writer.writeString(offsets[4], object.profilePath);
}

CachedCastMember _cachedCastMemberDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CachedCastMember(
    character: reader.readStringOrNull(offsets[0]),
    id: reader.readLongOrNull(offsets[1]) ?? 0,
    name: reader.readStringOrNull(offsets[2]) ?? '',
    order: reader.readLongOrNull(offsets[3]) ?? 0,
    profilePath: reader.readStringOrNull(offsets[4]),
  );
  return object;
}

P _cachedCastMemberDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CachedCastMemberQueryFilter
    on QueryBuilder<CachedCastMember, CachedCastMember, QFilterCondition> {
  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  characterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'character'),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  characterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'character'),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  characterEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'character',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  characterGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'character',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  characterLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'character',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  characterBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'character',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  characterStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'character',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  characterEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'character',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  characterContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'character',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  characterMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'character',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  characterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'character', value: ''),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  characterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'character', value: ''),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  idGreaterThan(int value, {bool include = false}) {
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

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  idLessThan(int value, {bool include = false}) {
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

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  idBetween(
    int lower,
    int upper, {
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

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  orderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'order', value: value),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  orderGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'order',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  orderLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'order',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  orderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'order',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  profilePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'profilePath'),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  profilePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'profilePath'),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  profilePathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'profilePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  profilePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'profilePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  profilePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'profilePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  profilePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'profilePath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  profilePathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'profilePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  profilePathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'profilePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  profilePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'profilePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  profilePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'profilePath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  profilePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'profilePath', value: ''),
      );
    });
  }

  QueryBuilder<CachedCastMember, CachedCastMember, QAfterFilterCondition>
  profilePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'profilePath', value: ''),
      );
    });
  }
}

extension CachedCastMemberQueryObject
    on QueryBuilder<CachedCastMember, CachedCastMember, QFilterCondition> {}
