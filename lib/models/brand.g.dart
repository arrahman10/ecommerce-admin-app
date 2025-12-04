// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BrandImpl _$$BrandImplFromJson(Map<String, dynamic> json) => _$BrandImpl(
  id: json['id'] as String?,
  name: json['name'] as String,
  productCount: (json['productCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$BrandImplToJson(_$BrandImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'productCount': instance.productCount,
    };
