import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:breathing_collection/breathing_collection.dart';
import 'package:voicegpt/pages/setting_page/bloc/setting_bloc.dart';

import '../bloc/chat_bloc.dart';

class InputChat extends StatefulWidget {
  @override
  State<InputChat> createState() => _InputChat();
}

class _InputChat extends State<InputChat> {
  late ChatBloc _chatBloc;
  late SettingBloc _settingBloc;
  final TextEditingController _sendMessageController = TextEditingController();
  final TextEditingController _hintMessageController = TextEditingController();

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  /// This has to happen only once per app
  void _initSpeech() async {
    if (_chatBloc.state.speechOn == false) {
      _speechEnabled = await _speechToText.initialize(onStatus: (status) {
        if (status == "done") {
          _stopListening();
        }
      }, onError: (error) {
        print(error);
        _stopListening();
      });
    } else {
      _chatBloc.add(SpeechOnEvent());
    }
  }

  void _startListening() async {
    _chatBloc.add(StartListenEvent());
    await _speechToText.listen(
        localeId: _settingBloc.isVN ? "vi_VN" : "en_US",
        onResult: _onSpeechResult,
        partialResults: true,
        listenFor: Duration(seconds: 100),
        pauseFor: Duration(seconds: 100),
        cancelOnError: true);
  }

  void _stopListening() {
    _chatBloc.add(StopListeningEvent());
    _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _chatBloc.add(ListeningEvent(result.recognizedWords));
  }

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of(context);
    _settingBloc = BlocProvider.of<SettingBloc>(context);
    _initSpeech();
  }

  void _sendMessageWithText() async {
    if (_sendMessageController.text.isEmpty) return;
    String tempMessage = _sendMessageController.text;
    _sendMessageController.clear();
    _chatBloc.add(ChatMessageEvent(tempMessage));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _chatBloc,
        listener: (context, state) {
          if (state is StartListenState) {
            _hintMessageController.text = "Listening";
          } else if (state is ListeningState) {
            _hintMessageController.clear();
            _sendMessageController.text = state.userMessage;
          } else if (state is StopListeningState) {
            _hintMessageController.clear();
          }
        },
        builder: (context, state) => Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Center(
                  child: Column(children: [
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sendMessageController,
                      decoration: InputDecoration(
                        hintText: _hintMessageController.text,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        suffixIcon: IconButton(
                          onPressed: _sendMessageController.clear,
                          icon: Icon(Icons.clear),
                        ),
                      ),
                      cursorColor: Colors.indigoAccent,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () => {_sendMessageWithText()},
                    child: Icon(
                      Icons.send,
                      color: Colors.indigoAccent,
                      size: 30,
                    ),
                  )
                ]),
                const SizedBox(
                  height: 10,
                ),
                BreathingGlowingButton(
                  height: 60.0,
                  width: 60.0,
                  buttonBackgroundColor: Color(0xFF373A49),
                  glowColor: Color(0xFF777AF9),
                  icon:
                      (state is StartListenState ? Icons.mic : Icons.mic_none),
                  iconColor: Colors.white,
                  onTap: () {
                    if (state is StartListenState) {
                      _stopListening();
                    } else {
                      _startListening();
                    }
                  },
                ),
              ])),
            )));
  }
}
