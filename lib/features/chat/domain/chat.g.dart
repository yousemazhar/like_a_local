// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatThreadImpl _$$ChatThreadImplFromJson(Map<String, dynamic> json) =>
    _$ChatThreadImpl(
      id: json['id'] as String,
      members:
          (json['members'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      memberMeta:
          (json['memberMeta'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, ChatMemberMeta.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      lastMessage: json['lastMessage'] as String? ?? '',
      lastAt: const TimestampConverter().fromJson(json['lastAt']),
      unread:
          (json['unread'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      placeContext: json['placeContext'] as String?,
    );

Map<String, dynamic> _$$ChatThreadImplToJson(_$ChatThreadImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'members': instance.members,
      'memberMeta': instance.memberMeta,
      'lastMessage': instance.lastMessage,
      'lastAt': const TimestampConverter().toJson(instance.lastAt),
      'unread': instance.unread,
      'placeContext': instance.placeContext,
    };

_$ChatMemberMetaImpl _$$ChatMemberMetaImplFromJson(Map<String, dynamic> json) =>
    _$ChatMemberMetaImpl(
      displayName: json['displayName'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      isSuper: json['isSuper'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatMemberMetaImplToJson(
  _$ChatMemberMetaImpl instance,
) => <String, dynamic>{
  'displayName': instance.displayName,
  'photoUrl': instance.photoUrl,
  'isSuper': instance.isSuper,
};

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      senderUid: json['senderUid'] as String,
      text: json['text'] as String? ?? '',
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      readBy:
          (json['readBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderUid': instance.senderUid,
      'text': instance.text,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'readBy': instance.readBy,
    };
