import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendMenuItems {
  String? text;
  IconData? icons;
  MaterialColor? color;
  GestureTapCallback? onTap;
  SendMenuItems(
      {@required this.text,
      @required this.icons,
      @required this.color,
      @required this.onTap});
}
