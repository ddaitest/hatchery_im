import 'package:flutter/material.dart';
import 'package:hatchery_im/routers.dart';

class AppBarFactory {
  static AppBar getMain(String title, {List<Widget>? actions}) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w500),
      ),
      centerTitle: false,
      backgroundColor: Colors.white,
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
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      automaticallyImplyLeading: true,
      elevation: 0.5,
    );
  }

  static AppBar getRoute(String title, String? routeName) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      elevation: 0.5,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Routers.navigateReplace(routeName!),
      ),
      automaticallyImplyLeading: false,
    );
  }
}
