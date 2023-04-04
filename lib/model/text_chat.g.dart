// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TextChatAdapter extends TypeAdapter<TextChat> {
  @override
  final int typeId = 0;

  @override
  TextChat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextChat(
      content: fields[0] as String,
      isSender: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TextChat obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.isSender);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
