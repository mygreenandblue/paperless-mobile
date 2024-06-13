import 'package:hive_flutter/adapters.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/database/hive/hive_config.dart';
import 'package:edocs_mobile/core/database/tables/local_user_settings.dart';

part 'local_user_account.g.dart';

@HiveType(typeId: HiveTypeIds.localUserAccount)
class LocalUserAccount extends HiveObject {
  @HiveField(0)
  final String serverUrl;

  @HiveField(3)
  final String id;

  @HiveField(4)
  final LocalUserSettings settings;

  @HiveField(7)
  UserModel edocsUser;

  @HiveField(8, defaultValue: 2)
  int apiVersion;

  LocalUserAccount({
    required this.id,
    required this.serverUrl,
    required this.settings,
    required this.edocsUser,
    required this.apiVersion,
  });

  bool get hasMultiUserSupport => apiVersion >= 3;
}
