// lib/models/chat_message_model.dart
class ChatMessageModel {
  final bool isUser;
  final String message;
  final DateTime time;

  ChatMessageModel({
    required this.isUser,
    required this.message,
    required this.time,
  });
}