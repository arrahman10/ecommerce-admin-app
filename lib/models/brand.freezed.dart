// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brand.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Brand _$BrandFromJson(Map<String, dynamic> json) {
  return _Brand.fromJson(json);
}

/// @nodoc
mixin _$Brand {
  @JsonKey(name: brandFieldId)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: brandFieldId)
  set id(String? value) => throw _privateConstructorUsedError;
  @JsonKey(name: brandFieldName)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: brandFieldName)
  set name(String value) => throw _privateConstructorUsedError;
  @JsonKey(name: brandFieldProductCount)
  int get productCount => throw _privateConstructorUsedError;
  @JsonKey(name: brandFieldProductCount)
  set productCount(int value) => throw _privateConstructorUsedError;

  /// Serializes this Brand to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Brand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BrandCopyWith<Brand> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrandCopyWith<$Res> {
  factory $BrandCopyWith(Brand value, $Res Function(Brand) then) =
      _$BrandCopyWithImpl<$Res, Brand>;
  @useResult
  $Res call({
    @JsonKey(name: brandFieldId) String? id,
    @JsonKey(name: brandFieldName) String name,
    @JsonKey(name: brandFieldProductCount) int productCount,
  });
}

/// @nodoc
class _$BrandCopyWithImpl<$Res, $Val extends Brand>
    implements $BrandCopyWith<$Res> {
  _$BrandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Brand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? productCount = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            productCount: null == productCount
                ? _value.productCount
                : productCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BrandImplCopyWith<$Res> implements $BrandCopyWith<$Res> {
  factory _$$BrandImplCopyWith(
    _$BrandImpl value,
    $Res Function(_$BrandImpl) then,
  ) = __$$BrandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: brandFieldId) String? id,
    @JsonKey(name: brandFieldName) String name,
    @JsonKey(name: brandFieldProductCount) int productCount,
  });
}

/// @nodoc
class __$$BrandImplCopyWithImpl<$Res>
    extends _$BrandCopyWithImpl<$Res, _$BrandImpl>
    implements _$$BrandImplCopyWith<$Res> {
  __$$BrandImplCopyWithImpl(
    _$BrandImpl _value,
    $Res Function(_$BrandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Brand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? productCount = null,
  }) {
    return _then(
      _$BrandImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        productCount: null == productCount
            ? _value.productCount
            : productCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BrandImpl implements _Brand {
  _$BrandImpl({
    @JsonKey(name: brandFieldId) this.id,
    @JsonKey(name: brandFieldName) required this.name,
    @JsonKey(name: brandFieldProductCount) this.productCount = 0,
  });

  factory _$BrandImpl.fromJson(Map<String, dynamic> json) =>
      _$$BrandImplFromJson(json);

  @override
  @JsonKey(name: brandFieldId)
  String? id;
  @override
  @JsonKey(name: brandFieldName)
  String name;
  @override
  @JsonKey(name: brandFieldProductCount)
  int productCount;

  @override
  String toString() {
    return 'Brand(id: $id, name: $name, productCount: $productCount)';
  }

  /// Create a copy of Brand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BrandImplCopyWith<_$BrandImpl> get copyWith =>
      __$$BrandImplCopyWithImpl<_$BrandImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BrandImplToJson(this);
  }
}

abstract class _Brand implements Brand {
  factory _Brand({
    @JsonKey(name: brandFieldId) String? id,
    @JsonKey(name: brandFieldName) required String name,
    @JsonKey(name: brandFieldProductCount) int productCount,
  }) = _$BrandImpl;

  factory _Brand.fromJson(Map<String, dynamic> json) = _$BrandImpl.fromJson;

  @override
  @JsonKey(name: brandFieldId)
  String? get id;
  @JsonKey(name: brandFieldId)
  set id(String? value);
  @override
  @JsonKey(name: brandFieldName)
  String get name;
  @JsonKey(name: brandFieldName)
  set name(String value);
  @override
  @JsonKey(name: brandFieldProductCount)
  int get productCount;
  @JsonKey(name: brandFieldProductCount)
  set productCount(int value);

  /// Create a copy of Brand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrandImplCopyWith<_$BrandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
