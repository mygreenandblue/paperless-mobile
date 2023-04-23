import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/user_settings.dart';

part 'user_account.g.dart';

@HiveType(typeId: HiveTypeIds.userAccount)
class UserAccount extends HiveObject {
  @HiveField(0)
  final String serverUrl;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String? fullName;

  @HiveField(3)
  final String id;

  @HiveField(4)
  UserSettings settings;

  UserAccount({
    required this.id,
    required this.serverUrl,
    required this.username,
    required this.settings,
    this.fullName,
  });
}
