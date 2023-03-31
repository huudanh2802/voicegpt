import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voicegpt/const/api_const.dart';
import 'package:voicegpt/ui/screen/chat_page/chat_page.dart';

import 'bloc/chat/chat_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  late OpenAI openAI;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openAI = OpenAI.instance.build(
      token: ApiConst().API_KEY,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 50)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ChatBloc(openAI)),
        ],
        child: MaterialApp(
          home: ChatPage(),
        ));
  }
}
