import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

extension PermissionStatusUi on PermissionStatus {
  String get label {
    if (isGranted) {
      return 'Granted';
    }
    if (isLimited) {
      return 'Limited';
    }
    if (isPermanentlyDenied) {
      return 'Permanently denied';
    }
    if (isRestricted) {
      return 'Restricted';
    }
    if (isProvisional) {
      return 'Provisional';
    }
    return 'Denied';
  }

  Color get color {
    if (isGranted) {
      return const Color(0xFF22C55E);
    }
    if (isLimited) {
      return const Color(0xFF38BDF8);
    }
    if (isPermanentlyDenied) {
      return const Color(0xFFF97316);
    }
    if (isRestricted) {
      return const Color(0xFFEF4444);
    }
    if (isProvisional) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFF94A3B8);
  }
}
