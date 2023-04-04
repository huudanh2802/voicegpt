import 'package:hive/hive.dart';

part 'text_chat.g.dart';

@HiveType(typeId: 0)
class TextChat {
  @HiveField(0)
  String content;
  @HiveField(1)
  bool isSender;
  TextChat({required this.content, required this.isSender});
}
