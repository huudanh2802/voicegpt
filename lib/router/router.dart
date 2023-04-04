import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voicegpt/pages/setting_page/setting_page.dart';

import '../pages/chat_page/chat_page.dart';

class MyRouter {
  static const String settingRoute = "/settings";
  static const String chatRoute = "/chat";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case chatRoute:
        return MaterialPageRoute(builder: (context) => ChatPage());
      case settingRoute:
        return MaterialPageRoute(builder: (context) => SettingPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Center(
            child: Text("Error"),
          ),
        ),
      );
    });
  }
}
