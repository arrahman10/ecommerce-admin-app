// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  @JsonKey(name: productFieldId)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldImageUrl)
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldThumbnailUrl)
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  @TimestampConverter()
  @JsonKey(name: productFieldPurchaseDate)
  DateTime? get purchaseDate => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldCategoryId)
  String get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldCategoryName)
  String get categoryName => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldBrandId)
  String get brandId => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldBrandName)
  String get brandName => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldName)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldShortDescription)
  String? get shortDescription => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldLongDescription)
  String? get longDescription => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldPurchasePrice)
  double get purchasePrice => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldSalePrice)
  double get salePrice => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldStock)
  int get stock => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldDiscount)
  double get discount => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldAvailable)
  bool get available => throw _privateConstructorUsedError;
  @JsonKey(name: productFieldFeatured)
  bool get featured => throw _privateConstructorUsedError;
  @TimestampConverter()
  @JsonKey(name: productFieldCreatedAt)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call({
    @JsonKey(name: productFieldId) String? id,
    @JsonKey(name: productFieldImageUrl) String? imageUrl,
    @JsonKey(name: productFieldThumbnailUrl) String? thumbnailUrl,
    @TimestampConverter()
    @JsonKey(name: productFieldPurchaseDate)
    DateTime? purchaseDate,
    @JsonKey(name: productFieldCategoryId) String categoryId,
    @JsonKey(name: productFieldCategoryName) String categoryName,
    @JsonKey(name: productFieldBrandId) String brandId,
    @JsonKey(name: productFieldBrandName) String brandName,
    @JsonKey(name: productFieldName) String name,
    @JsonKey(name: productFieldShortDescription) String? shortDescription,
    @JsonKey(name: productFieldLongDescription) String? longDescription,
    @JsonKey(name: productFieldPurchasePrice) double purchasePrice,
    @JsonKey(name: productFieldSalePrice) double salePrice,
    @JsonKey(name: productFieldStock) int stock,
    @JsonKey(name: productFieldDiscount) double discount,
    @JsonKey(name: productFieldAvailable) bool available,
    @JsonKey(name: productFieldFeatured) bool featured,
    @TimestampConverter()
    @JsonKey(name: productFieldCreatedAt)
    DateTime? createdAt,
  });
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? imageUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? purchaseDate = freezed,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? brandId = null,
    Object? brandName = null,
    Object? name = null,
    Object? shortDescription = freezed,
    Object? longDescription = freezed,
    Object? purchasePrice = null,
    Object? salePrice = null,
    Object? stock = null,
    Object? discount = null,
    Object? available = null,
    Object? featured = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            purchaseDate: freezed == purchaseDate
                ? _value.purchaseDate
                : purchaseDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryName: null == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String,
            brandId: null == brandId
                ? _value.brandId
                : brandId // ignore: cast_nullable_to_non_nullable
                      as String,
            brandName: null == brandName
                ? _value.brandName
                : brandName // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            shortDescription: freezed == shortDescription
                ? _value.shortDescription
                : shortDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            longDescription: freezed == longDescription
                ? _value.longDescription
                : longDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            purchasePrice: null == purchasePrice
                ? _value.purchasePrice
                : purchasePrice // ignore: cast_nullable_to_non_nullable
                      as double,
            salePrice: null == salePrice
                ? _value.salePrice
                : salePrice // ignore: cast_nullable_to_non_nullable
                      as double,
            stock: null == stock
                ? _value.stock
                : stock // ignore: cast_nullable_to_non_nullable
                      as int,
            discount: null == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                      as double,
            available: null == available
                ? _value.available
                : available // ignore: cast_nullable_to_non_nullable
                      as bool,
            featured: null == featured
                ? _value.featured
                : featured // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
    _$ProductImpl value,
    $Res Function(_$ProductImpl) then,
  ) = __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: productFieldId) String? id,
    @JsonKey(name: productFieldImageUrl) String? imageUrl,
    @JsonKey(name: productFieldThumbnailUrl) String? thumbnailUrl,
    @TimestampConverter()
    @JsonKey(name: productFieldPurchaseDate)
    DateTime? purchaseDate,
    @JsonKey(name: productFieldCategoryId) String categoryId,
    @JsonKey(name: productFieldCategoryName) String categoryName,
    @JsonKey(name: productFieldBrandId) String brandId,
    @JsonKey(name: productFieldBrandName) String brandName,
    @JsonKey(name: productFieldName) String name,
    @JsonKey(name: productFieldShortDescription) String? shortDescription,
    @JsonKey(name: productFieldLongDescription) String? longDescription,
    @JsonKey(name: productFieldPurchasePrice) double purchasePrice,
    @JsonKey(name: productFieldSalePrice) double salePrice,
    @JsonKey(name: productFieldStock) int stock,
    @JsonKey(name: productFieldDiscount) double discount,
    @JsonKey(name: productFieldAvailable) bool available,
    @JsonKey(name: productFieldFeatured) bool featured,
    @TimestampConverter()
    @JsonKey(name: productFieldCreatedAt)
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
    _$ProductImpl _value,
    $Res Function(_$ProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? imageUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? purchaseDate = freezed,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? brandId = null,
    Object? brandName = null,
    Object? name = null,
    Object? shortDescription = freezed,
    Object? longDescription = freezed,
    Object? purchasePrice = null,
    Object? salePrice = null,
    Object? stock = null,
    Object? discount = null,
    Object? available = null,
    Object? featured = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ProductImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        purchaseDate: freezed == purchaseDate
            ? _value.purchaseDate
            : purchaseDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryName: null == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String,
        brandId: null == brandId
            ? _value.brandId
            : brandId // ignore: cast_nullable_to_non_nullable
                  as String,
        brandName: null == brandName
            ? _value.brandName
            : brandName // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        shortDescription: freezed == shortDescription
            ? _value.shortDescription
            : shortDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        longDescription: freezed == longDescription
            ? _value.longDescription
            : longDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        purchasePrice: null == purchasePrice
            ? _value.purchasePrice
            : purchasePrice // ignore: cast_nullable_to_non_nullable
                  as double,
        salePrice: null == salePrice
            ? _value.salePrice
            : salePrice // ignore: cast_nullable_to_non_nullable
                  as double,
        stock: null == stock
            ? _value.stock
            : stock // ignore: cast_nullable_to_non_nullable
                  as int,
        discount: null == discount
            ? _value.discount
            : discount // ignore: cast_nullable_to_non_nullable
                  as double,
        available: null == available
            ? _value.available
            : available // ignore: cast_nullable_to_non_nullable
                  as bool,
        featured: null == featured
            ? _value.featured
            : featured // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl implements _Product {
  const _$ProductImpl({
    @JsonKey(name: productFieldId) this.id,
    @JsonKey(name: productFieldImageUrl) this.imageUrl,
    @JsonKey(name: productFieldThumbnailUrl) this.thumbnailUrl,
    @TimestampConverter()
    @JsonKey(name: productFieldPurchaseDate)
    this.purchaseDate,
    @JsonKey(name: productFieldCategoryId) required this.categoryId,
    @JsonKey(name: productFieldCategoryName) required this.categoryName,
    @JsonKey(name: productFieldBrandId) required this.brandId,
    @JsonKey(name: productFieldBrandName) required this.brandName,
    @JsonKey(name: productFieldName) required this.name,
    @JsonKey(name: productFieldShortDescription) this.shortDescription,
    @JsonKey(name: productFieldLongDescription) this.longDescription,
    @JsonKey(name: productFieldPurchasePrice) required this.purchasePrice,
    @JsonKey(name: productFieldSalePrice) required this.salePrice,
    @JsonKey(name: productFieldStock) this.stock = 0,
    @JsonKey(name: productFieldDiscount) this.discount = 0.0,
    @JsonKey(name: productFieldAvailable) this.available = true,
    @JsonKey(name: productFieldFeatured) this.featured = false,
    @TimestampConverter() @JsonKey(name: productFieldCreatedAt) this.createdAt,
  });

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  @JsonKey(name: productFieldId)
  final String? id;
  @override
  @JsonKey(name: productFieldImageUrl)
  final String? imageUrl;
  @override
  @JsonKey(name: productFieldThumbnailUrl)
  final String? thumbnailUrl;
  @override
  @TimestampConverter()
  @JsonKey(name: productFieldPurchaseDate)
  final DateTime? purchaseDate;
  @override
  @JsonKey(name: productFieldCategoryId)
  final String categoryId;
  @override
  @JsonKey(name: productFieldCategoryName)
  final String categoryName;
  @override
  @JsonKey(name: productFieldBrandId)
  final String brandId;
  @override
  @JsonKey(name: productFieldBrandName)
  final String brandName;
  @override
  @JsonKey(name: productFieldName)
  final String name;
  @override
  @JsonKey(name: productFieldShortDescription)
  final String? shortDescription;
  @override
  @JsonKey(name: productFieldLongDescription)
  final String? longDescription;
  @override
  @JsonKey(name: productFieldPurchasePrice)
  final double purchasePrice;
  @override
  @JsonKey(name: productFieldSalePrice)
  final double salePrice;
  @override
  @JsonKey(name: productFieldStock)
  final int stock;
  @override
  @JsonKey(name: productFieldDiscount)
  final double discount;
  @override
  @JsonKey(name: productFieldAvailable)
  final bool available;
  @override
  @JsonKey(name: productFieldFeatured)
  final bool featured;
  @override
  @TimestampConverter()
  @JsonKey(name: productFieldCreatedAt)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Product(id: $id, imageUrl: $imageUrl, thumbnailUrl: $thumbnailUrl, purchaseDate: $purchaseDate, categoryId: $categoryId, categoryName: $categoryName, brandId: $brandId, brandName: $brandName, name: $name, shortDescription: $shortDescription, longDescription: $longDescription, purchasePrice: $purchasePrice, salePrice: $salePrice, stock: $stock, discount: $discount, available: $available, featured: $featured, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.brandId, brandId) || other.brandId == brandId) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.longDescription, longDescription) ||
                other.longDescription == longDescription) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.available, available) ||
                other.available == available) &&
            (identical(other.featured, featured) ||
                other.featured == featured) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    imageUrl,
    thumbnailUrl,
    purchaseDate,
    categoryId,
    categoryName,
    brandId,
    brandName,
    name,
    shortDescription,
    longDescription,
    purchasePrice,
    salePrice,
    stock,
    discount,
    available,
    featured,
    createdAt,
  );

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(this);
  }
}

