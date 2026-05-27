// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/permission_spec.dart';
import '../utils/permission_status_utils.dart';
import 'status_chip.dart';

class PermissionCard extends StatelessWidget {
  const PermissionCard({
    super.key,
    required this.spec,
    required this.status,
    required this.onRequest,
    required this.onOpenSettings,
  });

  final PermissionSpec spec;
  final PermissionStatus? status;
  final VoidCallback onRequest;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final effectiveStatus = status ?? PermissionStatus.denied;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: const Color(0xFF0B1626).withOpacity(0.96),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        effectiveStatus.color.withOpacity(0.95),
                        effectiveStatus.color.withOpacity(0.65),
                      ],
                    ),
                  ),
                  child: Icon(spec.icon, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spec.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        spec.description,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                StatusChip(
                  label: effectiveStatus.label,
                  color: effectiveStatus.color,
                ),
              ],
            ),
            if (spec.platformNote != null) ...[
              const SizedBox(height: 12),
              Text(
                spec.platformNote!,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: Colors.white.withOpacity(0.56),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Text(
                  'Current status: ${effectiveStatus.label.toLowerCase()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: effectiveStatus.isDenied ? onRequest : onRequest,
                  child: const Text('Request'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: effectiveStatus.isGranted ? null : onOpenSettings,
                  child: const Text('Open settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
