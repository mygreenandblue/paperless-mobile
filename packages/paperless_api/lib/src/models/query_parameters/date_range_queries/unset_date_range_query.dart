import 'package:hive/hive.dart';
import 'package:paperless_api/config/hive/hive_type_ids.dart';
import 'package:paperless_api/src/models/query_parameters/date_range_queries/date_range_query_field.dart';

import 'date_range_query.dart';
part 'unset_date_range_query.g.dart';

@HiveType(typeId: PaperlessApiHiveTypeIds.unsetDateRangeQuery)
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
