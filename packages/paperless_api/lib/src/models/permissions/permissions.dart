import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_api/src/models/permissions/users_and_groups_permissions.dart';

part 'permissions.freezed.dart';
part 'permissions.g.dart';

@HiveType(typeId: PaperlessApiHiveTypeIds.permissions)
@freezed
class Permissions with _$Permissions {
  const factory Permissions({
    @HiveField(0) required UsersAndGroupsPermissions view,
    @HiveField(1) required UsersAndGroupsPermissions change,
  }) = _Permissions;

  factory Permissions.fromJson(Map<String, dynamic> json) =>
      _$PermissionsFromJson(json);
}
