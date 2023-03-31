import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:voicegpt/model/text_chat.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatMessageEvent>((event, emit) {
      emit(ReceiveUserInput(userMessage: event.requestMessage));
            try {
        final request = ChatCompleteText(
            model: kChatGptTurboModel,
            maxToken: 3500,
            messages: [
              Map.of({"role": "user", "content": event.requestMessage})
            ]);
        final response = await openAI.onChatCompletion(request: request);
        if (response != null) {
          emit(RespondSuccess(respondMessage: response));
        } else {
          throw Exception("Fail to get message");
        }
      } catch (err) {
        print(err);
      }
    });
  }
}
