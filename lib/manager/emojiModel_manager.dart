import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:hatchery_im/routers.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:hatchery_im/api/entity.dart';
import 'dart:collection';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/services.dart';
import 'package:hatchery_im/config.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:hatchery_im/common/tools.dart';
import '../../config.dart';
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
