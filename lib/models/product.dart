import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ecommerce_admin_app/utils/timestamp_converter.dart';

part 'product.freezed.dart';

part 'product.g.dart';

// ================== Collection & field names ==================

/// Firestore collection name for product documents.
const String collectionProduct = 'Products';

/// Firestore field name for the product id.
const String productFieldId = 'id';

/// Firestore field name for the main product image URL.
const String productFieldImageUrl = 'imageUrl';

/// Firestore field name for the thumbnail image URL.
const String productFieldThumbnailUrl = 'thumbnailUrl';

/// Firestore field name for the product purchase date.
const String productFieldPurchaseDate = 'purchaseDate';

/// Firestore field name for the category document id.
const String productFieldCategoryId = 'categoryId';

/// Firestore field name for the category display name.
const String productFieldCategoryName = 'categoryName';

/// Firestore field name for the brand document id.
const String productFieldBrandId = 'brandId';

/// Firestore field name for the brand display name.
const String productFieldBrandName = 'brandName';

/// Firestore field name for the product name.
const String productFieldName = 'name';

/// Firestore field name for the short description.
const String productFieldShortDescription = 'shortDescription';

/// Firestore field name for the long description.
const String productFieldLongDescription = 'longDescription';

/// Firestore field name for the purchase price per unit.
const String productFieldPurchasePrice = 'purchasePrice';

/// Firestore field name for the sale price per unit.
const String productFieldSalePrice = 'salePrice';

/// Firestore field name for the stock quantity.
const String productFieldStock = 'stock';

/// Firestore field name for the discount percentage.
const String productFieldDiscount = 'discount';

/// Firestore field name indicating whether the product is available.
const String productFieldAvailable = 'available';

/// Firestore field name indicating whether the product is featured.
const String productFieldFeatured = 'featured';

/// Firestore field name for the product creation timestamp.
const String productFieldCreatedAt = 'createdAt';

// ================== Product model ==================

/// Immutable product model stored in the [collectionProduct] Firestore
/// collection. All field names are aligned with the constants above to
/// keep Firestore schema and client code in sync.
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

    @JsonKey(name: productFieldAvailable) @Default(true) bool available,
    @JsonKey(name: productFieldFeatured) @Default(false) bool featured,

    @TimestampConverter()
    @JsonKey(name: productFieldCreatedAt)
    DateTime? createdAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
