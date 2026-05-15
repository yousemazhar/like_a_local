// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return _Place.fromJson(json);
}

/// @nodoc
mixin _$Place {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<String> get moods => throw _privateConstructorUsedError;
  String? get priceLevel => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get neighborhood => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  List<PlaceTip> get tips => throw _privateConstructorUsedError;
  List<PlaceDish> get dishes => throw _privateConstructorUsedError;
  List<String> get mediaUrls => throw _privateConstructorUsedError;
  List<String> get videoUrls => throw _privateConstructorUsedError;
  String get ownerUid => throw _privateConstructorUsedError;
  bool get ownerIsSuper => throw _privateConstructorUsedError;
  double get ownerSuperScore => throw _privateConstructorUsedError;
  double get ratingAvg => throw _privateConstructorUsedError;
  int get ratingCount => throw _privateConstructorUsedError;
  int get saveCount => throw _privateConstructorUsedError;
  bool get featured => throw _privateConstructorUsedError;
  bool get hidden => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Place to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Place
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaceCopyWith<Place> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceCopyWith<$Res> {
  factory $PlaceCopyWith(Place value, $Res Function(Place) then) =
      _$PlaceCopyWithImpl<$Res, Place>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String category,
    List<String> moods,
    String? priceLevel,
    String city,
    String neighborhood,
    String address,
    double lat,
    double lng,
    List<PlaceTip> tips,
    List<PlaceDish> dishes,
    List<String> mediaUrls,
    List<String> videoUrls,
    String ownerUid,
    bool ownerIsSuper,
    double ownerSuperScore,
    double ratingAvg,
    int ratingCount,
    int saveCount,
    bool featured,
    bool hidden,
    @TimestampConverter() DateTime? createdAt,
  });
}

/// @nodoc
class _$PlaceCopyWithImpl<$Res, $Val extends Place>
    implements $PlaceCopyWith<$Res> {
  _$PlaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Place
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? moods = null,
    Object? priceLevel = freezed,
    Object? city = null,
    Object? neighborhood = null,
    Object? address = null,
    Object? lat = null,
    Object? lng = null,
    Object? tips = null,
    Object? dishes = null,
    Object? mediaUrls = null,
    Object? videoUrls = null,
    Object? ownerUid = null,
    Object? ownerIsSuper = null,
    Object? ownerSuperScore = null,
    Object? ratingAvg = null,
    Object? ratingCount = null,
    Object? saveCount = null,
    Object? featured = null,
    Object? hidden = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            moods: null == moods
                ? _value.moods
                : moods // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            priceLevel: freezed == priceLevel
                ? _value.priceLevel
                : priceLevel // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            neighborhood: null == neighborhood
                ? _value.neighborhood
                : neighborhood // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            lat: null == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double,
            lng: null == lng
                ? _value.lng
                : lng // ignore: cast_nullable_to_non_nullable
                      as double,
            tips: null == tips
                ? _value.tips
                : tips // ignore: cast_nullable_to_non_nullable
                      as List<PlaceTip>,
            dishes: null == dishes
                ? _value.dishes
                : dishes // ignore: cast_nullable_to_non_nullable
                      as List<PlaceDish>,
            mediaUrls: null == mediaUrls
                ? _value.mediaUrls
                : mediaUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            videoUrls: null == videoUrls
                ? _value.videoUrls
                : videoUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            ownerUid: null == ownerUid
                ? _value.ownerUid
                : ownerUid // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerIsSuper: null == ownerIsSuper
                ? _value.ownerIsSuper
                : ownerIsSuper // ignore: cast_nullable_to_non_nullable
                      as bool,
            ownerSuperScore: null == ownerSuperScore
                ? _value.ownerSuperScore
                : ownerSuperScore // ignore: cast_nullable_to_non_nullable
                      as double,
            ratingAvg: null == ratingAvg
                ? _value.ratingAvg
                : ratingAvg // ignore: cast_nullable_to_non_nullable
                      as double,
            ratingCount: null == ratingCount
                ? _value.ratingCount
                : ratingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            saveCount: null == saveCount
                ? _value.saveCount
                : saveCount // ignore: cast_nullable_to_non_nullable
                      as int,
            featured: null == featured
                ? _value.featured
                : featured // ignore: cast_nullable_to_non_nullable
                      as bool,
            hidden: null == hidden
                ? _value.hidden
                : hidden // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PlaceImplCopyWith<$Res> implements $PlaceCopyWith<$Res> {
  factory _$$PlaceImplCopyWith(
    _$PlaceImpl value,
    $Res Function(_$PlaceImpl) then,
  ) = __$$PlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String category,
    List<String> moods,
    String? priceLevel,
    String city,
    String neighborhood,
    String address,
    double lat,
    double lng,
    List<PlaceTip> tips,
    List<PlaceDish> dishes,
    List<String> mediaUrls,
    List<String> videoUrls,
    String ownerUid,
    bool ownerIsSuper,
    double ownerSuperScore,
    double ratingAvg,
    int ratingCount,
    int saveCount,
    bool featured,
    bool hidden,
    @TimestampConverter() DateTime? createdAt,
  });
}

