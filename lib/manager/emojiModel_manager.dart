import 'package:flutter/material.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'chat_manager/chatDetailManager.dart';

class EmojiModelManager extends ChangeNotifier {
  final manager = App.manager<ChatDetailManager>();

  /// 初始化
  init() {}

  onEmojiSelected(Emoji emoji) {
    manager.textEditingController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: manager.textEditingController.text.length));
    print("DEBUG=> emojiController ${manager.textEditingController.text}");
  }

  onBackspacePressed() {
    manager.textEditingController
      ..text =
          manager.textEditingController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: manager.textEditingController.text.length));
  }
}
