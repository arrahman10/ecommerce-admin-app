import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

/// A [JsonConverter] that maps Firestore [Timestamp] values
/// to Dart [DateTime] and back.
///
/// This converter is used in Freezed data models to (de)serialize
/// Firestore date fields in a type-safe way.
class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  /// Convert a Firestore [Timestamp] (or `null`) to a Dart [DateTime].
  ///
  /// Throws [ArgumentError] if the provided value is not a [Timestamp] or `null`.
  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Timestamp) {
      return json.toDate();
    }
    throw ArgumentError('Invalid Timestamp value: $json');
  }

  /// Convert a Dart [DateTime] (or `null`) to a Firestore [Timestamp].
  @override
  Object? toJson(DateTime? dateTime) {
    if (dateTime == null) return null;
    return Timestamp.fromDate(dateTime);
  }
}
