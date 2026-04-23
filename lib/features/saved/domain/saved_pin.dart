import 'package:freezed_annotation/freezed_annotation.dart';

import '../../place/domain/place.dart';

part 'saved_pin.freezed.dart';
part 'saved_pin.g.dart';

@freezed
class SavedPin with _$SavedPin {
  const factory SavedPin({
    required String placeId,
    String? collectionId,
    String? note,
    @TimestampConverter() DateTime? pinnedAt,
  }) = _SavedPin;

  factory SavedPin.fromJson(Map<String, dynamic> json) =>
      _$SavedPinFromJson(json);
}

@freezed
class SavedCollection with _$SavedCollection {
  const factory SavedCollection({
    required String id,
    required String name,
    String? coverPlaceId,
    @Default(0) int count,
    @Default(false) bool isPinned,
    @TimestampConverter() DateTime? createdAt,
  }) = _SavedCollection;

  factory SavedCollection.fromJson(Map<String, dynamic> json) =>
      _$SavedCollectionFromJson(json);
}
