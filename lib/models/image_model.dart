import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ecommerce_admin_app/utils/timestamp_converter.dart';

part 'image_model.freezed.dart';

part 'image_model.g.dart';

@freezed
class ImageModel with _$ImageModel {
  const factory ImageModel({
    required String downloadUrl,

    required String storagePath,

    @TimestampConverter() DateTime? uploadedAt,
  }) = _ImageModel;

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);
}
