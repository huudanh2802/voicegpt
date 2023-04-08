import 'package:bloc/bloc.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:voicegpt/model/text_chat.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  bool _speechOn = false;
  final OpenAI openAI;
  final Box voiceGptBox = Hive.box('voicegpt');
  List<TextChat> historyLocal = [];
  ChatBloc(this.openAI) : super(ChatInitial()) {
    on<SpeakingEvent>((event, emit) {
      emit(SpeakingState());
    });
    on<StopSpeakingEvent>((event, emit) {
      emit(StopSpeakingState());
    });
    on<LoadHistoryEvent>((event, emit) async {
      var checkHistory = await voiceGptBox.get('chatHistory')?.cast<TextChat>();
      historyLocal = checkHistory ?? [];
      emit(LoadHistoryState(checkHistory));
    });
    on<ChatMessageEvent>((event, emit) async {
      if (state is RespondingState) {
      } else {
        emit(ReceiveUserInput(userMessage: event.requestMessage));

        try {
          emit(RespondingState());

          List<Map<String, String>> historyToSend = [];
          for (TextChat i in historyLocal) {
            historyToSend.add({
              "role": i.isSender ? "user" : "assistant",
              "content": i.content
            });
          }

          historyToSend.add({"role": "user", "content": event.requestMessage});

          final request = ChatCompleteText(
              model: kChatGptTurboModel,
              maxToken: 1500,
              messages: historyToSend);

          final response = await openAI.onChatCompletion(request: request);
          if (response != null) {
            historyLocal.add(TextChat(
              content: event.requestMessage,
              isSender: true,
            ));
            historyLocal.add(TextChat(
              content: response.choices[0].message.content,
              isSender: false,
            ));
            await voiceGptBox.put('chatHistory', historyLocal);
            emit(RespondSuccess(respondMessage: response));
          } else {
            throw Exception("Fail to get message");
          }
        } catch (err) {
          emit(ErrorRespondState(errorMessage: err.toString()));
        }
      }
    });
    on<SpeechOnEvent>((event, emit) {
      if (!_speechOn) _speechOn = true;
    });
    on<StartListenEvent>((event, emit) {
      emit(StartListenState());
    });
    on<ListeningEvent>((event, emit) {
      emit(ListeningState(event.requestMessage));
    });
    on<StopListeningEvent>((event, emit) {
      emit(StopListeningState());
      _speechOn = false;
    });
    on<RemoveHistoryEvent>((event, emit) async {
      await voiceGptBox.delete("chatHistory");
      historyLocal = [];
      emit(RemoveHistoryState());
    });
    on<ChangeLanguageChatEvent>((event, emit) async {
      emit(ChangeLanguageChatState());
    });
  }
}
