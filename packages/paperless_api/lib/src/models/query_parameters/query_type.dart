import 'package:hive/hive.dart';
import 'package:paperless_api/config/hive/hive_type_ids.dart';

part 'query_type.g.dart';

@HiveType(typeId: PaperlessApiHiveTypeIds.queryType)
enum QueryType {
  @HiveField(0)
  title('title__icontains'),
  @HiveField(1)
  titleAndContent('title_content'),
  @HiveField(2)
  extended('query'),
  @HiveField(3)
  asn('asn');

  final String queryParam;
  const QueryType(this.queryParam);
}
