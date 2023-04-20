import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';

part 'user_account.g.dart';

@HiveType(typeId: HiveTypeIds.userAccount)
class UserAccount {
  @HiveField(0)
  final String serverUrl;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String? fullName;

  UserAccount({
    required this.serverUrl,
    required this.username,
    this.fullName,
  });
}
