import 'package:flutter/material.dart';

class AgreementPageTextStyle {
  /// 协议title
  TextStyle mainTitle = TextStyle(
      fontSize: 19.0, color: Colors.black, fontWeight: FontWeight.w500);

  /// 协议提示文字
  TextStyle agreementText =
      TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400);

  /// 确认按钮
  TextStyle confirmBtn = TextStyle(fontSize: 18.0);

  /// 关闭app按钮
  TextStyle closeAppBtn = TextStyle(color: Colors.grey, fontSize: 14);
}

ThemeData getTheme() {
  return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      backgroundColor: Colors.white,
//      unselectedWidgetColor: Colors.grey,
      textTheme: TextTheme(subhead: textStyleLabel));
}

const Color colorPrimaryDark = const Color(0xff203152);
const Color colorPrimary = const Color(0xff5680fa);
const Color colorGrey = const Color(0xff7C8698);
const Color colorGrey2 = const Color(0xffD6D6D6);
const Color colorPick = Color(0xFF13D3CE);
const Color colorDrop = Color(0xFFFF7200);

const Color c1 = Color(0xFF222222);
const Color c2 = Color(0xFF444444);
const Color c3 = Color(0xFFD8D8D8);

const TextStyle fontPhone =
    const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: c1);

const TextStyle textStyleInfo = const TextStyle(fontSize: 16.0, color: c2);

const TextStyle fontTime1 = const TextStyle(fontSize: 16.0, color: c3);
const TextStyle fontTime2 = const TextStyle(fontSize: 16.0, color: colorPick);

const TextStyle fontCall =
    TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500);

const TextStyle textStyle1 = const TextStyle(
  fontSize: 30.0,
  color: colorPrimaryDark,
);

const TextStyle textStyle2 = const TextStyle(
  fontSize: 14.0,
  color: const Color(0xff7C8698),
);

const TextStyle textStyle3 = const TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
  color: colorPrimary,
);

const TextStyle textStyleLabel = const TextStyle(
  fontSize: 14.0,
  color: colorGrey,
);

const TextStyle textStylePublish = const TextStyle(
  fontSize: 20.0,
  color: colorPrimaryDark,
);

const TextStyle textButtonSmall = const TextStyle(
  fontSize: 14.0,
  color: Colors.white,
);

///发布 和 搜索中 输入框的样式，主要是下划线和label
InputDecoration getDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: textStyleLabel,
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: colorGrey)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[200]!)),
    counterText: '',
  );
}

///发布 和 搜索中 Container 背景的样式
BoxDecoration getContainerBg(double radius) {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey[200]!,
          blurRadius: 10.0,
          spreadRadius: 5.0,
        )
      ]);
}

///列表中 每个ITEM Container 背景的样式
BoxDecoration getContainerBg2({double? radius}) {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(radius ?? 10.0),
      border: Border.all(color: Colors.grey[400]!, width: 0.5),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey[200]!,
          blurRadius: 10.0,
        )
      ]);
}

const PADDING = SizedBox(height: 8);
const PADDING_H = SizedBox(width: 8);

MaterialButton getButtonBig(String text, {VoidCallback? onPressed}) {
  return MaterialButton(
    height: 55,
    elevation: 4,
    color: colorPrimary,
    onPressed: onPressed,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(100))),
    child: Text(text, style: TextStyle(color: Colors.white)),
  );
}
