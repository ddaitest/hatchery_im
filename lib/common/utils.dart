import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'theme.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/config.dart';

void showToast(String title,
    {Toast toastTime = Toast.LENGTH_SHORT,
    ToastGravity showGravity = ToastGravity.CENTER}) {
  Fluttertoast.showToast(
      msg: title,
      toastLength: toastTime,
      gravity: showGravity,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[200],
      textColor: Flavors.colorInfo.diver,
      fontSize: 15.0);
}

Future<void> exitApp() async {
  if (Platform.isAndroid) {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  } else if (Platform.isIOS) {
    exit(0);
  } else {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    exit(0);
  }
}

copyData(String text) {
  Clipboard.setData(ClipboardData(text: text));
}

Future<bool> isNetworkConnect() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult != ConnectivityResult.none) {
    return true;
  } else {
    return false;
  }
  // if (connectivityResult == ConnectivityResult.mobile) {
  //   // I am connected to a mobile network.
  // } else if (connectivityResult == ConnectivityResult.wifi) {
  //   // I am connected to a wifi network.
  // }
}

getRoundIcon(IconData icon) {
  return Container(
    width: 36,
    height: 36,
    child: Icon(
      icon,
      color: Colors.white,
      size: 22,
    ),
    decoration: BoxDecoration(
      color: colorPrimary,
      shape: BoxShape.circle,
      border: Border.all(color: colorPrimary, width: 2),
    ),
  );
}

Widget getAvatar(String url, {int? size}) {
  return Container(
    width: 36,
    height: 36,
    child: CachedNetworkImage(
      imageUrl: url,
      height: (size ?? 22).toDouble(),
      width: (size ?? 22).toDouble(),
      color: Colors.white,
    ),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: colorPrimary, width: 2),
    ),
  );
}

Widget getMainIcon(int publishType, {int? size}) {
  if (publishType != 1) {
    return Container(
      width: 36,
      height: 36,
      child: Icon(
        Icons.directions_car,
        color: Colors.white,
        size: 22,
      ),
      decoration: BoxDecoration(
        color: colorPrimary,
        shape: BoxShape.circle,
        border: Border.all(color: colorPrimary, width: 2),
      ),
    );
  } else {
    return Container(
      width: 36,
      height: 36,
      child: Icon(
        Icons.record_voice_over,
        color: Colors.white,
        size: 22,
      ),
      decoration: BoxDecoration(
        color: colorPrimary,
        shape: BoxShape.circle,
        border: Border.all(color: colorPrimary, width: 2),
      ),
    );
  }
}

/// return A positive number if a>b , negative number if a<b , 0 if a=b
int compareVersion(String a, String b) {
  var as = a.split(".").map((string) => int.tryParse(string));
  var bs = b.split(".").map((string) => int.tryParse(string));
  int? x;
  int? y;
  for (var i = 0; i < as.length; i++) {
    x = as.elementAt(i);
    y = bs.elementAt(i);
    if (x != y) {
      break;
    }
  }
  return (x ?? 0) - (y ?? 0);
}

///获取升级和弹窗广告数据
///如果有升级弹窗出现则不弹广告弹窗，如没有升级则弹广告弹窗，根据isForce判断
getDialogData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map dataMap = Map();
  dataMap["isForce"] = prefs.getBool("is_force") ?? false;
  dataMap["version"] = prefs.getString("version") ?? '';
  dataMap["buildName"] = prefs.getInt("build_name") ?? 0;
  dataMap["message"] = prefs.getString("message") ?? '';
  dataMap["iosUrl"] = prefs.getString("ios_url") ?? '';
  dataMap["androidUrl"] = prefs.getString("android_url") ?? '';
  dataMap["showCardUrl"] = prefs.getString("showCard_url") ?? "";
  dataMap["showCardGoto"] = prefs.getString("showCard_goto") ?? "";
  return dataMap;
}

showSnackBar(BuildContext context, String word) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(word, textAlign: TextAlign.center),
    backgroundColor: colorPrimary,
  ));
}

enum DialogDemoAction {
  cancel,
  discard,
  disagree,
  agree,
}

Future<DialogDemoAction?>? showLoadingDialog(
    BuildContext context, String word) {
  return showDialog<DialogDemoAction>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(word),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                LinearProgressIndicator(),
              ],
            ),
          ),
        );
      });
}

closeLoadingDialog(BuildContext context) {
  Navigator.pop(context, DialogDemoAction.cancel);
}
