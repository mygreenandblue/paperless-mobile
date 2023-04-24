import 'package:hive/hive.dart';
import 'package:paperless_api/config/hive/hive_type_ids.dart';
import 'package:paperless_api/src/models/query_parameters/date_range_queries/date_range_query_field.dart';

import 'date_range_query.dart';

class UnsetDateRangeQuery extends DateRangeQuery {
  const UnsetDateRangeQuery();
  @override
  List<Object?> get props => [];

  @override
  Map<String, String> toQueryParameter(DateRangeQueryField field) => const {};

  @override
  Map<String, dynamic> toJson() => const {};

  @override
  bool matches(DateTime dt) => true;
}

class UnsetDateRangeQueryAdapter extends TypeAdapter<UnsetDateRangeQuery> {
  @override
  final int typeId = 113;

  @override
  UnsetDateRangeQuery read(BinaryReader reader) {
    reader.readByte();
    return const UnsetDateRangeQuery();
  }

  @override
  void write(BinaryWriter writer, UnsetDateRangeQuery obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnsetDateRangeQueryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
