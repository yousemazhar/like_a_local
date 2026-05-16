import 'package:freezed_annotation/freezed_annotation.dart';

import '../../place/domain/place.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    required String placeId,
    required String authorUid,
    @Default('') String authorDisplayName,
    String? authorPhotoUrl,
    @Default(false) bool authorIsSuper,
    required int rating,
    @Default('') String text,
    @Default(<String>[]) List<String> photoUrls,
    @Default(<String>[]) List<String> videoUrls,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
