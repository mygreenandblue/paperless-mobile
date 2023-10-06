import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:paperless_api/config/hive/hive_type_ids.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'id_query_parameter.freezed.dart';
part 'id_query_parameter.g.dart';

sealed class IdQueryParameter {
  const IdQueryParameter();
  Map<String, String> toQueryParameter(String field);
  bool matches(int? id);

  bool get isUnset => this is UnsetIdQueryParameter;
  bool get isSet => this is SetIdQueryParameter;
  bool get isOnlyNotAssigned => this is NotAssignedIdQueryParameter;
  bool get isOnlyAssigned => this is AnyAssignedIdQueryParameter;
}

@HiveType(typeId: PaperlessApiHiveTypeIds.unsetIdQueryParameter)
@Freezed(toJson: false, fromJson: false)
class UnsetIdQueryParameter extends IdQueryParameter
    with _$UnsetIdQueryParameter {
  const UnsetIdQueryParameter._();
  const factory UnsetIdQueryParameter() = _UnsetIdQueryParameter;
  @override
  Map<String, String> toQueryParameter(String field) => {};

  @override
  bool matches(int? id) => true;
}

@HiveType(typeId: PaperlessApiHiveTypeIds.notAssignedIdQueryParameter)
@Freezed(toJson: false, fromJson: false)
class NotAssignedIdQueryParameter extends IdQueryParameter
    with _$NotAssignedIdQueryParameter {
  const NotAssignedIdQueryParameter._();
  const factory NotAssignedIdQueryParameter() = _NotAssignedIdQueryParameter;
  @override
  Map<String, String> toQueryParameter(String field) {
    return {'${field}__isnull': '1'};
  }

  @override
  bool matches(int? id) => id == null;
}

@HiveType(typeId: PaperlessApiHiveTypeIds.anyAssignedIdQueryParameter)
@Freezed(toJson: false, fromJson: false)
class AnyAssignedIdQueryParameter extends IdQueryParameter
    with _$AnyAssignedIdQueryParameter {
  const factory AnyAssignedIdQueryParameter() = _AnyAssignedIdQueryParameter;
  const AnyAssignedIdQueryParameter._();
  @override
  Map<String, String> toQueryParameter(String field) {
    return {'${field}__isnull': '0'};
  }

  @override
  bool matches(int? id) => id != null;
}

@HiveType(typeId: PaperlessApiHiveTypeIds.setIdQueryParameter)
@Freezed(toJson: false, fromJson: false)
class SetIdQueryParameter extends IdQueryParameter with _$SetIdQueryParameter {
  const SetIdQueryParameter._();
  const factory SetIdQueryParameter({
    @HiveField(0) required int id,
  }) = _SetIdQueryParameter;
  @override
  Map<String, String> toQueryParameter(String field) {
    return {'${field}__id': '$id'};
  }

  @override
  bool matches(int? id) => id == this.id;
}
