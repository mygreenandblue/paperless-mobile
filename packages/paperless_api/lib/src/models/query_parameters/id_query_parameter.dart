import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:paperless_api/config/hive/hive_type_ids.dart';

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

// @HiveType(typeId: PaperlessApiHiveTypeIds.unsetIdQueryParameter)
class UnsetIdQueryParameter extends IdQueryParameter {
  const UnsetIdQueryParameter();
  @override
  Map<String, String> toQueryParameter(String field) => {};

  @override
  bool matches(int? id) => true;
}

// @HiveType(typeId: PaperlessApiHiveTypeIds.notAssignedIdQueryParameter)
class NotAssignedIdQueryParameter extends IdQueryParameter {
  const NotAssignedIdQueryParameter();

  @override
  Map<String, String> toQueryParameter(String field) {
    return {'${field}__isnull': '1'};
  }

  @override
  bool matches(int? id) => id == null;
}

// @HiveType(typeId: PaperlessApiHiveTypeIds.anyAssignedIdQueryParameter)
class AnyAssignedIdQueryParameter extends IdQueryParameter {
  const AnyAssignedIdQueryParameter();
  @override
  Map<String, String> toQueryParameter(String field) {
    return {'${field}__isnull': '0'};
  }

  @override
  bool matches(int? id) => id != null;
}

@HiveType(typeId: PaperlessApiHiveTypeIds.setIdQueryParameter)
class SetIdQueryParameter extends IdQueryParameter with EquatableMixin {
  @HiveField(0)
  final int id;

  const SetIdQueryParameter({required this.id});

  @override
  Map<String, String> toQueryParameter(String field) {
    return {'${field}__id': '$id'};
  }

  @override
  bool matches(int? id) => id == this.id;

  @override
  List<Object?> get props => [id];
}

/// Custom Adapters

class UnsetIdQueryParameterAdapter extends TypeAdapter<UnsetIdQueryParameter> {
  @override
  final int typeId = 116;

  @override
  UnsetIdQueryParameter read(BinaryReader reader) {
    reader.readByte();
    return const UnsetIdQueryParameter();
  }

  @override
  void write(BinaryWriter writer, UnsetIdQueryParameter obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnsetIdQueryParameterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotAssignedIdQueryParameterAdapter
    extends TypeAdapter<NotAssignedIdQueryParameter> {
  @override
  final int typeId = 117;

  @override
  NotAssignedIdQueryParameter read(BinaryReader reader) {
    reader.readByte();
    return const NotAssignedIdQueryParameter();
  }

  @override
  void write(BinaryWriter writer, NotAssignedIdQueryParameter obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotAssignedIdQueryParameterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AnyAssignedIdQueryParameterAdapter
    extends TypeAdapter<AnyAssignedIdQueryParameter> {
  @override
  final int typeId = 118;

  @override
  AnyAssignedIdQueryParameter read(BinaryReader reader) {
    reader.readByte();
    return const AnyAssignedIdQueryParameter();
  }

  @override
  void write(BinaryWriter writer, AnyAssignedIdQueryParameter obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnyAssignedIdQueryParameterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
