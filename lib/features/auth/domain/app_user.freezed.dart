// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return _AppUser.fromJson(json);
}

/// @nodoc
mixin _$AppUser {
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  bool get emailVerified => throw _privateConstructorUsedError;
  bool get premium => throw _privateConstructorUsedError;
  double get superUserScore => throw _privateConstructorUsedError;
  SuperUserStats get superUserStats => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get superUserBecameAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get superUserScoreUpdatedAt => throw _privateConstructorUsedError;
  UserPreferences get preferences => throw _privateConstructorUsedError;

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUserCopyWith<AppUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) then) =
      _$AppUserCopyWithImpl<$Res, AppUser>;
  @useResult
  $Res call({
    String uid,
    String email,
    String? displayName,
    String? photoUrl,
    String locale,
    String role,
    bool emailVerified,
    bool premium,
    double superUserScore,
    SuperUserStats superUserStats,
    @TimestampConverter() DateTime? superUserBecameAt,
    @TimestampConverter() DateTime? superUserScoreUpdatedAt,
    UserPreferences preferences,
  });

  $SuperUserStatsCopyWith<$Res> get superUserStats;
  $UserPreferencesCopyWith<$Res> get preferences;
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res, $Val extends AppUser>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? locale = null,
    Object? role = null,
    Object? emailVerified = null,
    Object? premium = null,
    Object? superUserScore = null,
    Object? superUserStats = null,
    Object? superUserBecameAt = freezed,
    Object? superUserScoreUpdatedAt = freezed,
    Object? preferences = null,
  }) {
    return _then(
      _value.copyWith(
            uid: null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            locale: null == locale
                ? _value.locale
                : locale // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            emailVerified: null == emailVerified
                ? _value.emailVerified
                : emailVerified // ignore: cast_nullable_to_non_nullable
                      as bool,
            premium: null == premium
                ? _value.premium
                : premium // ignore: cast_nullable_to_non_nullable
                      as bool,
            superUserScore: null == superUserScore
                ? _value.superUserScore
                : superUserScore // ignore: cast_nullable_to_non_nullable
                      as double,
            superUserStats: null == superUserStats
                ? _value.superUserStats
                : superUserStats // ignore: cast_nullable_to_non_nullable
                      as SuperUserStats,
            superUserBecameAt: freezed == superUserBecameAt
                ? _value.superUserBecameAt
                : superUserBecameAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            superUserScoreUpdatedAt: freezed == superUserScoreUpdatedAt
                ? _value.superUserScoreUpdatedAt
                : superUserScoreUpdatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            preferences: null == preferences
                ? _value.preferences
                : preferences // ignore: cast_nullable_to_non_nullable
                      as UserPreferences,
          )
          as $Val,
    );
  }

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SuperUserStatsCopyWith<$Res> get superUserStats {
    return $SuperUserStatsCopyWith<$Res>(_value.superUserStats, (value) {
      return _then(_value.copyWith(superUserStats: value) as $Val);
    });
  }

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserPreferencesCopyWith<$Res> get preferences {
    return $UserPreferencesCopyWith<$Res>(_value.preferences, (value) {
      return _then(_value.copyWith(preferences: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppUserImplCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$$AppUserImplCopyWith(
    _$AppUserImpl value,
    $Res Function(_$AppUserImpl) then,
  ) = __$$AppUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uid,
    String email,
    String? displayName,
    String? photoUrl,
    String locale,
    String role,
    bool emailVerified,
    bool premium,
    double superUserScore,
    SuperUserStats superUserStats,
    @TimestampConverter() DateTime? superUserBecameAt,
    @TimestampConverter() DateTime? superUserScoreUpdatedAt,
    UserPreferences preferences,
  });

  @override
  $SuperUserStatsCopyWith<$Res> get superUserStats;
  @override
  $UserPreferencesCopyWith<$Res> get preferences;
}

/// @nodoc
class __$$AppUserImplCopyWithImpl<$Res>
    extends _$AppUserCopyWithImpl<$Res, _$AppUserImpl>
    implements _$$AppUserImplCopyWith<$Res> {
  __$$AppUserImplCopyWithImpl(
    _$AppUserImpl _value,
    $Res Function(_$AppUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? locale = null,
    Object? role = null,
    Object? emailVerified = null,
    Object? premium = null,
    Object? superUserScore = null,
    Object? superUserStats = null,
    Object? superUserBecameAt = freezed,
    Object? superUserScoreUpdatedAt = freezed,
    Object? preferences = null,
  }) {
    return _then(
      _$AppUserImpl(
        uid: null == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        locale: null == locale
            ? _value.locale
            : locale // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        emailVerified: null == emailVerified
            ? _value.emailVerified
            : emailVerified // ignore: cast_nullable_to_non_nullable
                  as bool,
        premium: null == premium
            ? _value.premium
            : premium // ignore: cast_nullable_to_non_nullable
                  as bool,
        superUserScore: null == superUserScore
            ? _value.superUserScore
            : superUserScore // ignore: cast_nullable_to_non_nullable
                  as double,
        superUserStats: null == superUserStats
            ? _value.superUserStats
            : superUserStats // ignore: cast_nullable_to_non_nullable
                  as SuperUserStats,
        superUserBecameAt: freezed == superUserBecameAt
            ? _value.superUserBecameAt
            : superUserBecameAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        superUserScoreUpdatedAt: freezed == superUserScoreUpdatedAt
            ? _value.superUserScoreUpdatedAt
            : superUserScoreUpdatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        preferences: null == preferences
            ? _value.preferences
            : preferences // ignore: cast_nullable_to_non_nullable
                  as UserPreferences,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppUserImpl implements _AppUser {
  const _$AppUserImpl({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.locale = 'en',
    this.role = 'user',
    this.emailVerified = false,
    this.premium = false,
    this.superUserScore = 0.0,
    this.superUserStats = const SuperUserStats(),
    @TimestampConverter() this.superUserBecameAt,
    @TimestampConverter() this.superUserScoreUpdatedAt,
    this.preferences = const UserPreferences(),
  });

  factory _$AppUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppUserImplFromJson(json);

  @override
  final String uid;
  @override
  final String email;
  @override
  final String? displayName;
  @override
  final String? photoUrl;
  @override
  @JsonKey()
  final String locale;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey()
  final bool emailVerified;
  @override
  @JsonKey()
  final bool premium;
  @override
  @JsonKey()
  final double superUserScore;
  @override
  @JsonKey()
  final SuperUserStats superUserStats;
  @override
  @TimestampConverter()
  final DateTime? superUserBecameAt;
  @override
  @TimestampConverter()
  final DateTime? superUserScoreUpdatedAt;
  @override
  @JsonKey()
  final UserPreferences preferences;

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl, locale: $locale, role: $role, emailVerified: $emailVerified, premium: $premium, superUserScore: $superUserScore, superUserStats: $superUserStats, superUserBecameAt: $superUserBecameAt, superUserScoreUpdatedAt: $superUserScoreUpdatedAt, preferences: $preferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.premium, premium) || other.premium == premium) &&
            (identical(other.superUserScore, superUserScore) ||
                other.superUserScore == superUserScore) &&
            (identical(other.superUserStats, superUserStats) ||
                other.superUserStats == superUserStats) &&
            (identical(other.superUserBecameAt, superUserBecameAt) ||
                other.superUserBecameAt == superUserBecameAt) &&
            (identical(
                  other.superUserScoreUpdatedAt,
                  superUserScoreUpdatedAt,
                ) ||
                other.superUserScoreUpdatedAt == superUserScoreUpdatedAt) &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    email,
    displayName,
    photoUrl,
    locale,
    role,
    emailVerified,
    premium,
    superUserScore,
    superUserStats,
    superUserBecameAt,
    superUserScoreUpdatedAt,
    preferences,
  );

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      __$$AppUserImplCopyWithImpl<_$AppUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppUserImplToJson(this);
  }
}

abstract class _AppUser implements AppUser {
  const factory _AppUser({
    required final String uid,
    required final String email,
    final String? displayName,
    final String? photoUrl,
    final String locale,
    final String role,
    final bool emailVerified,
    final bool premium,
    final double superUserScore,
    final SuperUserStats superUserStats,
    @TimestampConverter() final DateTime? superUserBecameAt,
    @TimestampConverter() final DateTime? superUserScoreUpdatedAt,
    final UserPreferences preferences,
  }) = _$AppUserImpl;

  factory _AppUser.fromJson(Map<String, dynamic> json) = _$AppUserImpl.fromJson;

  @override
  String get uid;
  @override
  String get email;
  @override
  String? get displayName;
  @override
  String? get photoUrl;
  @override
  String get locale;
  @override
  String get role;
  @override
  bool get emailVerified;
  @override
  bool get premium;
  @override
  double get superUserScore;
  @override
  SuperUserStats get superUserStats;
  @override
  @TimestampConverter()
  DateTime? get superUserBecameAt;
  @override
  @TimestampConverter()
  DateTime? get superUserScoreUpdatedAt;
  @override
  UserPreferences get preferences;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SuperUserStats _$SuperUserStatsFromJson(Map<String, dynamic> json) {
  return _SuperUserStats.fromJson(json);
}

/// @nodoc
mixin _$SuperUserStats {
  int get placesCount => throw _privateConstructorUsedError;
  int get chatCount => throw _privateConstructorUsedError;
  int get reviewsCount => throw _privateConstructorUsedError;
  double get averageReviewRating => throw _privateConstructorUsedError;

  /// Serializes this SuperUserStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SuperUserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuperUserStatsCopyWith<SuperUserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuperUserStatsCopyWith<$Res> {
  factory $SuperUserStatsCopyWith(
    SuperUserStats value,
    $Res Function(SuperUserStats) then,
  ) = _$SuperUserStatsCopyWithImpl<$Res, SuperUserStats>;
  @useResult
  $Res call({
    int placesCount,
    int chatCount,
    int reviewsCount,
    double averageReviewRating,
  });
}

/// @nodoc
class _$SuperUserStatsCopyWithImpl<$Res, $Val extends SuperUserStats>
    implements $SuperUserStatsCopyWith<$Res> {
  _$SuperUserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SuperUserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placesCount = null,
    Object? chatCount = null,
    Object? reviewsCount = null,
    Object? averageReviewRating = null,
  }) {
    return _then(
      _value.copyWith(
            placesCount: null == placesCount
                ? _value.placesCount
                : placesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            chatCount: null == chatCount
                ? _value.chatCount
                : chatCount // ignore: cast_nullable_to_non_nullable
                      as int,
            reviewsCount: null == reviewsCount
                ? _value.reviewsCount
                : reviewsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            averageReviewRating: null == averageReviewRating
                ? _value.averageReviewRating
                : averageReviewRating // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SuperUserStatsImplCopyWith<$Res>
    implements $SuperUserStatsCopyWith<$Res> {
  factory _$$SuperUserStatsImplCopyWith(
    _$SuperUserStatsImpl value,
    $Res Function(_$SuperUserStatsImpl) then,
  ) = __$$SuperUserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int placesCount,
    int chatCount,
    int reviewsCount,
    double averageReviewRating,
  });
}

/// @nodoc
class __$$SuperUserStatsImplCopyWithImpl<$Res>
    extends _$SuperUserStatsCopyWithImpl<$Res, _$SuperUserStatsImpl>
    implements _$$SuperUserStatsImplCopyWith<$Res> {
  __$$SuperUserStatsImplCopyWithImpl(
    _$SuperUserStatsImpl _value,
    $Res Function(_$SuperUserStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SuperUserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placesCount = null,
    Object? chatCount = null,
    Object? reviewsCount = null,
    Object? averageReviewRating = null,
  }) {
    return _then(
      _$SuperUserStatsImpl(
        placesCount: null == placesCount
            ? _value.placesCount
            : placesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        chatCount: null == chatCount
            ? _value.chatCount
            : chatCount // ignore: cast_nullable_to_non_nullable
                  as int,
        reviewsCount: null == reviewsCount
            ? _value.reviewsCount
            : reviewsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        averageReviewRating: null == averageReviewRating
            ? _value.averageReviewRating
            : averageReviewRating // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SuperUserStatsImpl implements _SuperUserStats {
  const _$SuperUserStatsImpl({
    this.placesCount = 0,
    this.chatCount = 0,
    this.reviewsCount = 0,
    this.averageReviewRating = 0.0,
  });

  factory _$SuperUserStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuperUserStatsImplFromJson(json);

  @override
  @JsonKey()
  final int placesCount;
  @override
  @JsonKey()
  final int chatCount;
  @override
  @JsonKey()
  final int reviewsCount;
  @override
  @JsonKey()
  final double averageReviewRating;

  @override
  String toString() {
    return 'SuperUserStats(placesCount: $placesCount, chatCount: $chatCount, reviewsCount: $reviewsCount, averageReviewRating: $averageReviewRating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuperUserStatsImpl &&
            (identical(other.placesCount, placesCount) ||
                other.placesCount == placesCount) &&
            (identical(other.chatCount, chatCount) ||
                other.chatCount == chatCount) &&
            (identical(other.reviewsCount, reviewsCount) ||
                other.reviewsCount == reviewsCount) &&
            (identical(other.averageReviewRating, averageReviewRating) ||
                other.averageReviewRating == averageReviewRating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    placesCount,
    chatCount,
    reviewsCount,
    averageReviewRating,
  );

  /// Create a copy of SuperUserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuperUserStatsImplCopyWith<_$SuperUserStatsImpl> get copyWith =>
      __$$SuperUserStatsImplCopyWithImpl<_$SuperUserStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SuperUserStatsImplToJson(this);
  }
}

abstract class _SuperUserStats implements SuperUserStats {
  const factory _SuperUserStats({
    final int placesCount,
    final int chatCount,
    final int reviewsCount,
    final double averageReviewRating,
  }) = _$SuperUserStatsImpl;

  factory _SuperUserStats.fromJson(Map<String, dynamic> json) =
      _$SuperUserStatsImpl.fromJson;

  @override
  int get placesCount;
  @override
  int get chatCount;
  @override
  int get reviewsCount;
  @override
  double get averageReviewRating;

  /// Create a copy of SuperUserStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuperUserStatsImplCopyWith<_$SuperUserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return _UserPreferences.fromJson(json);
}

/// @nodoc
mixin _$UserPreferences {
  List<String> get placeTypes => throw _privateConstructorUsedError;
  List<String> get moods => throw _privateConstructorUsedError;
  String? get budget => throw _privateConstructorUsedError;
  String? get pace => throw _privateConstructorUsedError;

  /// Serializes this UserPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPreferencesCopyWith<UserPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesCopyWith<$Res> {
  factory $UserPreferencesCopyWith(
    UserPreferences value,
    $Res Function(UserPreferences) then,
  ) = _$UserPreferencesCopyWithImpl<$Res, UserPreferences>;
  @useResult
  $Res call({
    List<String> placeTypes,
    List<String> moods,
    String? budget,
    String? pace,
  });
}

/// @nodoc
class _$UserPreferencesCopyWithImpl<$Res, $Val extends UserPreferences>
    implements $UserPreferencesCopyWith<$Res> {
  _$UserPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeTypes = null,
    Object? moods = null,
    Object? budget = freezed,
    Object? pace = freezed,
  }) {
    return _then(
      _value.copyWith(
            placeTypes: null == placeTypes
                ? _value.placeTypes
                : placeTypes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            moods: null == moods
                ? _value.moods
                : moods // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            budget: freezed == budget
                ? _value.budget
                : budget // ignore: cast_nullable_to_non_nullable
                      as String?,
            pace: freezed == pace
                ? _value.pace
                : pace // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserPreferencesImplCopyWith<$Res>
    implements $UserPreferencesCopyWith<$Res> {
  factory _$$UserPreferencesImplCopyWith(
    _$UserPreferencesImpl value,
    $Res Function(_$UserPreferencesImpl) then,
  ) = __$$UserPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> placeTypes,
    List<String> moods,
    String? budget,
    String? pace,
  });
}

/// @nodoc
class __$$UserPreferencesImplCopyWithImpl<$Res>
    extends _$UserPreferencesCopyWithImpl<$Res, _$UserPreferencesImpl>
    implements _$$UserPreferencesImplCopyWith<$Res> {
  __$$UserPreferencesImplCopyWithImpl(
    _$UserPreferencesImpl _value,
    $Res Function(_$UserPreferencesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeTypes = null,
    Object? moods = null,
    Object? budget = freezed,
    Object? pace = freezed,
  }) {
    return _then(
      _$UserPreferencesImpl(
        placeTypes: null == placeTypes
            ? _value._placeTypes
            : placeTypes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        moods: null == moods
            ? _value._moods
            : moods // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        budget: freezed == budget
            ? _value.budget
            : budget // ignore: cast_nullable_to_non_nullable
                  as String?,
        pace: freezed == pace
            ? _value.pace
            : pace // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPreferencesImpl implements _UserPreferences {
  const _$UserPreferencesImpl({
    final List<String> placeTypes = const [],
    final List<String> moods = const [],
    this.budget,
    this.pace,
  }) : _placeTypes = placeTypes,
       _moods = moods;

  factory _$UserPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPreferencesImplFromJson(json);

  final List<String> _placeTypes;
  @override
  @JsonKey()
  List<String> get placeTypes {
    if (_placeTypes is EqualUnmodifiableListView) return _placeTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_placeTypes);
  }

  final List<String> _moods;
  @override
  @JsonKey()
  List<String> get moods {
    if (_moods is EqualUnmodifiableListView) return _moods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moods);
  }

  @override
  final String? budget;
  @override
  final String? pace;

  @override
  String toString() {
    return 'UserPreferences(placeTypes: $placeTypes, moods: $moods, budget: $budget, pace: $pace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesImpl &&
            const DeepCollectionEquality().equals(
              other._placeTypes,
              _placeTypes,
            ) &&
            const DeepCollectionEquality().equals(other._moods, _moods) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.pace, pace) || other.pace == pace));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_placeTypes),
    const DeepCollectionEquality().hash(_moods),
    budget,
    pace,
  );

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      __$$UserPreferencesImplCopyWithImpl<_$UserPreferencesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPreferencesImplToJson(this);
  }
}

abstract class _UserPreferences implements UserPreferences {
  const factory _UserPreferences({
    final List<String> placeTypes,
    final List<String> moods,
    final String? budget,
    final String? pace,
  }) = _$UserPreferencesImpl;

  factory _UserPreferences.fromJson(Map<String, dynamic> json) =
      _$UserPreferencesImpl.fromJson;

  @override
  List<String> get placeTypes;
  @override
  List<String> get moods;
  @override
  String? get budget;
  @override
  String? get pace;

  /// Create a copy of UserPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPreferencesImplCopyWith<_$UserPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
