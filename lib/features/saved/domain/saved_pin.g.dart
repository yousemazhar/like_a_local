// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_pin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SavedPinImpl _$$SavedPinImplFromJson(Map<String, dynamic> json) =>
    _$SavedPinImpl(
      placeId: json['placeId'] as String,
      collectionId: json['collectionId'] as String?,
      note: json['note'] as String?,
      pinnedAt: const TimestampConverter().fromJson(json['pinnedAt']),
    );

Map<String, dynamic> _$$SavedPinImplToJson(_$SavedPinImpl instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'collectionId': instance.collectionId,
      'note': instance.note,
      'pinnedAt': const TimestampConverter().toJson(instance.pinnedAt),
    };

_$SavedCollectionImpl _$$SavedCollectionImplFromJson(
  Map<String, dynamic> json,
) => _$SavedCollectionImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  coverPlaceId: json['coverPlaceId'] as String?,
  count: (json['count'] as num?)?.toInt() ?? 0,
  isPinned: json['isPinned'] as bool? ?? false,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$$SavedCollectionImplToJson(
  _$SavedCollectionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'coverPlaceId': instance.coverPlaceId,
  'count': instance.count,
  'isPinned': instance.isPinned,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
};
