import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/manager/emojiModel_manager.dart';

import '../AppContext.dart';

/// Example for EmojiPickerFlutter
class EmojiModelView extends StatelessWidget {
  final manager = App.manager<EmojiModelManager>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0.h,
      child: EmojiPicker(
          onEmojiSelected: (Category category, Emoji emoji) {
            manager.onEmojiSelected(emoji);
          },
          onBackspacePressed: manager.onBackspacePressed,
          config: Config(
              columns: 7,
              // Issue: https://github.com/flutter/flutter/issues/28894
              emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
              verticalSpacing: 0,
              horizontalSpacing: 0,
              initCategory: Category.RECENT,
              bgColor: const Color(0xFFF2F2F2),
              indicatorColor: Flavors.colorInfo.mainColor,
              iconColor: Colors.grey,
              iconColorSelected: Flavors.colorInfo.mainColor,
              progressIndicatorColor: Flavors.colorInfo.mainColor,
              backspaceColor: Flavors.colorInfo.mainColor,
              showRecentsTab: false,
              recentsLimit: 28,
              noRecentsText: '没有记录',
              noRecentsStyle:
                  const TextStyle(fontSize: 20, color: Colors.black26),
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL)),
    );
  }
}
