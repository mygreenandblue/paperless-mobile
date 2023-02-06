import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'id_query_parameter.g.dart';

@JsonSerializable()
class IdQueryParameter extends Equatable {
  final int? assignmentStatus;
  final int? id;

  @Deprecated("Use named constructors, this is only meant for code generation")
  const IdQueryParameter(this.assignmentStatus, this.id);

  const IdQueryParameter.notAssigned()
      : assignmentStatus = 1,
        id = null;

  const IdQueryParameter.anyAssigned()
      : assignmentStatus = 0,
        id = null;

  const IdQueryParameter.fromId(this.id) : assignmentStatus = null;

  const IdQueryParameter.unset() : this.fromId(null);

  bool get isUnset => id == null && assignmentStatus == null;

  bool get isSet => id != null && assignmentStatus == null;

  bool get onlyNotAssigned => assignmentStatus == 1;

  bool get onlyAssigned => assignmentStatus == 0;

  Map<String, String> toQueryParameter(String field) {
    final Map<String, String> params = {};
    if (onlyNotAssigned || onlyAssigned) {
      params.putIfAbsent(
          '${field}__isnull', () => assignmentStatus!.toString());
    }
    if (isSet) {
      params.putIfAbsent("${field}__id", () => id!.toString());
    }
    return params;
  }

  bool matches(int? id) {
    return onlyAssigned && id != null ||
        onlyNotAssigned && id == null ||
        isSet && id == this.id ||
        isUnset;
  }

  @override
  List<Object?> get props => [assignmentStatus, id];

  Map<String, dynamic> toJson() => _$IdQueryParameterToJson(this);

  factory IdQueryParameter.fromJson(Map<String, dynamic> json) =>
      _$IdQueryParameterFromJson(json);
}
