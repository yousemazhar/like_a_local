import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

@freezed
class Place with _$Place {
  const factory Place({
    required String id,
    required String title,
    @Default('') String description,
    required String category,
    @Default([]) List<String> moods,
    String? priceLevel,
    @Default('') String city,
    @Default('') String neighborhood,
    @Default('') String address,
    @Default(0.0) double lat,
    @Default(0.0) double lng,
    @Default([]) List<PlaceTip> tips,
    @Default([]) List<PlaceDish> dishes,
    @Default([]) List<String> mediaUrls,
    @Default('') String ownerUid,
    @Default(false) bool ownerIsSuper,
    @Default(0.0) double ownerSuperScore,
    @Default(0.0) double ratingAvg,
    @Default(0) int ratingCount,
    @Default(0) int saveCount,
    @Default(false) bool featured,
    @Default(false) bool hidden,
    @TimestampConverter() DateTime? createdAt,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

@freezed
class PlaceTip with _$PlaceTip {
  const factory PlaceTip({required String text, required int order}) =
      _PlaceTip;

  factory PlaceTip.fromJson(Map<String, dynamic> json) =>
      _$PlaceTipFromJson(json);
}

@freezed
class PlaceDish with _$PlaceDish {
  const factory PlaceDish({required String name}) = _PlaceDish;

  factory PlaceDish.fromJson(Map<String, dynamic> json) =>
      _$PlaceDishFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const TimestampConverter();

  @override
  DateTime? fromJson(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  @override
  dynamic toJson(DateTime? date) =>
      date == null ? null : Timestamp.fromDate(date);
}
