import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';
import 'package:language_picker/languages.g.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:voicegpt/pages/setting_page/bloc/setting_bloc.dart';

import '../../router/router.dart';
import '../chat_page/bloc/chat_bloc.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  late ChatBloc _chatBloc;
  late SettingBloc _settingBloc;
  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of(context);
    _settingBloc = BlocProvider.of<SettingBloc>(context);
  }

  void _removeChatHistory() {
    _chatBloc.add(RemoveHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
            child: BlocConsumer<SettingBloc, SettingState>(
                bloc: _settingBloc,
                listener: (context, state) {},
                builder: (context, state) {
                  return SettingsList(
                    sections: [
                      SettingsSection(
                        tiles: [
                          CustomSettingsTile(
                              child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: LanguagePickerDropdown(
                                      initialValue: (_settingBloc.isVN
                                          ? Languages.vietnamese
                                          : Languages.english),
                                      languages: [
                                        Languages.vietnamese,
                                        Languages.english
                                      ],
                                      onValuePicked: (Language language) {
                                        _settingBloc
                                            .add(ChangeLanguageEvent(language));
                                      }))),
                          SettingsTile.switchTile(
                            activeSwitchColor: Colors.redAccent,
                            onToggle: (value) {
                              _settingBloc.add(ChangeAutoTTSEvent(value));
                              setState(() {});
                            },
                            initialValue: _settingBloc.isAutoTTS,
                            leading: Icon(Icons.mic),
                            title: Text('Auto TTS'),
                          ),
                          CustomSettingsTile(
                              child: Padding(
                            padding: EdgeInsets.all(20),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent),
                              onPressed: () {
                                _removeChatHistory();
                              },
                              icon: Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Delete chat history",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ],
                  );
                })));
  }
}
