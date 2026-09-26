// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_actor.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCachedActorCollection on Isar {
  IsarCollection<CachedActor> get cachedActors => this.collection();
}

const CachedActorSchema = CollectionSchema(
  name: r'CachedActor',
  id: 5992596192831516088,
  properties: {
    r'biography': PropertySchema(
      id: 0,
      name: r'biography',
      type: IsarType.string,
    ),
    r'birthday': PropertySchema(
      id: 1,
      name: r'birthday',
      type: IsarType.string,
    ),
    r'cachedAt': PropertySchema(
      id: 2,
      name: r'cachedAt',
      type: IsarType.dateTime,
    ),
    r'credits': PropertySchema(
      id: 3,
      name: r'credits',
      type: IsarType.objectList,

      target: r'CachedActorCredit',
    ),
    r'deathday': PropertySchema(
      id: 4,
      name: r'deathday',
      type: IsarType.string,
    ),
    r'gender': PropertySchema(id: 5, name: r'gender', type: IsarType.long),
    r'knownForDepartment': PropertySchema(
      id: 6,
      name: r'knownForDepartment',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 7, name: r'name', type: IsarType.string),
    r'placeOfBirth': PropertySchema(
      id: 8,
      name: r'placeOfBirth',
      type: IsarType.string,
    ),
    r'profilePath': PropertySchema(
      id: 9,
      name: r'profilePath',
      type: IsarType.string,
    ),
  },

  estimateSize: _cachedActorEstimateSize,
  serialize: _cachedActorSerialize,
  deserialize: _cachedActorDeserialize,
  deserializeProp: _cachedActorDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'CachedActorCredit': CachedActorCreditSchema},

  getId: _cachedActorGetId,
  getLinks: _cachedActorGetLinks,
  attach: _cachedActorAttach,
  version: '3.3.2',
);

int _cachedActorEstimateSize(
  CachedActor object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.biography;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.birthday;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.credits.length * 3;
  {
    final offsets = allOffsets[CachedActorCredit]!;
    for (var i = 0; i < object.credits.length; i++) {
      final value = object.credits[i];
      bytesCount += CachedActorCreditSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  {
    final value = object.deathday;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.knownForDepartment;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.placeOfBirth;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.profilePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _cachedActorSerialize(
  CachedActor object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.biography);
  writer.writeString(offsets[1], object.birthday);
  writer.writeDateTime(offsets[2], object.cachedAt);
  writer.writeObjectList<CachedActorCredit>(
    offsets[3],
    allOffsets,
    CachedActorCreditSchema.serialize,
    object.credits,
  );
  writer.writeString(offsets[4], object.deathday);
  writer.writeLong(offsets[5], object.gender);
  writer.writeString(offsets[6], object.knownForDepartment);
  writer.writeString(offsets[7], object.name);
  writer.writeString(offsets[8], object.placeOfBirth);
  writer.writeString(offsets[9], object.profilePath);
}

CachedActor _cachedActorDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CachedActor();
  object.biography = reader.readStringOrNull(offsets[0]);
  object.birthday = reader.readStringOrNull(offsets[1]);
  object.cachedAt = reader.readDateTime(offsets[2]);
  object.credits =
      reader.readObjectList<CachedActorCredit>(
        offsets[3],
        CachedActorCreditSchema.deserialize,
        allOffsets,
        CachedActorCredit(),
      ) ??
      [];
  object.deathday = reader.readStringOrNull(offsets[4]);
  object.gender = reader.readLong(offsets[5]);
  object.id = id;
  object.knownForDepartment = reader.readStringOrNull(offsets[6]);
  object.name = reader.readString(offsets[7]);
  object.placeOfBirth = reader.readStringOrNull(offsets[8]);
  object.profilePath = reader.readStringOrNull(offsets[9]);
  return object;
}

P _cachedActorDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readObjectList<CachedActorCredit>(
                offset,
                CachedActorCreditSchema.deserialize,
                allOffsets,
                CachedActorCredit(),
              ) ??
              [])
          as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cachedActorGetId(CachedActor object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cachedActorGetLinks(CachedActor object) {
  return [];
}

void _cachedActorAttach(
  IsarCollection<dynamic> col,
  Id id,
  CachedActor object,
) {
  object.id = id;
}

extension CachedActorQueryWhereSort
    on QueryBuilder<CachedActor, CachedActor, QWhere> {
  QueryBuilder<CachedActor, CachedActor, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CachedActorQueryWhere
    on QueryBuilder<CachedActor, CachedActor, QWhereClause> {
  QueryBuilder<CachedActor, CachedActor, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<CachedActor, CachedActor, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterWhereClause> idBetween(
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

extension CachedActorQueryFilter
    on QueryBuilder<CachedActor, CachedActor, QFilterCondition> {
  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  biographyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'biography'),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  biographyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'biography'),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  biographyEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'biography',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  biographyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'biography',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  biographyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'biography',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  biographyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'biography',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  biographyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'biography',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  biographyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'biography',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  biographyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'biography',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  biographyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'biography',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  biographyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'biography', value: ''),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  biographyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'biography', value: ''),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  birthdayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'birthday'),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  birthdayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'birthday'),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> birthdayEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'birthday',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  birthdayGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'birthday',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  birthdayLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'birthday',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> birthdayBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'birthday',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  birthdayStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'birthday',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  birthdayEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'birthday',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  birthdayContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'birthday',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> birthdayMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'birthday',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  birthdayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'birthday', value: ''),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  birthdayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'birthday', value: ''),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> cachedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'cachedAt', value: value),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> cachedAtBetween(
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  creditsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'credits', length, true, length, true);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  creditsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'credits', 0, true, 0, true);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  creditsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'credits', 0, false, 999999, true);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  creditsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'credits', 0, true, length, include);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  creditsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'credits', length, include, 999999, true);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  creditsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'credits',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  deathdayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'deathday'),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  deathdayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'deathday'),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> deathdayEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'deathday',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  deathdayGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deathday',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  deathdayLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deathday',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> deathdayBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deathday',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  deathdayStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'deathday',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  deathdayEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'deathday',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  deathdayContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'deathday',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> deathdayMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'deathday',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  deathdayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deathday', value: ''),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  deathdayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'deathday', value: ''),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> genderEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gender', value: value),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  genderGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'gender',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> genderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'gender',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> genderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'gender',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  knownForDepartmentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'knownForDepartment'),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  knownForDepartmentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'knownForDepartment'),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  knownForDepartmentEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'knownForDepartment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  knownForDepartmentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'knownForDepartment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  knownForDepartmentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'knownForDepartment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  knownForDepartmentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'knownForDepartment',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  knownForDepartmentStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'knownForDepartment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  knownForDepartmentEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'knownForDepartment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  knownForDepartmentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'knownForDepartment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  knownForDepartmentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'knownForDepartment',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  knownForDepartmentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'knownForDepartment', value: ''),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  knownForDepartmentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'knownForDepartment', value: ''),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  placeOfBirthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'placeOfBirth'),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  placeOfBirthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'placeOfBirth'),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  placeOfBirthEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'placeOfBirth',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  placeOfBirthGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'placeOfBirth',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  placeOfBirthLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'placeOfBirth',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  placeOfBirthBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'placeOfBirth',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  placeOfBirthStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'placeOfBirth',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  placeOfBirthEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'placeOfBirth',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  placeOfBirthContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'placeOfBirth',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  placeOfBirthMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'placeOfBirth',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  placeOfBirthIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'placeOfBirth', value: ''),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  placeOfBirthIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'placeOfBirth', value: ''),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  profilePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'profilePath'),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  profilePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'profilePath'),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
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

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  profilePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'profilePath', value: ''),
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition>
  profilePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'profilePath', value: ''),
      );
    });
  }
}

