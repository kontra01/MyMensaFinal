// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mensaday.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMensaDayCollection on Isar {
  IsarCollection<MensaDay> get mensaDays => this.collection();
}

const MensaDaySchema = CollectionSchema(
  name: r'MensaDay',
  id: -153719640907613138,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'mealTypes': PropertySchema(
      id: 1,
      name: r'mealTypes',
      type: IsarType.longList,
    )
  },
  estimateSize: _mensaDayEstimateSize,
  serialize: _mensaDaySerialize,
  deserialize: _mensaDayDeserialize,
  deserializeProp: _mensaDayDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _mensaDayGetId,
  getLinks: _mensaDayGetLinks,
  attach: _mensaDayAttach,
  version: '3.1.0+1',
);

int _mensaDayEstimateSize(
  MensaDay object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mealTypes.length * 8;
  return bytesCount;
}

void _mensaDaySerialize(
  MensaDay object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeLongList(offsets[1], object.mealTypes);
}

MensaDay _mensaDayDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MensaDay(
    reader.readDateTime(offsets[0]),
    mealTypes: reader.readLongList(offsets[1]) ?? const [],
  );
  object.id = id;
  return object;
}

P _mensaDayDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLongList(offset) ?? const []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mensaDayGetId(MensaDay object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mensaDayGetLinks(MensaDay object) {
  return [];
}

void _mensaDayAttach(IsarCollection<dynamic> col, Id id, MensaDay object) {
  object.id = id;
}

extension MensaDayQueryWhereSort on QueryBuilder<MensaDay, MensaDay, QWhere> {
  QueryBuilder<MensaDay, MensaDay, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MensaDayQueryWhere on QueryBuilder<MensaDay, MensaDay, QWhereClause> {
  QueryBuilder<MensaDay, MensaDay, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<MensaDay, MensaDay, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MensaDayQueryFilter
    on QueryBuilder<MensaDay, MensaDay, QFilterCondition> {
  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition>
      mealTypesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mealTypes',
        value: value,
      ));
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition>
      mealTypesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mealTypes',
        value: value,
      ));
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition>
      mealTypesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mealTypes',
        value: value,
      ));
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition>
      mealTypesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mealTypes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition>
      mealTypesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mealTypes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition> mealTypesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mealTypes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition>
      mealTypesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mealTypes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition>
      mealTypesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mealTypes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition>
      mealTypesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mealTypes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterFilterCondition>
      mealTypesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mealTypes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension MensaDayQueryObject
    on QueryBuilder<MensaDay, MensaDay, QFilterCondition> {}

extension MensaDayQueryLinks
    on QueryBuilder<MensaDay, MensaDay, QFilterCondition> {}

extension MensaDayQuerySortBy on QueryBuilder<MensaDay, MensaDay, QSortBy> {
  QueryBuilder<MensaDay, MensaDay, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }
}

extension MensaDayQuerySortThenBy
    on QueryBuilder<MensaDay, MensaDay, QSortThenBy> {
  QueryBuilder<MensaDay, MensaDay, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MensaDay, MensaDay, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension MensaDayQueryWhereDistinct
    on QueryBuilder<MensaDay, MensaDay, QDistinct> {
  QueryBuilder<MensaDay, MensaDay, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<MensaDay, MensaDay, QDistinct> distinctByMealTypes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mealTypes');
    });
  }
}

extension MensaDayQueryProperty
    on QueryBuilder<MensaDay, MensaDay, QQueryProperty> {
  QueryBuilder<MensaDay, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MensaDay, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<MensaDay, List<int>, QQueryOperations> mealTypesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mealTypes');
    });
  }
}
