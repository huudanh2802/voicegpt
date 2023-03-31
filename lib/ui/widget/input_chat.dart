import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../bloc/chat/chat_bloc.dart';

class InputChat extends StatefulWidget {
  @override
  State<InputChat> createState() => _InputChat();
}

class _InputChat extends State<InputChat> {
  late ChatBloc _chatBloc;
  final TextEditingController _sendMessageController = TextEditingController();
  final TextEditingController _hintMessageController = TextEditingController();

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  /// This has to happen only once per app
  void _initSpeech() async {
    if (_chatBloc.state.speechOn == false) {
      _speechEnabled = await _speechToText.initialize();
    } else {
      _chatBloc.add(SpeechOnEvent());
    }
  }

  void _startListening() async {
    _chatBloc.add(StartListenEvent());
    await _speechToText.listen(
        onResult: _onSpeechResult,
        partialResults: true,
        listenFor: Duration(seconds: 100),
        cancelOnError: false);
  }

  void _stopListening() {
    _speechToText.cancel();
    _chatBloc.add(StopListeningEvent());
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _chatBloc.add(ListeningEvent(result.recognizedWords));
  }

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of(context);
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
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _sendMessageController,
                    decoration: InputDecoration(
                      hintText: _hintMessageController.text,
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
                GestureDetector(
                  onTapDown: (_) => _startListening(),
                  onTapUp: (_) => _stopListening(),
                  child: InkWell(
                    child: Icon(
                      Icons.mic,
                      color: Colors.indigoAccent,
                      size: 30,
                    ),
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
