// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
  id: json['id'] as String,
  placeId: json['placeId'] as String,
  authorUid: json['authorUid'] as String,
  authorDisplayName: json['authorDisplayName'] as String? ?? '',
  authorPhotoUrl: json['authorPhotoUrl'] as String?,
  authorIsSuper: json['authorIsSuper'] as bool? ?? false,
  rating: (json['rating'] as num).toInt(),
  text: json['text'] as String? ?? '',
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'placeId': instance.placeId,
      'authorUid': instance.authorUid,
      'authorDisplayName': instance.authorDisplayName,
      'authorPhotoUrl': instance.authorPhotoUrl,
      'authorIsSuper': instance.authorIsSuper,
      'rating': instance.rating,
      'text': instance.text,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
