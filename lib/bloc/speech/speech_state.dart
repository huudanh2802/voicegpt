part of 'speech_bloc.dart';

@immutable
abstract class SpeechState extends Equatable {
  final bool speechOn = false;

  const SpeechState();

  @override
  List<Object> get props => [speechOn];
}

class SpeechInitial extends SpeechState {
  const SpeechInitial();
}

class ListeningState extends SpeechState {
  const ListeningState();
  @override
  List<Object> get props => [];
}
