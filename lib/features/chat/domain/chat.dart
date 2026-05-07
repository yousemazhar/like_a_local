import 'package:freezed_annotation/freezed_annotation.dart';

import '../../place/domain/place.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class ChatThread with _$ChatThread {
  const factory ChatThread({
    required String id,
    @Default([]) List<String> members,
    @Default({}) Map<String, ChatMemberMeta> memberMeta,
    @Default('') String lastMessage,
    @TimestampConverter() DateTime? lastAt,
    @Default({}) Map<String, int> unread,
    String? placeContext,
  }) = _ChatThread;

  factory ChatThread.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadFromJson(json);
}

@freezed
class ChatMemberMeta with _$ChatMemberMeta {
  const factory ChatMemberMeta({
    @Default('') String displayName,
    String? photoUrl,
    @Default(false) bool isSuper,
  }) = _ChatMemberMeta;

  factory ChatMemberMeta.fromJson(Map<String, dynamic> json) =>
      _$ChatMemberMetaFromJson(json);
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String senderUid,
    @Default('') String text,
    @TimestampConverter() DateTime? createdAt,
    @Default([]) List<String> readBy,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

String chatThreadId(String a, String b) {
  final pair = [a, b]..sort();
  return '${pair[0]}_${pair[1]}';
}
