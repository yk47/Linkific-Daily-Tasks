import 'package:top_5_packages_app/models/package_info.dart';

/// Static data about the top 5 Flutter packages
class PackageData {
  static final List<PackageInfo> topPackages = [
    PackageInfo(
      name: 'GetX',
      description:
          'A powerful high performance state management, dependency injection, and route management for Flutter.',
      version: '4.7.2',
      category: 'State Management',
      features: [
        'Reactive state management (Rx)',
        'Simple dependency injection',
        'Route management without context',
        'Built-in internationalization',
      ],
      githubUrl: 'https://github.com/jonataslaw/getx',
      documentationUrl: 'https://pub.dev/packages/get',
      isInstalled: true,
      popularityScore: 95.0,
    ),
    PackageInfo(
      name: 'Freezed',
      description:
          'Code generation for immutable data classes with union types and JSON serialization.',
      version: '2.5.8',
      category: 'Data Classes',
      features: [
        'Immutable data classes',
        'Union types (sealed classes)',
        'JSON serialization',
        'Pattern matching with when/whenOrNull',
      ],
      githubUrl: 'https://github.com/rrousselGit/freezed',
      documentationUrl: 'https://pub.dev/packages/freezed',
      isInstalled: true,
      popularityScore: 90.0,
    ),
    PackageInfo(
      name: 'GoRouter',
      description:
          'Declarative routing for Flutter with deep linking and typed routes.',
      version: '16.3.0',
      category: 'Navigation',
      features: [
        'Declarative routing',
        'Deep linking support',
        'Typed routes',
        'Redirect guards',
      ],
      githubUrl: 'https://github.com/flutter/packages',
      documentationUrl: 'https://pub.dev/packages/go_router',
      isInstalled: true,
      popularityScore: 88.0,
    ),
    PackageInfo(
      name: 'Dio',
      description:
          'A powerful HTTP client with interceptors, file downloads, and request cancellation.',
      version: '5.9.0',
      category: 'Networking',
      features: [
        'Interceptors (logging, auth, retry)',
        'Request cancellation',
        'File downloads with progress',
        'FormData support',
      ],
      githubUrl: 'https://github.com/cfug/dio',
      documentationUrl: 'https://pub.dev/packages/dio',
      isInstalled: true,
      popularityScore: 92.0,
    ),
    PackageInfo(
      name: 'Hive',
      description:
          'Fast, lightweight NoSQL database with no native dependencies.',
      version: '2.2.3',
      category: 'Storage',
      features: [
        'NoSQL key-value storage',
        'Fast read/write operations',
        'No native dependencies',
        'Type-safe with TypeAdapters',
      ],
      githubUrl: 'https://github.com/hivedb/hive',
      documentationUrl: 'https://pub.dev/packages/hive',
      isInstalled: true,
      popularityScore: 87.0,
    ),
  ];

  static final List<PackageInfo> utilityPackages = [
    PackageInfo(
      name: 'intl',
      description: 'Internationalization and localization utilities.',
      version: '0.20.2',
      category: 'Utility',
      features: ['Date formatting', 'Number formatting', 'Pluralization'],
      githubUrl: 'https://github.com/dart-lang/i18n',
      documentationUrl: 'https://pub.dev/packages/intl',
      isInstalled: true,
      popularityScore: 85.0,
    ),
    PackageInfo(
      name: 'url_launcher',
      description: 'Launch URLs in the browser or other apps.',
      version: '6.3.2',
      category: 'Utility',
      features: ['Open URLs', 'Make phone calls', 'Send emails'],
      githubUrl: 'https://github.com/flutter/packages',
      documentationUrl: 'https://pub.dev/packages/url_launcher',
      isInstalled: true,
      popularityScore: 88.0,
    ),
    PackageInfo(
      name: 'share_plus',
      description: 'Share content with other apps on the device.',
      version: '12.0.0',
      category: 'Utility',
      features: ['Share text', 'Share files', 'Share URLs'],
      githubUrl: 'https://github.com/fluttercommunity/plus_plugins',
      documentationUrl: 'https://pub.dev/packages/share_plus',
      isInstalled: true,
      popularityScore: 82.0,
    ),
    PackageInfo(
      name: 'connectivity_plus',
      description: 'Check network connectivity status.',
      version: '7.0.0',
      category: 'Utility',
      features: ['Network status', 'Real-time monitoring', 'WiFi/Mobile detection'],
      githubUrl: 'https://github.com/fluttercommunity/plus_plugins',
      documentationUrl: 'https://pub.dev/packages/connectivity_plus',
      isInstalled: true,
      popularityScore: 80.0,
    ),
  ];
}