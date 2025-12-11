import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand.freezed.dart';

part 'brand.g.dart';

/// Firestore collection name for brand documents.
const String collectionBrand = 'Brands';

/// Firestore field name for the brand document id.
const String brandFieldId = 'id';

/// Firestore field name for the brand name.
const String brandFieldName = 'name';

/// Firestore field name for the total number of products under this brand.
const String brandFieldProductCount = 'productCount';

@unfreezed
class Brand with _$Brand {
  /// Model representing a product brand in the admin panel.
  ///
  /// [id] is the Firestore document id and may be null for newly created,
  /// unsaved instances. [productCount] tracks the total number of
  /// products associated with this brand.
  factory Brand({
    @JsonKey(name: brandFieldId) String? id,
    @JsonKey(name: brandFieldName) required String name,
    @JsonKey(name: brandFieldProductCount) @Default(0) int productCount,
  }) = _Brand;

  /// Create a [Brand] from a JSON map (Firestore document data).
  factory Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);
}
