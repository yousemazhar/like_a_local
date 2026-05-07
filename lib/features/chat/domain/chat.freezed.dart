// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatThread _$ChatThreadFromJson(Map<String, dynamic> json) {
  return _ChatThread.fromJson(json);
}

/// @nodoc
mixin _$ChatThread {
  String get id => throw _privateConstructorUsedError;
  List<String> get members => throw _privateConstructorUsedError;
  Map<String, ChatMemberMeta> get memberMeta =>
      throw _privateConstructorUsedError;
  String get lastMessage => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get lastAt => throw _privateConstructorUsedError;
  Map<String, int> get unread => throw _privateConstructorUsedError;
  String? get placeContext => throw _privateConstructorUsedError;

  /// Serializes this ChatThread to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatThread
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatThreadCopyWith<ChatThread> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatThreadCopyWith<$Res> {
  factory $ChatThreadCopyWith(
    ChatThread value,
    $Res Function(ChatThread) then,
  ) = _$ChatThreadCopyWithImpl<$Res, ChatThread>;
  @useResult
  $Res call({
    String id,
    List<String> members,
    Map<String, ChatMemberMeta> memberMeta,
    String lastMessage,
    @TimestampConverter() DateTime? lastAt,
    Map<String, int> unread,
    String? placeContext,
  });
}

/// @nodoc
class _$ChatThreadCopyWithImpl<$Res, $Val extends ChatThread>
    implements $ChatThreadCopyWith<$Res> {
  _$ChatThreadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatThread
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? members = null,
    Object? memberMeta = null,
    Object? lastMessage = null,
    Object? lastAt = freezed,
    Object? unread = null,
    Object? placeContext = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            members: null == members
                ? _value.members
                : members // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            memberMeta: null == memberMeta
                ? _value.memberMeta
                : memberMeta // ignore: cast_nullable_to_non_nullable
                      as Map<String, ChatMemberMeta>,
            lastMessage: null == lastMessage
                ? _value.lastMessage
                : lastMessage // ignore: cast_nullable_to_non_nullable
                      as String,
            lastAt: freezed == lastAt
                ? _value.lastAt
                : lastAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            unread: null == unread
                ? _value.unread
                : unread // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            placeContext: freezed == placeContext
                ? _value.placeContext
                : placeContext // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatThreadImplCopyWith<$Res>
    implements $ChatThreadCopyWith<$Res> {
  factory _$$ChatThreadImplCopyWith(
    _$ChatThreadImpl value,
    $Res Function(_$ChatThreadImpl) then,
  ) = __$$ChatThreadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    List<String> members,
    Map<String, ChatMemberMeta> memberMeta,
    String lastMessage,
    @TimestampConverter() DateTime? lastAt,
    Map<String, int> unread,
    String? placeContext,
  });
}

