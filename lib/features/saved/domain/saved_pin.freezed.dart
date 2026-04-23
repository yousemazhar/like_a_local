// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_pin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SavedPin _$SavedPinFromJson(Map<String, dynamic> json) {
  return _SavedPin.fromJson(json);
}

/// @nodoc
mixin _$SavedPin {
  String get placeId => throw _privateConstructorUsedError;
  String? get collectionId => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get pinnedAt => throw _privateConstructorUsedError;

  /// Serializes this SavedPin to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedPin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedPinCopyWith<SavedPin> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedPinCopyWith<$Res> {
  factory $SavedPinCopyWith(SavedPin value, $Res Function(SavedPin) then) =
      _$SavedPinCopyWithImpl<$Res, SavedPin>;
  @useResult
  $Res call({
    String placeId,
    String? collectionId,
    String? note,
    @TimestampConverter() DateTime? pinnedAt,
  });
}

/// @nodoc
class _$SavedPinCopyWithImpl<$Res, $Val extends SavedPin>
    implements $SavedPinCopyWith<$Res> {
  _$SavedPinCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedPin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? collectionId = freezed,
    Object? note = freezed,
    Object? pinnedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            placeId: null == placeId
                ? _value.placeId
                : placeId // ignore: cast_nullable_to_non_nullable
                      as String,
            collectionId: freezed == collectionId
                ? _value.collectionId
                : collectionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            pinnedAt: freezed == pinnedAt
                ? _value.pinnedAt
                : pinnedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SavedPinImplCopyWith<$Res>
    implements $SavedPinCopyWith<$Res> {
  factory _$$SavedPinImplCopyWith(
    _$SavedPinImpl value,
    $Res Function(_$SavedPinImpl) then,
  ) = __$$SavedPinImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String placeId,
    String? collectionId,
    String? note,
    @TimestampConverter() DateTime? pinnedAt,
  });
}

