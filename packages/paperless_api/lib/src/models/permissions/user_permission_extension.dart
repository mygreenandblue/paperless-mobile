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

  bool hasPermissions(List<PermissionAction> actions, List<PermissionTarget> targets) {
    return map(
      v3: (user) {
        final permissions = [
          for (var action in actions)
            for (var target in targets) [action, target].join("_")
        ];
        return permissions.every((requestedPermission) =>
            user.userPermissions.contains(requestedPermission) ||
            user.inheritedPermissions
                .any((element) => element.split(".").last == requestedPermission));
      },
      v2: (_) => true,
    );
  }
}
