import 'package:flutter/material.dart';
import 'package:voicegpt/model/text_chat.dart';

class ChatBubble extends StatefulWidget {
  final TextChat textChat;

  const ChatBubble({super.key, required this.textChat});
  @override
  State<ChatBubble> createState() => _ChatBubble();
}

class _ChatBubble extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: (widget.textChat.isReceiver == true
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (widget.textChat.isReceiver == false
                ? Colors.grey.shade200
                : Colors.blue[200]),
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            widget.textChat.content,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
