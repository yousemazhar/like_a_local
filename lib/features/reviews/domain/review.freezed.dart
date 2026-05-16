// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return _Review.fromJson(json);
}

/// @nodoc
mixin _$Review {
  String get id => throw _privateConstructorUsedError;
  String get placeId => throw _privateConstructorUsedError;
  String get authorUid => throw _privateConstructorUsedError;
  String get authorDisplayName => throw _privateConstructorUsedError;
  String? get authorPhotoUrl => throw _privateConstructorUsedError;
  bool get authorIsSuper => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  List<String> get photoUrls => throw _privateConstructorUsedError;
  List<String> get videoUrls => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewCopyWith<Review> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewCopyWith<$Res> {
  factory $ReviewCopyWith(Review value, $Res Function(Review) then) =
      _$ReviewCopyWithImpl<$Res, Review>;
  @useResult
  $Res call({
    String id,
    String placeId,
    String authorUid,
    String authorDisplayName,
    String? authorPhotoUrl,
    bool authorIsSuper,
    int rating,
    String text,
    List<String> photoUrls,
    List<String> videoUrls,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class _$ReviewCopyWithImpl<$Res, $Val extends Review>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? placeId = null,
    Object? authorUid = null,
    Object? authorDisplayName = null,
    Object? authorPhotoUrl = freezed,
    Object? authorIsSuper = null,
    Object? rating = null,
    Object? text = null,
    Object? photoUrls = null,
    Object? videoUrls = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            placeId: null == placeId
                ? _value.placeId
                : placeId // ignore: cast_nullable_to_non_nullable
                      as String,
            authorUid: null == authorUid
                ? _value.authorUid
                : authorUid // ignore: cast_nullable_to_non_nullable
                      as String,
            authorDisplayName: null == authorDisplayName
                ? _value.authorDisplayName
                : authorDisplayName // ignore: cast_nullable_to_non_nullable
                      as String,
            authorPhotoUrl: freezed == authorPhotoUrl
                ? _value.authorPhotoUrl
                : authorPhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            authorIsSuper: null == authorIsSuper
                ? _value.authorIsSuper
                : authorIsSuper // ignore: cast_nullable_to_non_nullable
                      as bool,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as int,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            photoUrls: null == photoUrls
                ? _value.photoUrls
                : photoUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            videoUrls: null == videoUrls
                ? _value.videoUrls
                : videoUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReviewImplCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$$ReviewImplCopyWith(
    _$ReviewImpl value,
    $Res Function(_$ReviewImpl) then,
  ) = __$$ReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String placeId,
    String authorUid,
    String authorDisplayName,
    String? authorPhotoUrl,
    bool authorIsSuper,
    int rating,
    String text,
    List<String> photoUrls,
    List<String> videoUrls,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ReviewImplCopyWithImpl<$Res>
    extends _$ReviewCopyWithImpl<$Res, _$ReviewImpl>
    implements _$$ReviewImplCopyWith<$Res> {
  __$$ReviewImplCopyWithImpl(
    _$ReviewImpl _value,
    $Res Function(_$ReviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? placeId = null,
    Object? authorUid = null,
    Object? authorDisplayName = null,
    Object? authorPhotoUrl = freezed,
    Object? authorIsSuper = null,
    Object? rating = null,
    Object? text = null,
    Object? photoUrls = null,
    Object? videoUrls = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ReviewImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        placeId: null == placeId
            ? _value.placeId
            : placeId // ignore: cast_nullable_to_non_nullable
                  as String,
        authorUid: null == authorUid
            ? _value.authorUid
            : authorUid // ignore: cast_nullable_to_non_nullable
                  as String,
        authorDisplayName: null == authorDisplayName
            ? _value.authorDisplayName
            : authorDisplayName // ignore: cast_nullable_to_non_nullable
                  as String,
        authorPhotoUrl: freezed == authorPhotoUrl
            ? _value.authorPhotoUrl
            : authorPhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        authorIsSuper: null == authorIsSuper
            ? _value.authorIsSuper
            : authorIsSuper // ignore: cast_nullable_to_non_nullable
                  as bool,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as int,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        photoUrls: null == photoUrls
            ? _value._photoUrls
            : photoUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        videoUrls: null == videoUrls
            ? _value._videoUrls
            : videoUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewImpl implements _Review {
  const _$ReviewImpl({
    required this.id,
    required this.placeId,
    required this.authorUid,
    this.authorDisplayName = '',
    this.authorPhotoUrl,
    this.authorIsSuper = false,
    required this.rating,
    this.text = '',
    final List<String> photoUrls = const <String>[],
    final List<String> videoUrls = const <String>[],
    @TimestampConverter() this.createdAt,
    @TimestampConverter() this.updatedAt,
  }) : _photoUrls = photoUrls,
       _videoUrls = videoUrls;

  factory _$ReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewImplFromJson(json);

  @override
  final String id;
  @override
  final String placeId;
  @override
  final String authorUid;
  @override
  @JsonKey()
  final String authorDisplayName;
  @override
  final String? authorPhotoUrl;
  @override
  @JsonKey()
  final bool authorIsSuper;
  @override
  final int rating;
  @override
  @JsonKey()
  final String text;
  final List<String> _photoUrls;
  @override
  @JsonKey()
  List<String> get photoUrls {
    if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoUrls);
  }

  final List<String> _videoUrls;
  @override
  @JsonKey()
  List<String> get videoUrls {
    if (_videoUrls is EqualUnmodifiableListView) return _videoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videoUrls);
  }

  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  @TimestampConverter()
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Review(id: $id, placeId: $placeId, authorUid: $authorUid, authorDisplayName: $authorDisplayName, authorPhotoUrl: $authorPhotoUrl, authorIsSuper: $authorIsSuper, rating: $rating, text: $text, photoUrls: $photoUrls, videoUrls: $videoUrls, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.authorUid, authorUid) ||
                other.authorUid == authorUid) &&
            (identical(other.authorDisplayName, authorDisplayName) ||
                other.authorDisplayName == authorDisplayName) &&
            (identical(other.authorPhotoUrl, authorPhotoUrl) ||
                other.authorPhotoUrl == authorPhotoUrl) &&
            (identical(other.authorIsSuper, authorIsSuper) ||
                other.authorIsSuper == authorIsSuper) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(
              other._photoUrls,
              _photoUrls,
            ) &&
            const DeepCollectionEquality().equals(
              other._videoUrls,
              _videoUrls,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    placeId,
    authorUid,
    authorDisplayName,
    authorPhotoUrl,
    authorIsSuper,
    rating,
    text,
    const DeepCollectionEquality().hash(_photoUrls),
    const DeepCollectionEquality().hash(_videoUrls),
    createdAt,
    updatedAt,
  );

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      __$$ReviewImplCopyWithImpl<_$ReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewImplToJson(this);
  }
}

abstract class _Review implements Review {
  const factory _Review({
    required final String id,
    required final String placeId,
    required final String authorUid,
    final String authorDisplayName,
    final String? authorPhotoUrl,
    final bool authorIsSuper,
    required final int rating,
    final String text,
    final List<String> photoUrls,
    final List<String> videoUrls,
    @TimestampConverter() final DateTime? createdAt,
    @TimestampConverter() final DateTime? updatedAt,
  }) = _$ReviewImpl;

  factory _Review.fromJson(Map<String, dynamic> json) = _$ReviewImpl.fromJson;

  @override
  String get id;
  @override
  String get placeId;
  @override
  String get authorUid;
  @override
  String get authorDisplayName;
  @override
  String? get authorPhotoUrl;
  @override
  bool get authorIsSuper;
  @override
  int get rating;
  @override
  String get text;
  @override
  List<String> get photoUrls;
  @override
  List<String> get videoUrls;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @TimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
