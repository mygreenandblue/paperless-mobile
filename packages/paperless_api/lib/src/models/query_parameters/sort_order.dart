import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/config/hive/hive_type_ids.dart';

part 'sort_order.g.dart';

@JsonEnum()
@HiveType(typeId: PaperlessApiHiveTypeIds.sortOrder)
enum SortOrder {
  @HiveField(0)
  ascending(""),
  @HiveField(1)
  descending("-");

  final String queryString;
  const SortOrder(this.queryString);

  SortOrder toggle() {
    return this == ascending ? descending : ascending;
  }
}
