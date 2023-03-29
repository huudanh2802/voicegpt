import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/chat/chat_bloc.dart';

class InputChat extends StatefulWidget {
  @override
  State<InputChat> createState() => _InputChat();
}

class _InputChat extends State<InputChat> {
  late ChatBloc _chatBloc;
  final TextEditingController _sendMessageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chatBloc = BlocProvider.of(context);
  }

  void _sendMessage() async {
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
                  onTap: () => {_sendMessage()},
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
