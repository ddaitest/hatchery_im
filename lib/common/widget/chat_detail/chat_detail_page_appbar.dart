import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/flavors/Flavors.dart';

class ChatDetailPageAppBar {
  static AppBar chatDetailAppBar(String? name) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      title: Text(
        name!,
        style: Flavors.textStyles.chatDetailAppBarNameText,
        softWrap: true,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: Container(
        padding: const EdgeInsets.all(6.0),
        child: IconButton(
          icon: Icon(Icons.arrow_back, size: 30.0, color: Colors.black),
          onPressed: () => Navigator.of(App.navState.currentContext!).pop(),
        ),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.only(right: 9.0),
          child: Icon(Icons.more_vert, size: 30, color: Colors.black),
        )
      ],
    );
  }
}
