import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:voicegpt/model/text_chat.dart';
import 'package:voicegpt/ui/screen/chat_page/widget/chat_bubble.dart';
import 'package:voicegpt/ui/screen/chat_page/widget/input_chat.dart';

import 'bloc/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  List<TextChat> _chatList = [];

  late ChatBloc _chatBloc;
  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of(context);
    flutterTts = FlutterTts();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  textToSpeech(String botMessage) async {
    await flutterTts.setLanguage("en-US");

    await flutterTts.setPitch(1);
    await flutterTts.speak(botMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            "OctoAssist",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
          elevation: 0,
        ),
        body: SafeArea(
            child: BlocConsumer<ChatBloc, ChatState>(
                bloc: _chatBloc,
                listener: (context, state) {
                  if (state is ReceiveUserInput) {
                    _chatList.insert(0,
                        TextChat(content: state.userMessage, isSender: true));
                  } else if (state is RespondSuccess) {
                    _chatList.insert(
                        0,
                        TextChat(
                            content:
                                state.respondMessage.choices[0].message.content,
                            isSender: false));
                  } else if (state is ErrorRespondState) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.errorMessage),
                      backgroundColor: Colors.red,
                      elevation: 0,
                    ));
                    _chatList.removeLast();
                  }
                },
                builder: (context, state) {
                  return Container(
                      child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _chatList.length,
                          shrinkWrap: true,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return ChatBubble(
                              textChat: _chatList[index],
                              onPlayButton: textToSpeech,
                            );
                          },
                        ),
                      ),
                      (state is RespondingState
                          ? LoadingAnimationWidget.waveDots(
                              size: 50,
                              color: Colors.black,
                            )
                          : Container()),
                      InputChat(),
                    ],
                  ));
                })));
  }
}
