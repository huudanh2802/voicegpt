import 'package:bloc/bloc.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:voicegpt/model/text_chat.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  bool _speechOn = false;
  final OpenAI openAI;

  ChatBloc(this.openAI) : super(ChatInitial()) {
    on<ChatMessageEvent>((event, emit) async {
      emit(ReceiveUserInput(userMessage: event.requestMessage));
      try {
        final request = ChatCompleteText(
            model: kChatGptTurboModel,
            maxToken: 3500,
            messages: [
              Map.of({"role": "user", "content": event.requestMessage})
            ]);
        print(request);

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
    on<SpeechOnEvent>((event, emit) {
      if (!_speechOn) _speechOn = true;
    });
    on<StartListenEvent>((event, emit) {
      emit(StartListenState());
    });
    on<ListeningEvent>((event, emit) {
      print(event.requestMessage);
      emit(ListeningState(event.requestMessage));
    });
    on<StopListeningEvent>((event, emit) {
      emit(StopListeningState());
    });
  }
}
