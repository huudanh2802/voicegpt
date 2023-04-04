import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voicegpt/model/text_chat.dart';

import '../bloc/chat_bloc.dart';

class ChatBubble extends StatefulWidget {
  final TextChat textChat;
  final Function(String) onPlayButton;
  final Function() onStopButton;
  const ChatBubble({
    super.key,
    required this.textChat,
    required this.onPlayButton,
    required this.onStopButton,
  });
  @override
  State<ChatBubble> createState() => _ChatBubble();
}

class _ChatBubble extends State<ChatBubble> {
  late ChatBloc _chatBloc;
  bool _speaking = false;
  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of(context);
  }

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
      return BlocConsumer(
          bloc: _chatBloc,
          listener: (context, state) {
            if (state is SpeakingState) {
              _speaking = true;
            } else if (state is StopListeningState) {
              _speaking = false;
            }
          },
          builder: (context, state) => Row(
                children: [
                  BubbleSpecialThree(
                      text: widget.textChat.content,
                      isSender: widget.textChat.isSender,
                      color: Colors.grey.shade400),
                  IconButton(
                      onPressed: () => !_speaking
                          ? widget.onPlayButton(widget.textChat.content)
                          : widget.onStopButton(),
                      icon: (!_speaking
                          ? Icon(
                              Icons.play_arrow,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.stop,
                              color: Colors.red,
                            )))
                ],
              ));
    }
  }
}
