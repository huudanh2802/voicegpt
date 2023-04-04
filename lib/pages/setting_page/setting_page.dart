import 'package:flutter/material.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';
import 'package:language_picker/languages.g.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
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
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: [
              CustomSettingsTile(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: LanguagePickerDropdown(
                          initialValue: Languages.vietnamese,
                          languages: [Languages.vietnamese, Languages.english],
                          onValuePicked: (Language language) {
                            print(language.name);
                          }))),
              SettingsTile.switchTile(
                activeSwitchColor: Colors.redAccent,
                onToggle: (value) {},
                initialValue: true,
                leading: Icon(Icons.mic),
                title: Text('Auto TTS'),
              ),
              CustomSettingsTile(
                  child: Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  onPressed: () {},
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
      ),
    );
  }
}
