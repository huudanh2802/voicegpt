import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:language_picker/languages.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  bool isVN = false;
  bool isAutoTTS = false;
  final Box voiceGptBox = Hive.box('voicegpt');

  SettingBloc() : super(SettingInitial()) {
    on<InitEvent>((event, emit) async {
      isVN = await voiceGptBox.get('isVN') ?? false;
      isAutoTTS = await voiceGptBox.get('isAutoTTS') ?? false;
    });
    on<ChangeLanguageEvent>((event, emit) async {
      if (event.language == Languages.english) {
        isVN = false;
        await voiceGptBox.put('isVN', false);
      } else {
        isVN = true;
        await voiceGptBox.put('isVN', true);
      }
    });
    on<ChangeAutoTTSEvent>((event, emit) async {
      isAutoTTS = event.value;
      await voiceGptBox.put('isAutoTTS', event.value);
    });
  }
}