/// @nodoc
class __$$PlaceImplCopyWithImpl<$Res>
    extends _$PlaceCopyWithImpl<$Res, _$PlaceImpl>
    implements _$$PlaceImplCopyWith<$Res> {
  __$$PlaceImplCopyWithImpl(
    _$PlaceImpl _value,
    $Res Function(_$PlaceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Place
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? moods = null,
    Object? priceLevel = freezed,
    Object? city = null,
    Object? neighborhood = null,
    Object? address = null,
    Object? lat = null,
    Object? lng = null,
    Object? tips = null,
    Object? dishes = null,
    Object? mediaUrls = null,
    Object? videoUrls = null,
    Object? ownerUid = null,
    Object? ownerIsSuper = null,
    Object? ownerSuperScore = null,
    Object? ratingAvg = null,
    Object? ratingCount = null,
    Object? saveCount = null,
    Object? featured = null,
    Object? hidden = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$PlaceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        moods: null == moods
            ? _value._moods
            : moods // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        priceLevel: freezed == priceLevel
            ? _value.priceLevel
            : priceLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        neighborhood: null == neighborhood
            ? _value.neighborhood
            : neighborhood // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        lat: null == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double,
        lng: null == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double,
        tips: null == tips
            ? _value._tips
            : tips // ignore: cast_nullable_to_non_nullable
                  as List<PlaceTip>,
        dishes: null == dishes
            ? _value._dishes
            : dishes // ignore: cast_nullable_to_non_nullable
                  as List<PlaceDish>,
        mediaUrls: null == mediaUrls
            ? _value._mediaUrls
            : mediaUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        videoUrls: null == videoUrls
            ? _value._videoUrls
            : videoUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        ownerUid: null == ownerUid
            ? _value.ownerUid
            : ownerUid // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerIsSuper: null == ownerIsSuper
            ? _value.ownerIsSuper
            : ownerIsSuper // ignore: cast_nullable_to_non_nullable
                  as bool,
        ownerSuperScore: null == ownerSuperScore
            ? _value.ownerSuperScore
            : ownerSuperScore // ignore: cast_nullable_to_non_nullable
                  as double,
        ratingAvg: null == ratingAvg
            ? _value.ratingAvg
            : ratingAvg // ignore: cast_nullable_to_non_nullable
                  as double,
        ratingCount: null == ratingCount
            ? _value.ratingCount
            : ratingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        saveCount: null == saveCount
            ? _value.saveCount
            : saveCount // ignore: cast_nullable_to_non_nullable
                  as int,
        featured: null == featured
            ? _value.featured
            : featured // ignore: cast_nullable_to_non_nullable
                  as bool,
        hidden: null == hidden
            ? _value.hidden
            : hidden // ignore: cast_nullable_to_non_nullable
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
class _$PlaceImpl implements _Place {
  const _$PlaceImpl({
    required this.id,
    required this.title,
    this.description = '',
    required this.category,
    final List<String> moods = const [],
    this.priceLevel,
    this.city = '',
    this.neighborhood = '',
    this.address = '',
    this.lat = 0.0,
    this.lng = 0.0,
    final List<PlaceTip> tips = const [],
    final List<PlaceDish> dishes = const [],
    final List<String> mediaUrls = const [],
    final List<String> videoUrls = const [],
    this.ownerUid = '',
    this.ownerIsSuper = false,
    this.ownerSuperScore = 0.0,
    this.ratingAvg = 0.0,
    this.ratingCount = 0,
    this.saveCount = 0,
    this.featured = false,
    this.hidden = false,
    @TimestampConverter() this.createdAt,
  }) : _moods = moods,
       _tips = tips,
       _dishes = dishes,
       _mediaUrls = mediaUrls,
       _videoUrls = videoUrls;

  factory _$PlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  final String category;
  final List<String> _moods;
  @override
  @JsonKey()
  List<String> get moods {
    if (_moods is EqualUnmodifiableListView) return _moods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moods);
  }

  @override
  final String? priceLevel;
  @override
  @JsonKey()
  final String city;
  @override
  @JsonKey()
  final String neighborhood;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final double lat;
  @override
  @JsonKey()
  final double lng;
  final List<PlaceTip> _tips;
  @override
  @JsonKey()
  List<PlaceTip> get tips {
    if (_tips is EqualUnmodifiableListView) return _tips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tips);
  }

  final List<PlaceDish> _dishes;
  @override
  @JsonKey()
  List<PlaceDish> get dishes {
    if (_dishes is EqualUnmodifiableListView) return _dishes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dishes);
  }

  final List<String> _mediaUrls;
  @override
  @JsonKey()
  List<String> get mediaUrls {
    if (_mediaUrls is EqualUnmodifiableListView) return _mediaUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mediaUrls);
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
  @JsonKey()
  final String ownerUid;
  @override
  @JsonKey()
  final bool ownerIsSuper;
  @override
  @JsonKey()
  final double ownerSuperScore;
  @override
  @JsonKey()
  final double ratingAvg;
  @override
  @JsonKey()
  final int ratingCount;
  @override
  @JsonKey()
  final int saveCount;
  @override
  @JsonKey()
  final bool featured;
  @override
  @JsonKey()
  final bool hidden;
  @override
  @TimestampConverter()
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Place(id: $id, title: $title, description: $description, category: $category, moods: $moods, priceLevel: $priceLevel, city: $city, neighborhood: $neighborhood, address: $address, lat: $lat, lng: $lng, tips: $tips, dishes: $dishes, mediaUrls: $mediaUrls, videoUrls: $videoUrls, ownerUid: $ownerUid, ownerIsSuper: $ownerIsSuper, ownerSuperScore: $ownerSuperScore, ratingAvg: $ratingAvg, ratingCount: $ratingCount, saveCount: $saveCount, featured: $featured, hidden: $hidden, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._moods, _moods) &&
            (identical(other.priceLevel, priceLevel) ||
                other.priceLevel == priceLevel) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.neighborhood, neighborhood) ||
                other.neighborhood == neighborhood) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            const DeepCollectionEquality().equals(other._tips, _tips) &&
            const DeepCollectionEquality().equals(other._dishes, _dishes) &&
            const DeepCollectionEquality().equals(
              other._mediaUrls,
              _mediaUrls,
            ) &&
            const DeepCollectionEquality().equals(
              other._videoUrls,
              _videoUrls,
            ) &&
            (identical(other.ownerUid, ownerUid) ||
                other.ownerUid == ownerUid) &&
            (identical(other.ownerIsSuper, ownerIsSuper) ||
                other.ownerIsSuper == ownerIsSuper) &&
            (identical(other.ownerSuperScore, ownerSuperScore) ||
                other.ownerSuperScore == ownerSuperScore) &&
            (identical(other.ratingAvg, ratingAvg) ||
                other.ratingAvg == ratingAvg) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.saveCount, saveCount) ||
                other.saveCount == saveCount) &&
            (identical(other.featured, featured) ||
                other.featured == featured) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    category,
    const DeepCollectionEquality().hash(_moods),
    priceLevel,
    city,
    neighborhood,
    address,
    lat,
    lng,
    const DeepCollectionEquality().hash(_tips),
    const DeepCollectionEquality().hash(_dishes),
    const DeepCollectionEquality().hash(_mediaUrls),
    const DeepCollectionEquality().hash(_videoUrls),
    ownerUid,
    ownerIsSuper,
    ownerSuperScore,
    ratingAvg,
    ratingCount,
    saveCount,
    featured,
    hidden,
    createdAt,
  ]);

  /// Create a copy of Place
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceImplCopyWith<_$PlaceImpl> get copyWith =>
      __$$PlaceImplCopyWithImpl<_$PlaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceImplToJson(this);
  }
}

