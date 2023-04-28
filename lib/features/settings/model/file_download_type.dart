import 'package:hive/hive.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';

part 'file_download_type.g.dart';

@HiveType(typeId: HiveTypeIds.fileDownloadType)
enum FileDownloadType {
  @HiveField(1)
  original,
  @HiveField(2)
  archived,
  @HiveField(3)
  alwaysAsk;
}
