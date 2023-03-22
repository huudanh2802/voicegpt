import 'package:flutter/material.dart';
import 'package:voicegpt/ui/common/chat_message.dart';

class ChatModel extends ChangeNotifier {
  List<ChatMessage> chats = [];
  TextEditingController _messageController = TextEditingController();
  TextEditingController get messageController => _messageController;
  String chatMes = '';

  void add() {
    chats.add(ChatMessage(messageContent: chatMes, messageType: "sender"));
    chatMes = '';
    notifyListeners();
  }

  void updateMes(String newValue) {
    chatMes = newValue;
    notifyListeners();
  }
}
