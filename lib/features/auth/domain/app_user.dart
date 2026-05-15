import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    @Default('en') String locale,
    @Default('user') String role,
    @Default(false) bool emailVerified,
    @Default(false) bool premium,
    @Default(0.0) double superUserScore,
    @Default(SuperUserStats()) SuperUserStats superUserStats,
    @TimestampConverter() DateTime? superUserBecameAt,
    @TimestampConverter() DateTime? superUserScoreUpdatedAt,
    @Default(UserPreferences()) UserPreferences preferences,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

@freezed
class SuperUserStats with _$SuperUserStats {
  const factory SuperUserStats({
    @Default(0) int placesCount,
    @Default(0) int chatCount,
    @Default(0) int reviewsCount,
    @Default(0.0) double averageReviewRating,
  }) = _SuperUserStats;

  factory SuperUserStats.fromJson(Map<String, dynamic> json) =>
      _$SuperUserStatsFromJson(json);
}

@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default([]) List<String> placeTypes,
    @Default([]) List<String> moods,
    String? budget,
    String? pace,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
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
