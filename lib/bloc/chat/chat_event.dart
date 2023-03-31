part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChatMessageEvent extends ChatEvent {
  final String requestMessage;

  const ChatMessageEvent(this.requestMessage);
}

class StartListenEvent extends ChatEvent {
  const StartListenEvent();
  @override
  List<Object> get props => [];
}

class SpeechOnEvent extends ChatEvent {
  const SpeechOnEvent();
  @override
  List<Object> get props => [];
}

class ListeningEvent extends ChatEvent {
  const ListeningEvent(this.requestMessage);
  final String requestMessage;
}

class StopListeningEvent extends ChatEvent {
  const StopListeningEvent();
}
