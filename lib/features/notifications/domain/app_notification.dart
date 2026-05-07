import 'package:freezed_annotation/freezed_annotation.dart';

import '../../place/domain/place.dart';

part 'app_notification.freezed.dart';
part 'app_notification.g.dart';

enum AppNotificationType { chat, pinNear, badge, system }

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    @Default('system') String type,
    @Default('') String title,
    @Default('') String body,
    @Default({}) Map<String, dynamic> data,
    @Default(false) bool read,
    @TimestampConverter() DateTime? createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
