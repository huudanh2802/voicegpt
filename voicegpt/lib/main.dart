import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voicegpt/provider/chat_provider.dart';
import 'package:voicegpt/ui/screen/chat_screen/chat_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ChatModel()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ChatScreen());
  }
}
