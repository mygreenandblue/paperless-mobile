import 'package:hive_flutter/adapters.dart';
import 'package:edocs_mobile/core/database/hive/hive_config.dart';

part 'color_scheme_option.g.dart';

@HiveType(typeId: HiveTypeIds.colorSchemeOption)
enum ColorSchemeOption {
  @HiveField(0)
  classic,
  @HiveField(1)
  dynamic;
}
