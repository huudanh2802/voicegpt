part of 'chat_bloc.dart';

@immutable
abstract class ChatState extends Equatable {
  final bool speechOn = false;

  const ChatState();
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ReceiveUserInput extends ChatState {
  final String userMessage;

  const ReceiveUserInput({required this.userMessage});

  @override
  List<Object> get props => [userMessage];
}

class SpeechInitial extends ChatState {
  const SpeechInitial();
}

class StartListenState extends ChatState {
  const StartListenState();
  @override
  List<Object> get props => [];
}

class ListeningState extends ChatState {
  final String userMessage;

  const ListeningState(this.userMessage);
  @override
  List<Object> get props => [userMessage];
}

class StopListeningState extends ChatState {
  const StopListeningState();
}

class RespondSuccess extends ChatState {
  final ChatCTResponse respondMessage;

  const RespondSuccess({required this.respondMessage});

  @override
  List<Object> get props => [respondMessage];
}
