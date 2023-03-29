part of 'chat_bloc.dart';

@immutable
abstract class ChatState extends Equatable {
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

class RespondSuccess extends ChatState {
  final ChatCTResponse respondMessage;

  const RespondSuccess({required this.respondMessage});

  @override
  List<Object> get props => [respondMessage];
}
