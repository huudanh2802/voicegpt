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

class ImageMessageEvent extends ChatEvent {
  final String requestMessage;

  const ImageMessageEvent(this.requestMessage);
}
