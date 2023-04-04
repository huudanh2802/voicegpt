import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voicegpt/const/api_const.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:voicegpt/pages/chat_page/bloc/chat_bloc.dart';
import 'package:voicegpt/pages/chat_page/chat_page.dart';
import 'package:voicegpt/pages/setting_page/setting_page.dart';
import 'package:voicegpt/router/router.dart';

import 'model/text_chat.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();
  Hive.registerAdapter(TextChatAdapter());

  await Hive.openBox("voicegpt");

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  late OpenAI openAI;
  late Box _voiceGptBox;

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Hive.close();

    openAI.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ChatBloc(openAI)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: MyRouter.generateRoute,
          initialRoute: MyRouter.chatRoute,
        ));
  }
}
