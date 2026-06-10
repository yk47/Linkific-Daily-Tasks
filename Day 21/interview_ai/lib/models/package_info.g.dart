// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackageInfoImpl _$$PackageInfoImplFromJson(Map<String, dynamic> json) =>
    _$PackageInfoImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      version: json['version'] as String,
      category: json['category'] as String,
      features: (json['features'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      githubUrl: json['githubUrl'] as String,
      documentationUrl: json['documentationUrl'] as String,
      isInstalled: json['isInstalled'] as bool? ?? false,
      popularityScore: (json['popularityScore'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$PackageInfoImplToJson(_$PackageInfoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'version': instance.version,
      'category': instance.category,
      'features': instance.features,
      'githubUrl': instance.githubUrl,
      'documentationUrl': instance.documentationUrl,
      'isInstalled': instance.isInstalled,
      'popularityScore': instance.popularityScore,
    };
