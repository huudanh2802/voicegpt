import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:voicegpt/model/text_chat.dart';
import 'package:voicegpt/pages/chat_page/widget/chat_bubble.dart';
import 'package:voicegpt/pages/chat_page/widget/input_chat.dart';

import '../../router/router.dart';
import '../setting_page/bloc/setting_bloc.dart';
import 'bloc/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  final List<TextChat> _chatList = [];

  late ChatBloc _chatBloc;
  late SettingBloc _settingBloc;
  late FlutterTts flutterTts;
  final Box voiceGptBox = Hive.box('voicegpt');

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of(context);
    _settingBloc = BlocProvider.of<SettingBloc>(context);
    flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      _chatBloc.add(SpeakingEvent());
    });
    flutterTts.setCompletionHandler(() {
      _chatBloc.add(StopListeningEvent());
    });
    flutterTts.setCancelHandler(() {
      _chatBloc.add(StopListeningEvent());
    });
    _chatBloc.add(LoadHistoryEvent());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  textToSpeech(String botMessage) async {
    if (!_settingBloc.isVN) {
      await flutterTts.setLanguage("en-US");
    } else {
      await flutterTts.setLanguage("vi_VN");
    }

    await flutterTts.setPitch(1);
    await flutterTts.speak(botMessage);
  }

  stopTTS() async {
    await flutterTts.stop();
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
              onPressed: () {
                Navigator.pushNamed(context, MyRouter.settingRoute);
              },
            ),
          ],
          elevation: 0,
        ),
        body: SafeArea(
            child: BlocConsumer<ChatBloc, ChatState>(
                bloc: _chatBloc,
                listener: (context, state) async {
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
                    if (_settingBloc.isAutoTTS) {
                      textToSpeech(
                          state.respondMessage.choices[0].message.content);
                    }
                  } else if (state is ErrorRespondState) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.errorMessage),
                      backgroundColor: Colors.red,
                      elevation: 0,
                    ));
                    _chatList.removeAt(0);
                  } else if (state is LoadHistoryState) {
                    _chatBloc.historyLocal.forEach((element) {
                      _chatList.insert(0, element);
                    });
                  } else if (state is RemoveHistoryState) {
                    _chatList.clear();
                  } else if (state is ChangeLanguageChatState) {
                    if (!_settingBloc.isVN) {
                      await flutterTts.setLanguage("en-US");
                    } else {
                      await flutterTts.setLanguage("vi_VN");
                    }
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
                              onStopButton: stopTTS,
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
