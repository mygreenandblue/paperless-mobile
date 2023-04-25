import 'package:hive/hive.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';

part 'view_type.g.dart';

@HiveType(typeId: HiveTypeIds.viewType)
enum ViewType {
  @HiveField(0)
  grid,
  @HiveField(1)
  list,
  @HiveField(2)
  detailed;

  ViewType toggle() {
    return ViewType.values[(index + 1) % ViewType.values.length];
  }
}
