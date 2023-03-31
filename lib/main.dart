import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voicegpt/bloc/speech/speech_bloc.dart';
import 'package:voicegpt/ui/screen/chat_page/chat_page.dart';

import 'bloc/chat/chat_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ChatBloc()),
          BlocProvider(create: (context) => SpeechBloc())
        ],
        child: MaterialApp(
          home: ChatPage(),
        ));
  }
}
