import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voicegpt/bloc/speech/speech_bloc.dart';

import '../../bloc/chat/chat_bloc.dart';

class InputChat extends StatefulWidget {
  @override
  State<InputChat> createState() => _InputChat();
}

class _InputChat extends State<InputChat> {
  late ChatBloc _chatBloc;
  late SpeechBloc _speechBloc;
  final TextEditingController _sendMessageController = TextEditingController();

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  /// This has to happen only once per app
  void _initSpeech() async {
    if (_speechBloc.state.speechOn == false) {
      _speechEnabled = await _speechToText.initialize();
    } else {
      _speechBloc.add(SpeechOnEvent());
    }
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    // setState(() {
    //   _lastWords = result.recognizedWords;
    // });
    _speechBloc.add(OnFinishListeningEvent(result.recognizedWords));
  }

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of(context);
    _speechBloc = BlocProvider.of<SpeechBloc>(context);
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
    return BlocBuilder(
        bloc: _chatBloc,
        builder: (context, state) => Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _sendMessageController,
                    decoration: InputDecoration(
                      hintText: "Write message...",
                      hintStyle: TextStyle(color: Colors.grey.shade300),
                      fillColor: Colors.grey.shade800,
                      filled: true,
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
                    ),
                    cursorColor: Colors.indigoAccent,
                  ),
                ),
                InkWell(
                  onTap: () => {_startListening()},
                  child: Icon(
                    Icons.mic,
                    color: Colors.indigoAccent,
                    size: 30,
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
            )));
  }
}
