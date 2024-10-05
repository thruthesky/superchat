import 'package:superchat/src/models/chat.message.dart';

class ChatInput {
  final String? text;
  final String? uploadUrl;
  final ChatMessage? replyTo;

  ChatInput({
    this.text,
    this.uploadUrl,
    this.replyTo,
  });
}
