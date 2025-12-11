import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

part 'category.g.dart';

/// Firestore collection name for category documents.
const String collectionCategory = 'Categories';

/// Firestore field name for the category document id.
const String categoryFieldId = 'id';

/// Firestore field name for the category name.
const String categoryFieldName = 'name';

/// Firestore field name for the total number of products in this category.
const String categoryFieldProductCount = 'productCount';

@unfreezed
class Category with _$Category {
  /// Model representing a product category in the admin panel.
  ///
  /// [id] is the Firestore document id and may be null for newly created,
  /// unsaved instances. [productCount] tracks how many products belong
  /// to this category.
  factory Category({
    @JsonKey(name: categoryFieldId) String? id,
    @JsonKey(name: categoryFieldName) required String name,
    @JsonKey(name: categoryFieldProductCount) @Default(0) int productCount,
  }) = _Category;

  /// Create a [Category] from a JSON map (Firestore document data).
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
