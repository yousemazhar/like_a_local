// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceImpl _$$PlaceImplFromJson(Map<String, dynamic> json) => _$PlaceImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  category: json['category'] as String,
  moods:
      (json['moods'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  priceLevel: json['priceLevel'] as String?,
  city: json['city'] as String? ?? '',
  neighborhood: json['neighborhood'] as String? ?? '',
  address: json['address'] as String? ?? '',
  lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
  lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
  tips:
      (json['tips'] as List<dynamic>?)
          ?.map((e) => PlaceTip.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  mediaUrls:
      (json['mediaUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  ownerUid: json['ownerUid'] as String? ?? '',
  ownerIsSuper: json['ownerIsSuper'] as bool? ?? false,
  ownerSuperScore: (json['ownerSuperScore'] as num?)?.toDouble() ?? 0.0,
  ratingAvg: (json['ratingAvg'] as num?)?.toDouble() ?? 0.0,
  ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
  saveCount: (json['saveCount'] as num?)?.toInt() ?? 0,
  featured: json['featured'] as bool? ?? false,
  hidden: json['hidden'] as bool? ?? false,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$$PlaceImplToJson(_$PlaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'moods': instance.moods,
      'priceLevel': instance.priceLevel,
      'city': instance.city,
      'neighborhood': instance.neighborhood,
      'address': instance.address,
      'lat': instance.lat,
      'lng': instance.lng,
      'tips': instance.tips,
      'mediaUrls': instance.mediaUrls,
      'ownerUid': instance.ownerUid,
      'ownerIsSuper': instance.ownerIsSuper,
      'ownerSuperScore': instance.ownerSuperScore,
      'ratingAvg': instance.ratingAvg,
      'ratingCount': instance.ratingCount,
      'saveCount': instance.saveCount,
      'featured': instance.featured,
      'hidden': instance.hidden,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

_$PlaceTipImpl _$$PlaceTipImplFromJson(Map<String, dynamic> json) =>
    _$PlaceTipImpl(
      text: json['text'] as String,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$$PlaceTipImplToJson(_$PlaceTipImpl instance) =>
    <String, dynamic>{'text': instance.text, 'order': instance.order};
