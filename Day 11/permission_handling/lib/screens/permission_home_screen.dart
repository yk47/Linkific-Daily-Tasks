// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/permission_spec.dart';
import '../services/permission_service.dart';
import '../utils/permission_status_utils.dart';
import '../widgets/permission_card.dart';
import '../widgets/section_header.dart';
import '../widgets/setup_tile.dart';

class PermissionHomeScreen extends StatefulWidget {
  const PermissionHomeScreen({super.key});

  @override
  State<PermissionHomeScreen> createState() => _PermissionHomeScreenState();
}

class _PermissionHomeScreenState extends State<PermissionHomeScreen> {
  static const PermissionService _permissionService = PermissionService();

  List<PermissionSpec> get _permissionSpecs => [
    PermissionSpec(
      title: 'Camera',
      permission: Permission.camera,
      icon: Icons.photo_camera_outlined,
      description: 'Request access before launching the camera flow.',
      rationale:
          'The app needs camera access to capture a photo or scan a document.',
      grantedMessage:
          'Camera access granted. You can continue to capture media.',
    ),
    PermissionSpec(
      title: 'Gallery / Photos',
      permission: Permission.photos,
      icon: Icons.photo_library_outlined,
      description: 'Read the user photos for selection or preview.',
      rationale:
          'The app needs gallery access so users can pick an existing image.',
      grantedMessage:
          'Photos access granted. You can continue to the gallery flow.',
    ),
    PermissionSpec(
      title: 'Location',
      permission: Permission.locationWhenInUse,
      icon: Icons.location_on_outlined,
      description: 'Check and request foreground location access.',
      rationale:
          'The app needs location access to show nearby or location-based content.',
      grantedMessage:
          'Location access granted. Location-based features are ready.',
    ),
    PermissionSpec(
      title: 'Microphone',
      permission: Permission.microphone,
      icon: Icons.mic_none_outlined,
      description: 'Enable audio capture or voice input.',
      rationale:
          'The app needs microphone access to record audio or use voice features.',
      grantedMessage: 'Microphone access granted. Audio features are enabled.',
    ),
    PermissionSpec(
      title: 'Contacts',
      permission: Permission.contacts,
      icon: Icons.contacts_outlined,
      description: 'Read contacts for import or sharing flows.',
      rationale:
          'The app needs contacts access to import or display the user address book.',
      grantedMessage:
          'Contacts access granted. You can continue with contact features.',
    ),
  ];

  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  String _headline =
      'Check a permission to see the current status, then request it at runtime.';
  Map<Permission, PermissionStatus> _statuses =
      <Permission, PermissionStatus>{};

