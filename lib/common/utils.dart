import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'theme.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:path_provider/path_provider.dart';
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

Widget dividerViewCommon() {
  return Divider(
    height: 0.5,
    thickness: 0.5,
    indent: 10,
    endIndent: 10,
    color: Flavors.colorInfo.dividerColor,
  );
}

/// 登录注册的渐变背景色
Widget mainBackGroundWidget() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF73AEF5),
          Color(0xFF61A4F1),
          Color(0xFF478DE0),
          Color(0xFF398AE5),
        ],
        stops: [0.1, 0.4, 0.7, 0.9],
      ),
    ),
  );
}

closeLoadingDialog(BuildContext context) {
  Navigator.pop(context, DialogDemoAction.cancel);
}

checkMessageTime(String createTime) {
  DateTime _responseCreateTime = DateTime.parse(createTime);
  DateTime _timeNow = DateTime.now();
  String _finalShowTime = '';
  int differenceTime = int.parse(
          '${_timeNow.year}${_timeNow.month}${_timeNow.day}') -
      int.parse(
          '${_responseCreateTime.year}${_responseCreateTime.month}${_responseCreateTime.day}');
  if (differenceTime == 0) {
    _finalShowTime =
        '${_responseCreateTime.hour}:${_responseCreateTime.minute}';
  } else if (differenceTime == 1) {
    _finalShowTime =
        '昨天 ${_responseCreateTime.hour}:${_responseCreateTime.minute}';
  } else if (differenceTime > 1 && differenceTime <= 7) {
    _finalShowTime =
        '${weekDay(_responseCreateTime.weekday)} ${_responseCreateTime.hour}:${_responseCreateTime.minute}';
  } else {
    _finalShowTime =
        '${_responseCreateTime.year}-${_responseCreateTime.month}-${_responseCreateTime.day} ${_responseCreateTime.hour}:${_responseCreateTime.minute}';
  }
  return _finalShowTime;
}

weekDay(int weekNumbers) {
  String weekCN = '';
  switch (weekNumbers) {
    case 1:
      weekCN = '星期一';
      break;
    case 2:
      weekCN = '星期二';
      break;
    case 3:
      weekCN = '星期三';
      break;
    case 4:
      weekCN = '星期四';
      break;
    case 5:
      weekCN = '星期五';
      break;
    case 6:
      weekCN = '星期六';
      break;
    case 7:
      weekCN = '星期日';
      break;
    default:
      weekCN = '';
      break;
  }
  return weekCN;
}

//时间转换 将秒转换为小时分钟
String? durationTransform(int seconds) {
  /// 时区问题 +8小时即可
  var d = Duration(seconds: seconds);
  List<String> parts = d.toString().split(':');
  return '${parts[1]}:${parts[2].split('.')[0]}';
}

/// 创建目录
folderCreate(String filepath) async {
  var file = Directory(filepath);
  try {
    bool exists = await file.exists();
    if (!exists) {
      await file.create();
    }
  } catch (e) {
    print(e);
  }
}

/// 删除文件
void deleteFile(String path) {
  Directory directory = Directory(path);
  if (directory.existsSync()) {
    List<FileSystemEntity> files = directory.listSync();
    if (files.length > 0) {
      files.forEach((file) {
        file.deleteSync();
      });
    }
    directory.deleteSync();
  }
}

class CacheInfo {
  ///加载缓存
  Future<String> loadCache() async {
    Directory tempDir = await getTemporaryDirectory();
    print("DEBUG=> tempDir ${tempDir.path}");
    double value = await _getTotalSizeOfFilesInDir(tempDir);
    /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
    return _renderSize(value);
  }

  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = []..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    print('临时目录大小: ' + (size + unitArr[index]));
    return (size + unitArr[index]).toString();
  }

  void clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
    //删除缓存目录
    await delDir(tempDir);
    await loadCache();
    showToast('清除缓存成功');
  }

  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await delDir(child);
      }
    }
    await file.delete();
  }
}
