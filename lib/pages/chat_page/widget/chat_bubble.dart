import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:voicegpt/model/text_chat.dart';

class ChatBubble extends StatefulWidget {
  final TextChat textChat;
  final Function(String) onPlayButton;

  const ChatBubble(
      {super.key, required this.textChat, required this.onPlayButton});
  @override
  State<ChatBubble> createState() => _ChatBubble();
}

class _ChatBubble extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    if (widget.textChat.isSender) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BubbleSpecialThree(
              text: widget.textChat.content,
              isSender: widget.textChat.isSender,
              color: Colors.blueAccent),
        ],
      );
    } else {
      return Row(
        children: [
          BubbleSpecialThree(
              text: widget.textChat.content,
              isSender: widget.textChat.isSender,
              color: Colors.grey.shade400),
          IconButton(
              onPressed: () => widget.onPlayButton(widget.textChat.content),
              icon: Icon(
                Icons.play_arrow,
                color: Colors.green,
              )),
        ],
      );
    }
  }
}