abstract class _Place implements Place {
  const factory _Place({
    required final String id,
    required final String title,
    final String description,
    required final String category,
    final List<String> moods,
    final String? priceLevel,
    final String city,
    final String neighborhood,
    final String address,
    final double lat,
    final double lng,
    final List<PlaceTip> tips,
    final List<PlaceDish> dishes,
    final List<String> mediaUrls,
    final List<String> videoUrls,
    final String ownerUid,
    final bool ownerIsSuper,
    final double ownerSuperScore,
    final double ratingAvg,
    final int ratingCount,
    final int saveCount,
    final bool featured,
    final bool hidden,
    @TimestampConverter() final DateTime? createdAt,
  }) = _$PlaceImpl;

  factory _Place.fromJson(Map<String, dynamic> json) = _$PlaceImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get category;
  @override
  List<String> get moods;
  @override
  String? get priceLevel;
  @override
  String get city;
  @override
  String get neighborhood;
  @override
  String get address;
  @override
  double get lat;
  @override
  double get lng;
  @override
  List<PlaceTip> get tips;
  @override
  List<PlaceDish> get dishes;
  @override
  List<String> get mediaUrls;
  @override
  List<String> get videoUrls;
  @override
  String get ownerUid;
  @override
  bool get ownerIsSuper;
  @override
  double get ownerSuperScore;
  @override
  double get ratingAvg;
  @override
  int get ratingCount;
  @override
  int get saveCount;
  @override
  bool get featured;
  @override
  bool get hidden;
  @override
  @TimestampConverter()
  DateTime? get createdAt;

