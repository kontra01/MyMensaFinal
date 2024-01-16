// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlanCollection on Isar {
  IsarCollection<Plan> get plans => this.collection();
}

const PlanSchema = CollectionSchema(
  name: r'Plan',
  id: 8143067535675439181,
  properties: {
    r'date0': PropertySchema(
      id: 0,
      name: r'date0',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _planEstimateSize,
  serialize: _planSerialize,
  deserialize: _planDeserialize,
  deserializeProp: _planDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _planGetId,
  getLinks: _planGetLinks,
  attach: _planAttach,
  version: '3.1.0+1',
);

int _planEstimateSize(
  Plan object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _planSerialize(
  Plan object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date0);
}

Plan _planDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Plan();
  object.date0 = reader.readDateTimeOrNull(offsets[0]);
  object.id = id;
  return object;
}

P _planDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _planGetId(Plan object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _planGetLinks(Plan object) {
  return [];
}

void _planAttach(IsarCollection<dynamic> col, Id id, Plan object) {
  object.id = id;
}

extension PlanQueryWhereSort on QueryBuilder<Plan, Plan, QWhere> {
  QueryBuilder<Plan, Plan, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlanQueryWhere on QueryBuilder<Plan, Plan, QWhereClause> {
  QueryBuilder<Plan, Plan, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Plan, Plan, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Plan, Plan, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Plan, Plan, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Plan, Plan, QAfterWhereClause> idBetween(
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

extension PlanQueryFilter on QueryBuilder<Plan, Plan, QFilterCondition> {
  QueryBuilder<Plan, Plan, QAfterFilterCondition> date0IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date0',
      ));
    });
  }

  QueryBuilder<Plan, Plan, QAfterFilterCondition> date0IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date0',
      ));
    });
  }

  QueryBuilder<Plan, Plan, QAfterFilterCondition> date0EqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date0',
        value: value,
      ));
    });
  }

  QueryBuilder<Plan, Plan, QAfterFilterCondition> date0GreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date0',
        value: value,
      ));
    });
  }

  QueryBuilder<Plan, Plan, QAfterFilterCondition> date0LessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date0',
        value: value,
      ));
    });
  }

  QueryBuilder<Plan, Plan, QAfterFilterCondition> date0Between(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date0',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Plan, Plan, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Plan, Plan, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Plan, Plan, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Plan, Plan, QAfterFilterCondition> idBetween(
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
}

extension PlanQueryObject on QueryBuilder<Plan, Plan, QFilterCondition> {}

extension PlanQueryLinks on QueryBuilder<Plan, Plan, QFilterCondition> {}

extension PlanQuerySortBy on QueryBuilder<Plan, Plan, QSortBy> {
  QueryBuilder<Plan, Plan, QAfterSortBy> sortByDate0() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date0', Sort.asc);
    });
  }

  QueryBuilder<Plan, Plan, QAfterSortBy> sortByDate0Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date0', Sort.desc);
    });
  }
}

extension PlanQuerySortThenBy on QueryBuilder<Plan, Plan, QSortThenBy> {
  QueryBuilder<Plan, Plan, QAfterSortBy> thenByDate0() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date0', Sort.asc);
    });
  }

  QueryBuilder<Plan, Plan, QAfterSortBy> thenByDate0Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date0', Sort.desc);
    });
  }

  QueryBuilder<Plan, Plan, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Plan, Plan, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension PlanQueryWhereDistinct on QueryBuilder<Plan, Plan, QDistinct> {
  QueryBuilder<Plan, Plan, QDistinct> distinctByDate0() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date0');
    });
  }
}

extension PlanQueryProperty on QueryBuilder<Plan, Plan, QQueryProperty> {
  QueryBuilder<Plan, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Plan, DateTime?, QQueryOperations> date0Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date0');
    });
  }
}
