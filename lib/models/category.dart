import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

part 'category.g.dart';

const String collectionCategory = 'Categories';
const String categoryFieldId = 'id';
const String categoryFieldName = 'name';
const String categoryFieldProductCount = 'productCount';

@unfreezed
class Category with _$Category {
  factory Category({
    String? id,
    required String name,
    @Default(0) int productCount,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