  /// Create a copy of Place
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaceImplCopyWith<_$PlaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlaceTip _$PlaceTipFromJson(Map<String, dynamic> json) {
  return _PlaceTip.fromJson(json);
}

/// @nodoc
mixin _$PlaceTip {
  String get text => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Serializes this PlaceTip to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlaceTip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaceTipCopyWith<PlaceTip> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceTipCopyWith<$Res> {
  factory $PlaceTipCopyWith(PlaceTip value, $Res Function(PlaceTip) then) =
      _$PlaceTipCopyWithImpl<$Res, PlaceTip>;
  @useResult
  $Res call({String text, int order});
}

/// @nodoc
class _$PlaceTipCopyWithImpl<$Res, $Val extends PlaceTip>
    implements $PlaceTipCopyWith<$Res> {
  _$PlaceTipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaceTip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? order = null}) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlaceTipImplCopyWith<$Res>
    implements $PlaceTipCopyWith<$Res> {
  factory _$$PlaceTipImplCopyWith(
    _$PlaceTipImpl value,
    $Res Function(_$PlaceTipImpl) then,
  ) = __$$PlaceTipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, int order});
}

/// @nodoc
class __$$PlaceTipImplCopyWithImpl<$Res>
    extends _$PlaceTipCopyWithImpl<$Res, _$PlaceTipImpl>
    implements _$$PlaceTipImplCopyWith<$Res> {
  __$$PlaceTipImplCopyWithImpl(
    _$PlaceTipImpl _value,
    $Res Function(_$PlaceTipImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlaceTip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? order = null}) {
    return _then(
      _$PlaceTipImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceTipImpl implements _PlaceTip {
  const _$PlaceTipImpl({required this.text, required this.order});

  factory _$PlaceTipImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceTipImplFromJson(json);

  @override
  final String text;
  @override
  final int order;

  @override
  String toString() {
    return 'PlaceTip(text: $text, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceTipImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, order);

  /// Create a copy of PlaceTip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceTipImplCopyWith<_$PlaceTipImpl> get copyWith =>
      __$$PlaceTipImplCopyWithImpl<_$PlaceTipImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceTipImplToJson(this);
  }
}

abstract class _PlaceTip implements PlaceTip {
  const factory _PlaceTip({
    required final String text,
    required final int order,
  }) = _$PlaceTipImpl;

  factory _PlaceTip.fromJson(Map<String, dynamic> json) =
      _$PlaceTipImpl.fromJson;

  @override
  String get text;
  @override
  int get order;

  /// Create a copy of PlaceTip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaceTipImplCopyWith<_$PlaceTipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlaceDish _$PlaceDishFromJson(Map<String, dynamic> json) {
  return _PlaceDish.fromJson(json);
}

/// @nodoc
mixin _$PlaceDish {
  String get name => throw _privateConstructorUsedError;

  /// Serializes this PlaceDish to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlaceDish
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaceDishCopyWith<PlaceDish> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceDishCopyWith<$Res> {
  factory $PlaceDishCopyWith(PlaceDish value, $Res Function(PlaceDish) then) =
      _$PlaceDishCopyWithImpl<$Res, PlaceDish>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$PlaceDishCopyWithImpl<$Res, $Val extends PlaceDish>
    implements $PlaceDishCopyWith<$Res> {
  _$PlaceDishCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaceDish
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlaceDishImplCopyWith<$Res>
    implements $PlaceDishCopyWith<$Res> {
  factory _$$PlaceDishImplCopyWith(
    _$PlaceDishImpl value,
    $Res Function(_$PlaceDishImpl) then,
  ) = __$$PlaceDishImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$PlaceDishImplCopyWithImpl<$Res>
    extends _$PlaceDishCopyWithImpl<$Res, _$PlaceDishImpl>
    implements _$$PlaceDishImplCopyWith<$Res> {
  __$$PlaceDishImplCopyWithImpl(
    _$PlaceDishImpl _value,
    $Res Function(_$PlaceDishImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlaceDish
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _$PlaceDishImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceDishImpl implements _PlaceDish {
  const _$PlaceDishImpl({required this.name});

  factory _$PlaceDishImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceDishImplFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'PlaceDish(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceDishImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of PlaceDish
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceDishImplCopyWith<_$PlaceDishImpl> get copyWith =>
      __$$PlaceDishImplCopyWithImpl<_$PlaceDishImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceDishImplToJson(this);
  }
}

abstract class _PlaceDish implements PlaceDish {
  const factory _PlaceDish({required final String name}) = _$PlaceDishImpl;

  factory _PlaceDish.fromJson(Map<String, dynamic> json) =
      _$PlaceDishImpl.fromJson;

  @override
  String get name;

  /// Create a copy of PlaceDish
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaceDishImplCopyWith<_$PlaceDishImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
