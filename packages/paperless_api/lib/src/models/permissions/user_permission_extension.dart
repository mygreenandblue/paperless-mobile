import 'package:paperless_api/paperless_api.dart';

extension UserPermissionExtension on UserModel {
  bool hasPermission(PermissionAction action, PermissionTarget target) {
    return map(
      v3: (user) {
        final permission = [action.value, target.value].join("_");
        return user.userPermissions.any((element) => element == permission) ||
            user.inheritedPermissions.any((element) => element.split(".").last == permission);
      },
      v2: (_) => true,
    );
  }
}
