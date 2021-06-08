import 'package:flutter/material.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/AppContext.dart';

class AppBarFactory {
  static AppBar getMain(String title,
      {Color backGroundColorList = Colors.transparent, List<Widget>? actions}) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w500),
      ),
      centerTitle: false,
      backgroundColor: backGroundColorList,
      brightness: Brightness.light,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: actions ?? [],
    );
  }

  static AppBar getCommon(String title) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      brightness: Brightness.light,
      automaticallyImplyLeading: true,
      elevation: 0.0,
    );
  }

  static AppBar backButton(String title,
      {Color backGroundColor = Colors.transparent,
      Color backBtnColor = Colors.white,
      List<Widget>? actions}) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      backgroundColor: backGroundColor,
      brightness: Brightness.light,
      elevation: 0.0,
      leading: Container(
        padding: const EdgeInsets.all(6.0),
        child: IconButton(
          icon: Icon(Icons.arrow_back, size: 30.0, color: Colors.black),
          onPressed: () => Navigator.of(App.navState.currentContext!).pop(),
        ),
      ),
      automaticallyImplyLeading: false,
      actions: actions ?? [],
    );
  }
}
