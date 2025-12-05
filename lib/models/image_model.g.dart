// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImageModelImpl _$$ImageModelImplFromJson(Map<String, dynamic> json) =>
    _$ImageModelImpl(
      downloadUrl: json['downloadUrl'] as String,
      storagePath: json['storagePath'] as String,
      uploadedAt: const TimestampConverter().fromJson(json['uploadedAt']),
    );

Map<String, dynamic> _$$ImageModelImplToJson(_$ImageModelImpl instance) =>
    <String, dynamic>{
      'downloadUrl': instance.downloadUrl,
      'storagePath': instance.storagePath,
      'uploadedAt': const TimestampConverter().toJson(instance.uploadedAt),
    };
