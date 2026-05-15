// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(
  Map<String, dynamic> json,
) => _$AppUserImpl(
  uid: json['uid'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  photoUrl: json['photoUrl'] as String?,
  locale: json['locale'] as String? ?? 'en',
  role: json['role'] as String? ?? 'user',
  emailVerified: json['emailVerified'] as bool? ?? false,
  premium: json['premium'] as bool? ?? false,
  superUserScore: (json['superUserScore'] as num?)?.toDouble() ?? 0.0,
  superUserStats: json['superUserStats'] == null
      ? const SuperUserStats()
      : SuperUserStats.fromJson(json['superUserStats'] as Map<String, dynamic>),
  superUserBecameAt: const TimestampConverter().fromJson(
    json['superUserBecameAt'],
  ),
  superUserScoreUpdatedAt: const TimestampConverter().fromJson(
    json['superUserScoreUpdatedAt'],
  ),
  preferences: json['preferences'] == null
      ? const UserPreferences()
      : UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'locale': instance.locale,
      'role': instance.role,
      'emailVerified': instance.emailVerified,
      'premium': instance.premium,
      'superUserScore': instance.superUserScore,
      'superUserStats': instance.superUserStats,
      'superUserBecameAt': const TimestampConverter().toJson(
        instance.superUserBecameAt,
      ),
      'superUserScoreUpdatedAt': const TimestampConverter().toJson(
        instance.superUserScoreUpdatedAt,
      ),
      'preferences': instance.preferences,
    };

_$SuperUserStatsImpl _$$SuperUserStatsImplFromJson(Map<String, dynamic> json) =>
    _$SuperUserStatsImpl(
      placesCount: (json['placesCount'] as num?)?.toInt() ?? 0,
      chatCount: (json['chatCount'] as num?)?.toInt() ?? 0,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
      averageReviewRating:
          (json['averageReviewRating'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$SuperUserStatsImplToJson(
  _$SuperUserStatsImpl instance,
) => <String, dynamic>{
  'placesCount': instance.placesCount,
  'chatCount': instance.chatCount,
  'reviewsCount': instance.reviewsCount,
  'averageReviewRating': instance.averageReviewRating,
};

_$UserPreferencesImpl _$$UserPreferencesImplFromJson(
  Map<String, dynamic> json,
) => _$UserPreferencesImpl(
  placeTypes:
      (json['placeTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  moods:
      (json['moods'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  budget: json['budget'] as String?,
  pace: json['pace'] as String?,
);

Map<String, dynamic> _$$UserPreferencesImplToJson(
  _$UserPreferencesImpl instance,
) => <String, dynamic>{
  'placeTypes': instance.placeTypes,
  'moods': instance.moods,
  'budget': instance.budget,
  'pace': instance.pace,
};
