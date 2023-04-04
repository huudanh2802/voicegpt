part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class InitEvent extends SettingEvent {
  const InitEvent();

  @override
  List<Object> get props => [];
}

class ChangeLanguageEvent extends SettingEvent {
  final Language language;
  const ChangeLanguageEvent(this.language);

  @override
  List<Object> get props => [language];
}

class ChangeAutoTTSEvent extends SettingEvent {
  final bool value;
  const ChangeAutoTTSEvent(this.value);

  @override
  List<Object> get props => [value];
}
