import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:edocs_api/edocs_api.dart';

part 'users_and_groups_permissions.freezed.dart';
part 'users_and_groups_permissions.g.dart';

@HiveType(typeId: EdocsApiHiveTypeIds.usersAndGroupsPermissions)
@freezed
class UsersAndGroupsPermissions with _$UsersAndGroupsPermissions {
  const factory UsersAndGroupsPermissions({
    @HiveField(0) @Default([]) List<int> users,
    @HiveField(1) @Default([]) List<int> groups,
  }) = _UsersAndGroupsPermissions;

  factory UsersAndGroupsPermissions.fromJson(Map<String, dynamic> json) =>
      _$UsersAndGroupsPermissionsFromJson(json);
}