/// @nodoc
class __$$SavedPinImplCopyWithImpl<$Res>
    extends _$SavedPinCopyWithImpl<$Res, _$SavedPinImpl>
    implements _$$SavedPinImplCopyWith<$Res> {
  __$$SavedPinImplCopyWithImpl(
    _$SavedPinImpl _value,
    $Res Function(_$SavedPinImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SavedPin
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? collectionId = freezed,
    Object? note = freezed,
    Object? pinnedAt = freezed,
  }) {
    return _then(
      _$SavedPinImpl(
        placeId: null == placeId
            ? _value.placeId
            : placeId // ignore: cast_nullable_to_non_nullable
                  as String,
        collectionId: freezed == collectionId
            ? _value.collectionId
            : collectionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        pinnedAt: freezed == pinnedAt
            ? _value.pinnedAt
            : pinnedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedPinImpl implements _SavedPin {
  const _$SavedPinImpl({
    required this.placeId,
    this.collectionId,
    this.note,
    @TimestampConverter() this.pinnedAt,
  });

  factory _$SavedPinImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedPinImplFromJson(json);

  @override
  final String placeId;
  @override
  final String? collectionId;
  @override
  final String? note;
  @override
  @TimestampConverter()
  final DateTime? pinnedAt;

  @override
  String toString() {
    return 'SavedPin(placeId: $placeId, collectionId: $collectionId, note: $note, pinnedAt: $pinnedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedPinImpl &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.collectionId, collectionId) ||
                other.collectionId == collectionId) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.pinnedAt, pinnedAt) ||
                other.pinnedAt == pinnedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, placeId, collectionId, note, pinnedAt);

  /// Create a copy of SavedPin
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedPinImplCopyWith<_$SavedPinImpl> get copyWith =>
      __$$SavedPinImplCopyWithImpl<_$SavedPinImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedPinImplToJson(this);
  }
}

abstract class _SavedPin implements SavedPin {
  const factory _SavedPin({
    required final String placeId,
    final String? collectionId,
    final String? note,
    @TimestampConverter() final DateTime? pinnedAt,
  }) = _$SavedPinImpl;

  factory _SavedPin.fromJson(Map<String, dynamic> json) =
      _$SavedPinImpl.fromJson;

  @override
  String get placeId;
  @override
  String? get collectionId;
  @override
  String? get note;
  @override
  @TimestampConverter()
  DateTime? get pinnedAt;

  /// Create a copy of SavedPin
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedPinImplCopyWith<_$SavedPinImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SavedCollection _$SavedCollectionFromJson(Map<String, dynamic> json) {
  return _SavedCollection.fromJson(json);
}

/// @nodoc
mixin _$SavedCollection {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get coverPlaceId => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  bool get isPinned => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SavedCollection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedCollectionCopyWith<SavedCollection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedCollectionCopyWith<$Res> {
  factory $SavedCollectionCopyWith(
    SavedCollection value,
    $Res Function(SavedCollection) then,
  ) = _$SavedCollectionCopyWithImpl<$Res, SavedCollection>;
  @useResult
  $Res call({
    String id,
    String name,
    String? coverPlaceId,
    int count,
    bool isPinned,
    @TimestampConverter() DateTime? createdAt,
  });
}

/// @nodoc
class _$SavedCollectionCopyWithImpl<$Res, $Val extends SavedCollection>
    implements $SavedCollectionCopyWith<$Res> {
  _$SavedCollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? coverPlaceId = freezed,
    Object? count = null,
    Object? isPinned = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            coverPlaceId: freezed == coverPlaceId
                ? _value.coverPlaceId
                : coverPlaceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
            isPinned: null == isPinned
                ? _value.isPinned
                : isPinned // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SavedCollectionImplCopyWith<$Res>
    implements $SavedCollectionCopyWith<$Res> {
  factory _$$SavedCollectionImplCopyWith(
    _$SavedCollectionImpl value,
    $Res Function(_$SavedCollectionImpl) then,
  ) = __$$SavedCollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? coverPlaceId,
    int count,
    bool isPinned,
    @TimestampConverter() DateTime? createdAt,
  });
}

/// @nodoc
class __$$SavedCollectionImplCopyWithImpl<$Res>
    extends _$SavedCollectionCopyWithImpl<$Res, _$SavedCollectionImpl>
    implements _$$SavedCollectionImplCopyWith<$Res> {
  __$$SavedCollectionImplCopyWithImpl(
    _$SavedCollectionImpl _value,
    $Res Function(_$SavedCollectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SavedCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? coverPlaceId = freezed,
    Object? count = null,
    Object? isPinned = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$SavedCollectionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        coverPlaceId: freezed == coverPlaceId
            ? _value.coverPlaceId
            : coverPlaceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        isPinned: null == isPinned
            ? _value.isPinned
            : isPinned // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedCollectionImpl implements _SavedCollection {
  const _$SavedCollectionImpl({
    required this.id,
    required this.name,
    this.coverPlaceId,
    this.count = 0,
    this.isPinned = false,
    @TimestampConverter() this.createdAt,
  });

  factory _$SavedCollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedCollectionImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? coverPlaceId;
  @override
  @JsonKey()
  final int count;
  @override
  @JsonKey()
  final bool isPinned;
  @override
  @TimestampConverter()
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SavedCollection(id: $id, name: $name, coverPlaceId: $coverPlaceId, count: $count, isPinned: $isPinned, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedCollectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.coverPlaceId, coverPlaceId) ||
                other.coverPlaceId == coverPlaceId) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    coverPlaceId,
    count,
    isPinned,
    createdAt,
  );

  /// Create a copy of SavedCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedCollectionImplCopyWith<_$SavedCollectionImpl> get copyWith =>
      __$$SavedCollectionImplCopyWithImpl<_$SavedCollectionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedCollectionImplToJson(this);
  }
}

abstract class _SavedCollection implements SavedCollection {
  const factory _SavedCollection({
    required final String id,
    required final String name,
    final String? coverPlaceId,
    final int count,
    final bool isPinned,
    @TimestampConverter() final DateTime? createdAt,
  }) = _$SavedCollectionImpl;

  factory _SavedCollection.fromJson(Map<String, dynamic> json) =
      _$SavedCollectionImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get coverPlaceId;
  @override
  int get count;
  @override
  bool get isPinned;
  @override
  @TimestampConverter()
  DateTime? get createdAt;

  /// Create a copy of SavedCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedCollectionImplCopyWith<_$SavedCollectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
