import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voicegpt/model/text_chat.dart';
import 'package:voicegpt/ui/screen/chat_page/widget/chat_bubble.dart';
import 'package:voicegpt/ui/screen/chat_page/widget/input_chat.dart';

import '../../../bloc/chat/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  List<TextChat> _chatList = [
    TextChat(content: "dqwdqwd", isReceiver: true),
    TextChat(content: "Hello", isReceiver: false),
  ];

  late ChatBloc _chatBloc;
  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("OctoAssistant"),
          backgroundColor: Colors.indigoAccent,
        ),
        body: SafeArea(
            child: BlocConsumer<ChatBloc, ChatState>(
                bloc: _chatBloc,
                listener: (context, state) {
                  if (state is ReceiveUserInput) {
                    _chatList.add(TextChat(
                        content: state.userMessage, isReceiver: false));
                  }
                },
                builder: (context, state) {
                  return Container(
                      color: Colors.black,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: _chatList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ChatBubble(textChat: _chatList[index]);
                              },
                            ),
                          ),
                          InputChat(),
                        ],
                      ));
                })));
  }
}
