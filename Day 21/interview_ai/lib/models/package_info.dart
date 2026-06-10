import 'package:freezed_annotation/freezed_annotation.dart';

part 'package_info.freezed.dart';
part 'package_info.g.dart';

/// Freezed model demonstrating immutable data classes with union types
@freezed
class PackageInfo with _$PackageInfo {
  const factory PackageInfo({
    required String name,
    required String description,
    required String version,
    required String category,
    required List<String> features,
    required String githubUrl,
    required String documentationUrl,
    @Default(false) bool isInstalled,
    @Default(0.0) double popularityScore,
  }) = _PackageInfo;

  factory PackageInfo.fromJson(Map<String, dynamic> json) =>
      _$PackageInfoFromJson(json);
}

/// Union type demonstration with Freezed
@freezed
class PackageCategory with _$PackageCategory {
  const factory PackageCategory.stateManagement() = StateManagement;
  const factory PackageCategory.dataClasses() = DataClasses;
  const factory PackageCategory.navigation() = Navigation;
  const factory PackageCategory.networking() = Networking;
  const factory PackageCategory.storage() = Storage;
  const factory PackageCategory.utility() = Utility;
}

/// API response state union type
@freezed
class ApiResponseState with _$ApiResponseState {
  const factory ApiResponseState.initial() = Initial;
  const factory ApiResponseState.loading() = Loading;
  const factory ApiResponseState.success(Map<String, dynamic> data) = Success;
  const factory ApiResponseState.error(String message) = ApiError;
}