/// @nodoc
class __$$ChatThreadImplCopyWithImpl<$Res>
    extends _$ChatThreadCopyWithImpl<$Res, _$ChatThreadImpl>
    implements _$$ChatThreadImplCopyWith<$Res> {
  __$$ChatThreadImplCopyWithImpl(
    _$ChatThreadImpl _value,
    $Res Function(_$ChatThreadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatThread
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? members = null,
    Object? memberMeta = null,
    Object? lastMessage = null,
    Object? lastAt = freezed,
    Object? unread = null,
    Object? placeContext = freezed,
  }) {
    return _then(
      _$ChatThreadImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        members: null == members
            ? _value._members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        memberMeta: null == memberMeta
            ? _value._memberMeta
            : memberMeta // ignore: cast_nullable_to_non_nullable
                  as Map<String, ChatMemberMeta>,
        lastMessage: null == lastMessage
            ? _value.lastMessage
            : lastMessage // ignore: cast_nullable_to_non_nullable
                  as String,
        lastAt: freezed == lastAt
            ? _value.lastAt
            : lastAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        unread: null == unread
            ? _value._unread
            : unread // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        placeContext: freezed == placeContext
            ? _value.placeContext
            : placeContext // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatThreadImpl implements _ChatThread {
  const _$ChatThreadImpl({
    required this.id,
    final List<String> members = const [],
    final Map<String, ChatMemberMeta> memberMeta = const {},
    this.lastMessage = '',
    @TimestampConverter() this.lastAt,
    final Map<String, int> unread = const {},
    this.placeContext,
  }) : _members = members,
       _memberMeta = memberMeta,
       _unread = unread;

  factory _$ChatThreadImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatThreadImplFromJson(json);

  @override
  final String id;
  final List<String> _members;
  @override
  @JsonKey()
  List<String> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  final Map<String, ChatMemberMeta> _memberMeta;
  @override
  @JsonKey()
  Map<String, ChatMemberMeta> get memberMeta {
    if (_memberMeta is EqualUnmodifiableMapView) return _memberMeta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberMeta);
  }

  @override
  @JsonKey()
  final String lastMessage;
  @override
  @TimestampConverter()
  final DateTime? lastAt;
  final Map<String, int> _unread;
  @override
  @JsonKey()
  Map<String, int> get unread {
    if (_unread is EqualUnmodifiableMapView) return _unread;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_unread);
  }

  @override
  final String? placeContext;

  @override
  String toString() {
    return 'ChatThread(id: $id, members: $members, memberMeta: $memberMeta, lastMessage: $lastMessage, lastAt: $lastAt, unread: $unread, placeContext: $placeContext)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatThreadImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality().equals(
              other._memberMeta,
              _memberMeta,
            ) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastAt, lastAt) || other.lastAt == lastAt) &&
            const DeepCollectionEquality().equals(other._unread, _unread) &&
            (identical(other.placeContext, placeContext) ||
                other.placeContext == placeContext));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    const DeepCollectionEquality().hash(_members),
    const DeepCollectionEquality().hash(_memberMeta),
    lastMessage,
    lastAt,
    const DeepCollectionEquality().hash(_unread),
    placeContext,
  );

  /// Create a copy of ChatThread
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatThreadImplCopyWith<_$ChatThreadImpl> get copyWith =>
      __$$ChatThreadImplCopyWithImpl<_$ChatThreadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatThreadImplToJson(this);
  }
}

abstract class _ChatThread implements ChatThread {
  const factory _ChatThread({
    required final String id,
    final List<String> members,
    final Map<String, ChatMemberMeta> memberMeta,
    final String lastMessage,
    @TimestampConverter() final DateTime? lastAt,
    final Map<String, int> unread,
    final String? placeContext,
  }) = _$ChatThreadImpl;

  factory _ChatThread.fromJson(Map<String, dynamic> json) =
      _$ChatThreadImpl.fromJson;

  @override
  String get id;
  @override
  List<String> get members;
  @override
  Map<String, ChatMemberMeta> get memberMeta;
  @override
  String get lastMessage;
  @override
  @TimestampConverter()
  DateTime? get lastAt;
  @override
  Map<String, int> get unread;
  @override
  String? get placeContext;

