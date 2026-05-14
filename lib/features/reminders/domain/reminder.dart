import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  const Reminder({
    required this.placeId,
    required this.type,
    required this.radiusMeters,
    required this.enabled,
    required this.lat,
    required this.lng,
    this.placeTitle,
    this.createdAt,
  });

  final String placeId;
  final String type;
  final int radiusMeters;
  final bool enabled;
  final double lat;
  final double lng;
  final String? placeTitle;
  final DateTime? createdAt;

  factory Reminder.fromJson(String placeId, Map<String, dynamic> json) {
    final ts = json['createdAt'];
    return Reminder(
      placeId: placeId,
      type: (json['type'] as String?) ?? 'location',
      radiusMeters: (json['radiusMeters'] as num?)?.toInt() ?? 200,
      enabled: (json['enabled'] as bool?) ?? true,
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      placeTitle: json['placeTitle'] as String?,
      createdAt: ts is Timestamp ? ts.toDate() : null,
    );
  }
}
