import 'package:elysian_admin/presentation/screens/chat/chat.dart';

class Message {
  final String id;
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final bool isOnline;
  final bool isTyping;
  final bool isRead;
  final MessageStatus status;

  Message({
    required this.id,
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
    this.isOnline = false,
    this.isTyping = false,
    this.isRead = false,
    required this.status,
  });
}
