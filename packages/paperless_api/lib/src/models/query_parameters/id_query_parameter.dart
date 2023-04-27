import 'package:hive/hive.dart';
import 'package:paperless_api/config/hive/hive_type_ids.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'id_query_parameter.freezed.dart';
part 'id_query_parameter.g.dart';

@freezed
class IdQueryParameter with _$IdQueryParameter {
  const IdQueryParameter._();
  @HiveType(typeId: PaperlessApiHiveTypeIds.unsetIdQueryParameter)
  const factory IdQueryParameter.unset() = UnsetIdQueryParameter;
  @HiveType(typeId: PaperlessApiHiveTypeIds.notAssignedIdQueryParameter)
  const factory IdQueryParameter.notAssigned() = NotAssignedIdQueryParameter;
  @HiveType(typeId: PaperlessApiHiveTypeIds.anyAssignedIdQueryParameter)
  const factory IdQueryParameter.anyAssigned() = AnyAssignedIdQueryParameter;
  @HiveType(typeId: PaperlessApiHiveTypeIds.setIdQueryParameter)
  const factory IdQueryParameter.fromId(@HiveField(0) int id) = SetIdQueryParameter;

  Map<String, String> toQueryParameter(String field) {
    return when(
      unset: () => {},
      notAssigned: () => {
        '${field}__isnull': '1',
      },
      anyAssigned: () => {
        '${field}__isnull': '0',
      },
      fromId: (id) {
        if (id == null) {
          return {};
        }
        return {'${field}_id': '$id'};
      },
    );
  }

  bool isOnlyNotAssigned() => this is NotAssignedIdQueryParameter;

  bool isOnlyAssigned() => this is AnyAssignedIdQueryParameter;

  bool isSet() => this is SetIdQueryParameter;

  bool isUnset() => this is UnsetIdQueryParameter;

  bool matches(int? id) {
    return when(
      unset: () => true,
      notAssigned: () => id == null,
      anyAssigned: () => id != null,
      fromId: (id_) => id == id_,
    );
  }

  factory IdQueryParameter.fromJson(Map<String, dynamic> json) => _$IdQueryParameterFromJson(json);
}

// @JsonSerializable()
// @HiveType(typeId: PaperlessApiHiveTypeIds.idQueryParameter)
// class IdQueryParameter extends Equatable {
//   @HiveField(0)
//   final int? assignmentStatus;
//   @HiveField(1)
//   final int? id;

//   @Deprecated("Use named constructors, this is only meant for code generation")
//   const IdQueryParameter(this.assignmentStatus, this.id);

//   const IdQueryParameter.notAssigned()
//       : assignmentStatus = 1,
//         id = null;

//   const IdQueryParameter.anyAssigned()
//       : assignmentStatus = 0,
//         id = null;

//   const IdQueryParameter.fromId(this.id) : assignmentStatus = null;

//   const IdQueryParameter.unset() : this.fromId(null);

//   bool get isUnset => id == null && assignmentStatus == null;

//   bool get isSet => id != null && assignmentStatus == null;

//   bool get onlyNotAssigned => assignmentStatus == 1;

//   bool get onlyAssigned => assignmentStatus == 0;

//   Map<String, String> toQueryParameter(String field) {
//     final Map<String, String> params = {};
//     if (onlyNotAssigned || onlyAssigned) {
//       params.putIfAbsent('${field}__isnull', () => assignmentStatus!.toString());
//     }
//     if (isSet) {
//       params.putIfAbsent("${field}__id", () => id!.toString());
//     }
//     return params;
//   }

//   bool matches(int? id) {
//     return onlyAssigned && id != null ||
//         onlyNotAssigned && id == null ||
//         isSet && id == this.id ||
//         isUnset;
//   }

//   @override
//   List<Object?> get props => [assignmentStatus, id];

//   Map<String, dynamic> toJson() => _$IdQueryParameterToJson(this);

//   factory IdQueryParameter.fromJson(Map<String, dynamic> json) => _$IdQueryParameterFromJson(json);
// }

