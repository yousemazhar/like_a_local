// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      locale: json['locale'] as String? ?? 'en',
      role: json['role'] as String? ?? 'user',
      emailVerified: json['emailVerified'] as bool? ?? false,
      preferences: json['preferences'] == null
          ? const UserPreferences()
          : UserPreferences.fromJson(
              json['preferences'] as Map<String, dynamic>,
            ),
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
      'preferences': instance.preferences,
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
