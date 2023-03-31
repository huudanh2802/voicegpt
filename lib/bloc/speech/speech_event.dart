part of 'speech_bloc.dart';

@immutable
abstract class SpeechEvent extends Equatable {
  const SpeechEvent();
  @override
  List<Object> get props => [];
}

class ListeningEvent extends SpeechEvent {
  const ListeningEvent();
  @override
  List<Object> get props => [];
}

class SpeechOnEvent extends SpeechEvent {
  const SpeechOnEvent();
  @override
  List<Object> get props => [];
}

class OnFinishListeningEvent extends SpeechEvent {
  const OnFinishListeningEvent(this.requestMessage);
  final String requestMessage;
}
