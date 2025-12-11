import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ecommerce_admin_app/utils/timestamp_converter.dart';

part 'image_model.freezed.dart';

part 'image_model.g.dart';

/// Value object representing a single image stored in Firebase Storage.
///
/// This model is used for both main product images and additional images.
/// It keeps track of the public [downloadUrl], the Storage [storagePath],
/// and an optional [uploadedAt] timestamp.
@freezed
class ImageModel with _$ImageModel {
  /// HTTP or HTTPS URL that can be used to download or display the image.
  const factory ImageModel({
    required String downloadUrl,

    /// Full Firebase Storage path where this image file is stored.
    required String storagePath,

    /// Timestamp when the file was uploaded to storage (in UTC).
    @TimestampConverter() DateTime? uploadedAt,
  }) = _ImageModel;

  /// Create an [ImageModel] instance from a Firestore JSON map.
  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);
}
