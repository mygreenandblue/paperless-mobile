import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/config/hive/hive_type_ids.dart';

part 'sort_field.g.dart';

@JsonEnum(valueField: 'queryString')
@HiveType(typeId: PaperlessApiHiveTypeIds.sortField)
enum SortField {
  @HiveField(0)
  archiveSerialNumber("archive_serial_number"),
  @HiveField(1)
  correspondentName("correspondent__name"),
  @HiveField(2)
  title("title"),
  @HiveField(3)
  documentType("document_type__name"),
  @HiveField(4)
  created("created"),
  @HiveField(5)
  added("added"),
  @HiveField(6)
  modified("modified"),
  @HiveField(7)
  score("score");

  final String queryString;

  const SortField(this.queryString);

  @override
  String toString() {
    return name.toLowerCase();
  }
}