abstract class _Product implements Product {
  const factory _Product({
    @JsonKey(name: productFieldId) final String? id,
    @JsonKey(name: productFieldImageUrl) final String? imageUrl,
    @JsonKey(name: productFieldThumbnailUrl) final String? thumbnailUrl,
    @TimestampConverter()
    @JsonKey(name: productFieldPurchaseDate)
    final DateTime? purchaseDate,
    @JsonKey(name: productFieldCategoryId) required final String categoryId,
    @JsonKey(name: productFieldCategoryName) required final String categoryName,
    @JsonKey(name: productFieldBrandId) required final String brandId,
    @JsonKey(name: productFieldBrandName) required final String brandName,
    @JsonKey(name: productFieldName) required final String name,
    @JsonKey(name: productFieldShortDescription) final String? shortDescription,
    @JsonKey(name: productFieldLongDescription) final String? longDescription,
    @JsonKey(name: productFieldPurchasePrice)
    required final double purchasePrice,
    @JsonKey(name: productFieldSalePrice) required final double salePrice,
    @JsonKey(name: productFieldStock) final int stock,
    @JsonKey(name: productFieldDiscount) final double discount,
    @JsonKey(name: productFieldAvailable) final bool available,
    @JsonKey(name: productFieldFeatured) final bool featured,
    @TimestampConverter()
    @JsonKey(name: productFieldCreatedAt)
    final DateTime? createdAt,
  }) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  @JsonKey(name: productFieldId)
  String? get id;
  @override
  @JsonKey(name: productFieldImageUrl)
  String? get imageUrl;
  @override
  @JsonKey(name: productFieldThumbnailUrl)
  String? get thumbnailUrl;
  @override
  @TimestampConverter()
  @JsonKey(name: productFieldPurchaseDate)
  DateTime? get purchaseDate;
  @override
  @JsonKey(name: productFieldCategoryId)
  String get categoryId;
  @override
  @JsonKey(name: productFieldCategoryName)
  String get categoryName;
  @override
  @JsonKey(name: productFieldBrandId)
  String get brandId;
  @override
  @JsonKey(name: productFieldBrandName)
  String get brandName;
  @override
  @JsonKey(name: productFieldName)
  String get name;
  @override
  @JsonKey(name: productFieldShortDescription)
  String? get shortDescription;
  @override
  @JsonKey(name: productFieldLongDescription)
  String? get longDescription;
  @override
  @JsonKey(name: productFieldPurchasePrice)
  double get purchasePrice;
  @override
  @JsonKey(name: productFieldSalePrice)
  double get salePrice;
  @override
  @JsonKey(name: productFieldStock)
  int get stock;
  @override
  @JsonKey(name: productFieldDiscount)
  double get discount;
  @override
  @JsonKey(name: productFieldAvailable)
  bool get available;
  @override
  @JsonKey(name: productFieldFeatured)
  bool get featured;
  @override
  @TimestampConverter()
  @JsonKey(name: productFieldCreatedAt)
  DateTime? get createdAt;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