extension CachedActorQueryObject
    on QueryBuilder<CachedActor, CachedActor, QFilterCondition> {
  QueryBuilder<CachedActor, CachedActor, QAfterFilterCondition> creditsElement(
    FilterQuery<CachedActorCredit> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'credits');
    });
  }
}

extension CachedActorQueryLinks
    on QueryBuilder<CachedActor, CachedActor, QFilterCondition> {}

extension CachedActorQuerySortBy
    on QueryBuilder<CachedActor, CachedActor, QSortBy> {
  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByBiography() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biography', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByBiographyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biography', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByBirthday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthday', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByBirthdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthday', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByDeathday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deathday', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByDeathdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deathday', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy>
  sortByKnownForDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knownForDepartment', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy>
  sortByKnownForDepartmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knownForDepartment', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByPlaceOfBirth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeOfBirth', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy>
  sortByPlaceOfBirthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeOfBirth', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByProfilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePath', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> sortByProfilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePath', Sort.desc);
    });
  }
}

extension CachedActorQuerySortThenBy
    on QueryBuilder<CachedActor, CachedActor, QSortThenBy> {
  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByBiography() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biography', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByBiographyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'biography', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByBirthday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthday', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByBirthdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'birthday', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByCachedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAt', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByDeathday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deathday', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByDeathdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deathday', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy>
  thenByKnownForDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knownForDepartment', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy>
  thenByKnownForDepartmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'knownForDepartment', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByPlaceOfBirth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeOfBirth', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy>
  thenByPlaceOfBirthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeOfBirth', Sort.desc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByProfilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePath', Sort.asc);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QAfterSortBy> thenByProfilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePath', Sort.desc);
    });
  }
}

