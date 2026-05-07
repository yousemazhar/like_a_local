// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
  Map<String, dynamic> json,
) => _$AppNotificationImpl(
  id: json['id'] as String,
  type: json['type'] as String? ?? 'system',
  title: json['title'] as String? ?? '',
  body: json['body'] as String? ?? '',
  data: json['data'] as Map<String, dynamic>? ?? const {},
  read: json['read'] as bool? ?? false,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$$AppNotificationImplToJson(
  _$AppNotificationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'body': instance.body,
  'data': instance.data,
  'read': instance.read,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
};
