import 'package:hive/hive.dart';

part 'chatmessage_model.g.dart';

@HiveType(typeId: 2)
class ChatMessage extends HiveObject {
  @HiveField(0)
  String message;

  @HiveField(1)
  bool isUser;

  @HiveField(2)
  DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
  });
}