extension CachedActorQueryWhereDistinct
    on QueryBuilder<CachedActor, CachedActor, QDistinct> {
  QueryBuilder<CachedActor, CachedActor, QDistinct> distinctByBiography({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'biography', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QDistinct> distinctByBirthday({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'birthday', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QDistinct> distinctByCachedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAt');
    });
  }

  QueryBuilder<CachedActor, CachedActor, QDistinct> distinctByDeathday({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deathday', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QDistinct> distinctByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gender');
    });
  }

  QueryBuilder<CachedActor, CachedActor, QDistinct>
  distinctByKnownForDepartment({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'knownForDepartment',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<CachedActor, CachedActor, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QDistinct> distinctByPlaceOfBirth({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'placeOfBirth', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedActor, CachedActor, QDistinct> distinctByProfilePath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profilePath', caseSensitive: caseSensitive);
    });
  }
}

extension CachedActorQueryProperty
    on QueryBuilder<CachedActor, CachedActor, QQueryProperty> {
  QueryBuilder<CachedActor, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CachedActor, String?, QQueryOperations> biographyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'biography');
    });
  }

  QueryBuilder<CachedActor, String?, QQueryOperations> birthdayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'birthday');
    });
  }

  QueryBuilder<CachedActor, DateTime, QQueryOperations> cachedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAt');
    });
  }

  QueryBuilder<CachedActor, List<CachedActorCredit>, QQueryOperations>
  creditsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'credits');
    });
  }

  QueryBuilder<CachedActor, String?, QQueryOperations> deathdayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deathday');
    });
  }

  QueryBuilder<CachedActor, int, QQueryOperations> genderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gender');
    });
  }

  QueryBuilder<CachedActor, String?, QQueryOperations>
  knownForDepartmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'knownForDepartment');
    });
  }

  QueryBuilder<CachedActor, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CachedActor, String?, QQueryOperations> placeOfBirthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'placeOfBirth');
    });
  }

  QueryBuilder<CachedActor, String?, QQueryOperations> profilePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profilePath');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CachedActorCreditSchema = Schema(
  name: r'CachedActorCredit',
  id: -8934234563384850640,
  properties: {
    r'character': PropertySchema(
      id: 0,
      name: r'character',
      type: IsarType.string,
    ),
    r'movieId': PropertySchema(id: 1, name: r'movieId', type: IsarType.long),
    r'popularity': PropertySchema(
      id: 2,
      name: r'popularity',
      type: IsarType.double,
    ),
    r'posterPath': PropertySchema(
      id: 3,
      name: r'posterPath',
      type: IsarType.string,
    ),
    r'releaseDate': PropertySchema(
      id: 4,
      name: r'releaseDate',
      type: IsarType.string,
    ),
    r'title': PropertySchema(id: 5, name: r'title', type: IsarType.string),
    r'voteAverage': PropertySchema(
      id: 6,
      name: r'voteAverage',
      type: IsarType.double,
    ),
  },

  estimateSize: _cachedActorCreditEstimateSize,
  serialize: _cachedActorCreditSerialize,
  deserialize: _cachedActorCreditDeserialize,
  deserializeProp: _cachedActorCreditDeserializeProp,
);

int _cachedActorCreditEstimateSize(
  CachedActorCredit object,
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

void _cachedActorCreditSerialize(
  CachedActorCredit object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.character);
  writer.writeLong(offsets[1], object.movieId);
  writer.writeDouble(offsets[2], object.popularity);
  writer.writeString(offsets[3], object.posterPath);
  writer.writeString(offsets[4], object.releaseDate);
  writer.writeString(offsets[5], object.title);
  writer.writeDouble(offsets[6], object.voteAverage);
}

CachedActorCredit _cachedActorCreditDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CachedActorCredit(
    character: reader.readStringOrNull(offsets[0]),
    movieId: reader.readLongOrNull(offsets[1]) ?? 0,
    popularity: reader.readDoubleOrNull(offsets[2]) ?? 0,
    posterPath: reader.readStringOrNull(offsets[3]),
    releaseDate: reader.readStringOrNull(offsets[4]),
    title: reader.readStringOrNull(offsets[5]) ?? '',
    voteAverage: reader.readDoubleOrNull(offsets[6]) ?? 0,
  );
  return object;
}

P _cachedActorCreditDeserializeProp<P>(
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
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readDoubleOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CachedActorCreditQueryFilter
    on QueryBuilder<CachedActorCredit, CachedActorCredit, QFilterCondition> {
  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  characterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'character'),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  characterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'character'),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  characterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'character', value: ''),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  characterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'character', value: ''),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  movieIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'movieId', value: value),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  popularityEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'popularity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  popularityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'popularity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  popularityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'popularity',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  popularityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'popularity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  posterPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'posterPath'),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  posterPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'posterPath'),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  posterPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'posterPath', value: ''),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  posterPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'posterPath', value: ''),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  releaseDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'releaseDate'),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  releaseDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'releaseDate'),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  releaseDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'releaseDate', value: ''),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  releaseDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'releaseDate', value: ''),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

  QueryBuilder<CachedActorCredit, CachedActorCredit, QAfterFilterCondition>
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

extension CachedActorCreditQueryObject
    on QueryBuilder<CachedActorCredit, CachedActorCredit, QFilterCondition> {}
