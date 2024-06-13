import 'package:hive/hive.dart';
import 'package:edocs_api/config/hive/hive_type_ids.dart';
part 'date_range_unit.g.dart';

@HiveType(typeId: edocsApiHiveTypeIds.dateRangeUnit)
enum DateRangeUnit {
  @HiveField(0)
  day,
  @HiveField(1)
  week,
  @HiveField(2)
  month,
  @HiveField(3)
  year;
}
