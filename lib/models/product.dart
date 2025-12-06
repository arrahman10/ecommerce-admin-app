import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ecommerce_admin_app/utils/timestamp_converter.dart';

part 'product.freezed.dart';

part 'product.g.dart';

const String collectionProduct = 'Products';

const String productFieldId = 'id';
const String productFieldImageUrl = 'imageUrl';
const String productFieldThumbnailUrl = 'thumbnailUrl';
const String productFieldPurchaseDate = 'purchaseDate';
const String productFieldCategoryId = 'categoryId';
const String productFieldCategoryName = 'categoryName';
const String productFieldBrandId = 'brandId';
const String productFieldBrandName = 'brandName';
const String productFieldName = 'name';
const String productFieldShortDescription = 'shortDescription';
const String productFieldLongDescription = 'longDescription';
const String productFieldPurchasePrice = 'purchasePrice';
const String productFieldSalePrice = 'salePrice';
const String productFieldStock = 'stock';
const String productFieldDiscount = 'discount';
const String productFieldCreatedAt = 'createdAt';

@freezed
class Product with _$Product {
  const factory Product({
    @JsonKey(name: productFieldId) String? id,
    @JsonKey(name: productFieldImageUrl) String? imageUrl,
    @JsonKey(name: productFieldThumbnailUrl) String? thumbnailUrl,

    @TimestampConverter()
    @JsonKey(name: productFieldPurchaseDate)
    DateTime? purchaseDate,

    @JsonKey(name: productFieldCategoryId) required String categoryId,
    @JsonKey(name: productFieldCategoryName) required String categoryName,
    @JsonKey(name: productFieldBrandId) required String brandId,
    @JsonKey(name: productFieldBrandName) required String brandName,
    @JsonKey(name: productFieldName) required String name,
    @JsonKey(name: productFieldShortDescription) String? shortDescription,
    @JsonKey(name: productFieldLongDescription) String? longDescription,
    @JsonKey(name: productFieldPurchasePrice) required double purchasePrice,
    @JsonKey(name: productFieldSalePrice) required double salePrice,
    @JsonKey(name: productFieldStock) @Default(0) int stock,
    @JsonKey(name: productFieldDiscount) @Default(0.0) double discount,

    @TimestampConverter()
    @JsonKey(name: productFieldCreatedAt)
    DateTime? createdAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
