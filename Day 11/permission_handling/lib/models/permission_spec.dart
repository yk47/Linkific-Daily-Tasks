import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionSpec {
  const PermissionSpec({
    required this.title,
    required this.permission,
    required this.icon,
    required this.description,
    required this.rationale,
    required this.grantedMessage,
    this.platformNote,
  });

  final String title;
  final Permission permission;
  final IconData icon;
  final String description;
  final String rationale;
  final String grantedMessage;
  final String? platformNote;
}
