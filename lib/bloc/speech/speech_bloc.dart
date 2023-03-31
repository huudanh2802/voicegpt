import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'speech_event.dart';
part 'speech_state.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  bool _speechOn = false;
  SpeechBloc() : super(SpeechInitial()) {
    on<SpeechOnEvent>((event, emit) {
      if (!_speechOn)
        _speechOn = true;
      else {}
    });
    on<OnFinishListeningEvent>((event, emit) {
      print(event.requestMessage);
    });
  }
}