  /// Create a copy of ChatThread
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatThreadImplCopyWith<_$ChatThreadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatMemberMeta _$ChatMemberMetaFromJson(Map<String, dynamic> json) {
  return _ChatMemberMeta.fromJson(json);
}

/// @nodoc
mixin _$ChatMemberMeta {
  String get displayName => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  bool get isSuper => throw _privateConstructorUsedError;

  /// Serializes this ChatMemberMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMemberMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMemberMetaCopyWith<ChatMemberMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMemberMetaCopyWith<$Res> {
  factory $ChatMemberMetaCopyWith(
    ChatMemberMeta value,
    $Res Function(ChatMemberMeta) then,
  ) = _$ChatMemberMetaCopyWithImpl<$Res, ChatMemberMeta>;
  @useResult
  $Res call({String displayName, String? photoUrl, bool isSuper});
}

/// @nodoc
class _$ChatMemberMetaCopyWithImpl<$Res, $Val extends ChatMemberMeta>
    implements $ChatMemberMetaCopyWith<$Res> {
  _$ChatMemberMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMemberMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? photoUrl = freezed,
    Object? isSuper = null,
  }) {
    return _then(
      _value.copyWith(
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            isSuper: null == isSuper
                ? _value.isSuper
                : isSuper // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatMemberMetaImplCopyWith<$Res>
    implements $ChatMemberMetaCopyWith<$Res> {
  factory _$$ChatMemberMetaImplCopyWith(
    _$ChatMemberMetaImpl value,
    $Res Function(_$ChatMemberMetaImpl) then,
  ) = __$$ChatMemberMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String displayName, String? photoUrl, bool isSuper});
}

/// @nodoc
class __$$ChatMemberMetaImplCopyWithImpl<$Res>
    extends _$ChatMemberMetaCopyWithImpl<$Res, _$ChatMemberMetaImpl>
    implements _$$ChatMemberMetaImplCopyWith<$Res> {
  __$$ChatMemberMetaImplCopyWithImpl(
    _$ChatMemberMetaImpl _value,
    $Res Function(_$ChatMemberMetaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatMemberMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? photoUrl = freezed,
    Object? isSuper = null,
  }) {
    return _then(
      _$ChatMemberMetaImpl(
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        isSuper: null == isSuper
            ? _value.isSuper
            : isSuper // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMemberMetaImpl implements _ChatMemberMeta {
  const _$ChatMemberMetaImpl({
    this.displayName = '',
    this.photoUrl,
    this.isSuper = false,
  });

  factory _$ChatMemberMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMemberMetaImplFromJson(json);

  @override
  @JsonKey()
  final String displayName;
  @override
  final String? photoUrl;
  @override
  @JsonKey()
  final bool isSuper;

  @override
  String toString() {
    return 'ChatMemberMeta(displayName: $displayName, photoUrl: $photoUrl, isSuper: $isSuper)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMemberMetaImpl &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.isSuper, isSuper) || other.isSuper == isSuper));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, displayName, photoUrl, isSuper);

  /// Create a copy of ChatMemberMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMemberMetaImplCopyWith<_$ChatMemberMetaImpl> get copyWith =>
      __$$ChatMemberMetaImplCopyWithImpl<_$ChatMemberMetaImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMemberMetaImplToJson(this);
  }
}

abstract class _ChatMemberMeta implements ChatMemberMeta {
  const factory _ChatMemberMeta({
    final String displayName,
    final String? photoUrl,
    final bool isSuper,
  }) = _$ChatMemberMetaImpl;

  factory _ChatMemberMeta.fromJson(Map<String, dynamic> json) =
      _$ChatMemberMetaImpl.fromJson;

  @override
  String get displayName;
  @override
  String? get photoUrl;
  @override
  bool get isSuper;

  /// Create a copy of ChatMemberMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMemberMetaImplCopyWith<_$ChatMemberMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get senderUid => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  List<String> get readBy => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
    ChatMessage value,
    $Res Function(ChatMessage) then,
  ) = _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call({
    String id,
    String senderUid,
    String text,
    @TimestampConverter() DateTime? createdAt,
    List<String> readBy,
  });
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderUid = null,
    Object? text = null,
    Object? createdAt = freezed,
    Object? readBy = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            senderUid: null == senderUid
                ? _value.senderUid
                : senderUid // ignore: cast_nullable_to_non_nullable
                      as String,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            readBy: null == readBy
                ? _value.readBy
                : readBy // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
    _$ChatMessageImpl value,
    $Res Function(_$ChatMessageImpl) then,
  ) = __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String senderUid,
    String text,
    @TimestampConverter() DateTime? createdAt,
    List<String> readBy,
  });
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
    _$ChatMessageImpl _value,
    $Res Function(_$ChatMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderUid = null,
    Object? text = null,
    Object? createdAt = freezed,
    Object? readBy = null,
  }) {
    return _then(
      _$ChatMessageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        senderUid: null == senderUid
            ? _value.senderUid
            : senderUid // ignore: cast_nullable_to_non_nullable
                  as String,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        readBy: null == readBy
            ? _value._readBy
            : readBy // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl({
    required this.id,
    required this.senderUid,
    this.text = '',
    @TimestampConverter() this.createdAt,
    final List<String> readBy = const [],
  }) : _readBy = readBy;

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String senderUid;
  @override
  @JsonKey()
  final String text;
  @override
  @TimestampConverter()
  final DateTime? createdAt;
  final List<String> _readBy;
  @override
  @JsonKey()
  List<String> get readBy {
    if (_readBy is EqualUnmodifiableListView) return _readBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_readBy);
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, senderUid: $senderUid, text: $text, createdAt: $createdAt, readBy: $readBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderUid, senderUid) ||
                other.senderUid == senderUid) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._readBy, _readBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    senderUid,
    text,
    createdAt,
    const DeepCollectionEquality().hash(_readBy),
  );

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(this);
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage({
    required final String id,
    required final String senderUid,
    final String text,
    @TimestampConverter() final DateTime? createdAt,
    final List<String> readBy,
  }) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get senderUid;
  @override
  String get text;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  List<String> get readBy;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
