import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:voicegpt/model/text_chat.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final List<TextChat> _chatList = [];

  ChatBloc() : super(ChatInitial()) {
    on<ChatMessageEvent>((event, emit) {
      emit(ReceiveUserInput(userMessage: event.requestMessage));
    });
  }
}