  Permission get _cameraPermission => Permission.camera;
  Permission get _locationPermission => Permission.locationWhenInUse;

  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    await _refreshStatuses();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshStatuses() async {
    setState(() {
      _isLoading = true;
    });

    final updatedStatuses = await _permissionService.fetchStatuses(
      _permissionSpecs.map((spec) => spec.permission),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _statuses = updatedStatuses;
      _headline = 'Statuses refreshed. Review a card or tap a request button.';
      _isLoading = false;
    });
  }

  Future<void> _requestPermission(PermissionSpec spec) async {
    final shouldContinue = await _showRationaleDialog(
      title: 'Request ${spec.title}',
      message: spec.rationale,
    );

    if (!shouldContinue) {
      return;
    }

    final result = await _permissionService.requestPermission(spec.permission);
    if (!mounted) {
      return;
    }

    setState(() {
      _statuses = <Permission, PermissionStatus>{
        ..._statuses,
        spec.permission: result,
      };
      _headline = '${spec.title} returned ${result.label}.';
    });

    await _handleResult(
      spec.title,
      result,
      grantedMessage: spec.grantedMessage,
    );
  }

  Future<void> _requestCorePermissions() async {
    final shouldContinue = await _showRationaleDialog(
      title: 'Request camera and location',
      message:
          'This demo requests the two primary runtime permissions together so you can see the multi-request flow.',
    );

    if (!shouldContinue) {
      return;
    }

    final results = await _permissionService.requestPermissions(<Permission>[
      _cameraPermission,
      _locationPermission,
    ]);

    if (!mounted) {
      return;
    }

    setState(() {
      _statuses = <Permission, PermissionStatus>{..._statuses, ...results};
      _headline =
          'Multiple permissions completed. Review the updated statuses below.';
    });

    if (results.values.any((status) => status.isPermanentlyDenied)) {
      await _promptOpenSettings(
        title: 'One or more permissions were permanently denied',
        message: 'Open system settings to change the permissions manually.',
      );
      return;
    }

    _showSnackBar(
      results.values.every((status) => status.isGranted)
          ? 'Camera and location are granted.'
          : 'One or more permissions were denied. You can retry later.',
    );
  }

  Future<void> _handleResult(
    String label,
    PermissionStatus status, {
    required String grantedMessage,
  }) async {
    if (status.isGranted) {
      _showSnackBar(grantedMessage);
      return;
    }

    if (status.isDenied || status.isPermanentlyDenied) {
      await _promptOpenSettings(
        title: '$label needs manual approval',
        message: 'Open settings to try enabling this permission manually.',
      );
      return;
    }

    if (status.isRestricted) {
      _showSnackBar('$label is restricted by the device or parental controls.');
      return;
    }

    if (status.isLimited) {
      _showSnackBar('$label was granted with limited access.');
      return;
    }

    _showSnackBar('$label was denied. You can try again or open settings.');
  }

  Future<bool> _showRationaleDialog({
    required String title,
    required String message,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _promptOpenSettings({
    required String title,
    required String message,
  }) async {
    final bool? shouldOpenSettingsResult = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Not now'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Open settings'),
            ),
          ],
        );
      },
    );

    if (shouldOpenSettingsResult != true) {
      return;
    }

    final opened = await _permissionService.openSettings();
    if (!mounted) {
      return;
    }

    if (!opened) {
      _showSnackBar('Unable to open system settings on this device.');
      return;
    }

    _showSnackBar('Settings opened. Return here after making changes.');
    await _refreshStatuses();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    final quickFlowSpecs = <PermissionSpec>[
      _permissionSpecs[0],
      _permissionSpecs[2],
      _permissionSpecs[3],
    ];

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF06111F), Color(0xFF0F172A), Color(0xFF102A43)],
          ),
        ),
        child: SafeArea(
          child: Scrollbar(
            controller: _scrollController,
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF111827).withOpacity(0.96),
                        const Color(0xFF1E293B).withOpacity(0.94),
                      ],
                    ),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66000000),
                        blurRadius: 30,
                        offset: Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Permission Handling',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _headline,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.45,
                          color: Colors.white.withOpacity(0.82),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          FilledButton.icon(
                            onPressed: _isLoading ? null : _refreshStatuses,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh statuses'),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: _isLoading
                                ? null
                                : _requestCorePermissions,
                            icon: const Icon(Icons.tune),
                            label: const Text('Request core permissions'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        Platform.isAndroid
                            ? 'Android note: gallery access uses media permissions on Android 13+.'
                            : 'iOS note: the Podfile and Info.plist entries below are required so runtime prompts can appear.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Colors.white.withOpacity(0.68),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const SectionHeader(
                  title: 'Core flows',
                  subtitle:
                      'Camera and location are grouped here so you can try the single and multi-request paths.',
                ),
                const SizedBox(height: 12),
                for (final spec in quickFlowSpecs) ...[
                  PermissionCard(
                    spec: spec,
                    status: _statuses[spec.permission],
                    onRequest: () => _requestPermission(spec),
                    onOpenSettings: () => _promptOpenSettings(
                      title: '${spec.title} settings',
                      message:
                          'Open settings to enable ${spec.title.toLowerCase()} manually.',
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 8),
                const SectionHeader(
                  title: 'Additional permissions',
                  subtitle:
                      'These cards cover gallery, microphone, and contacts so you can check status and request individual permissions.',
                ),
                const SizedBox(height: 12),
                for (final spec in _permissionSpecs.skip(1)) ...[
                  PermissionCard(
                    spec: spec,
                    status: _statuses[spec.permission],
                    onRequest: () => _requestPermission(spec),
                    onOpenSettings: () => _promptOpenSettings(
                      title: '${spec.title} settings',
                      message:
                          'Open settings to enable ${spec.title.toLowerCase()} manually.',
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 8),
                const SectionHeader(
                  title: 'Setup snapshot',
                  subtitle:
                      'The permission statuses below are only useful if the platform manifests and usage strings are configured correctly.',
                ),
                const SizedBox(height: 12),
                const SetupTile(
                  title: 'AndroidManifest.xml',
                  subtitle:
                      'Camera, location, contacts, microphone, and media permissions are declared at the manifest level.',
                  icon: Icons.android_outlined,
                ),
                const SizedBox(height: 12),
                const SetupTile(
                  title: 'iOS Info.plist + Podfile',
                  subtitle:
                      'Usage descriptions are added in Info.plist and the Podfile enables the permission_handler macros for iOS.',
                  icon: Icons.phone_iphone_outlined,
                ),
                const SizedBox(height: 24),
                Text(
                  'Supported flows: ${_permissionSpecs.map((spec) => spec.title).join(' • ')}',
                  style: TextStyle(color: Colors.white.withOpacity(0.62)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
