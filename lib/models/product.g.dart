// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String?,
      name: json['name'] as String,
      shortDescription: json['shortDescription'] as String?,
      longDescription: json['longDescription'] as String?,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      brandId: json['brandId'] as String,
      brandName: json['brandName'] as String,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      salePrice: (json['salePrice'] as num).toDouble(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'brandId': instance.brandId,
      'brandName': instance.brandName,
      'purchasePrice': instance.purchasePrice,
      'salePrice': instance.salePrice,
      'stock': instance.stock,
      'discount': instance.discount,
      'imageUrl': instance.imageUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
