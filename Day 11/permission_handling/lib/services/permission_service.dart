import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  const PermissionService();

  Future<Map<Permission, PermissionStatus>> fetchStatuses(
    Iterable<Permission> permissions,
  ) async {
    final statuses = <Permission, PermissionStatus>{};

    for (final permission in permissions) {
      statuses[permission] = await permission.status;
    }

    return statuses;
  }

  Future<PermissionStatus> requestPermission(Permission permission) {
    return permission.request();
  }

  Future<Map<Permission, PermissionStatus>> requestPermissions(
    Iterable<Permission> permissions,
  ) {
    return permissions.toList().request();
  }

  Future<bool> openSettings() {
    return openAppSettings();
  }
}
