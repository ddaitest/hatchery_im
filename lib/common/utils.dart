import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:ui' as ui;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'AppContext.dart';
import 'theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hatchery_im/common/widget/upgrade_view.dart';
import 'package:qr_flutter/qr_flutter.dart';

showUpgrade({int delayedSecond = 0}) {
  Future.delayed(Duration(seconds: delayedSecond), () {
    showDialogFunction();
  });
}

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

dialogModel(
    {CoolAlertType showType = CoolAlertType.info,
    bool showCancel = true,
    VoidCallback? confirmBtnTap,
    String? titleText,
    String? confirmText}) {
  return CoolAlert.show(
    context: App.navState.currentContext!,
    type: showType,
    showCancelBtn: showCancel,
    cancelBtnText: '取消',
    confirmBtnText: '确认',
    confirmBtnColor: Flavors.colorInfo.mainColor,
    onConfirmBtnTap: confirmBtnTap,
    title: '$titleText',
    text: "$confirmText",
  );
}

/// 保存图片到相册
Future<bool> saveImageToGallery(Uint8List? image) async {
  //检查是否有存储权限
  if (!await Permission.storage.status.isGranted) {
    PermissionStatus status = await Permission.storage.request();
    if (status.isDenied) {
      return false;
    }
  }
  final result = await ImageGallerySaver.saveImage(image!);
  if (result['isSuccess']) {
    return true;
  } else {
    return false;
  }
}

launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
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

Widget qrImageModel(
    {String key = '', String value = '', double imageSize = 320.0}) {
  String dataText = convert.jsonEncode({key: value});
  return QrImage(
    data: '$dataText',
    version: QrVersions.auto,
    size: imageSize,
    gapless: false,
  );
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

Widget dividerViewCommon({double indent = 10.0, double endIndent = 10.0}) {
  return Divider(
    height: 0.5,
    thickness: 0.5,
    indent: indent,
    endIndent: endIndent,
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

checkMessageTime(int createTime) {
  DateTime _responseCreateTime =
      DateTime.fromMillisecondsSinceEpoch(createTime);
  DateTime _timeNow = DateTime.now();
  String _finalShowTime = '';
  Duration differenceTime = _timeNow.difference(_responseCreateTime);
  if (differenceTime.inDays == 0) {
    _finalShowTime =
        '${_responseCreateTime.hour.toString().padLeft(2, '0')}:${_responseCreateTime.minute.toString().padLeft(2, '0')}';
  } else if (differenceTime.inDays == 1) {
    _finalShowTime =
        '昨天 ${_responseCreateTime.hour.toString().padLeft(2, '0')}:${_responseCreateTime.minute.toString().padLeft(2, '0')}';
  } else if (differenceTime.inDays > 1 && differenceTime.inDays < 7) {
    _finalShowTime =
        '${weekDay(_responseCreateTime.weekday)} ${_responseCreateTime.hour.toString().padLeft(2, '0')}:${_responseCreateTime.minute.toString().padLeft(2, '0')}';
  } else if (differenceTime.inDays >= 7) {
    _finalShowTime =
        '${_responseCreateTime.year}-${_responseCreateTime.month.toString().padLeft(2, '0')}-${_responseCreateTime.day.toString().padLeft(2, '0')} ${_responseCreateTime.hour.toString().padLeft(2, '0')}:${_responseCreateTime.minute.toString().padLeft(2, '0')}';
  } else {
    _finalShowTime =
        '${_responseCreateTime.year}-${_responseCreateTime.month.toString().padLeft(2, '0')}-${_responseCreateTime.day.toString().padLeft(2, '0')} ${_responseCreateTime.hour.toString().padLeft(2, '0')}:${_responseCreateTime.minute.toString().padLeft(2, '0')}';
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

chatHomeSubtitleSet(Message? contentMessage) {
  if (contentMessage != null) {
    String finalContent = '';
    switch (contentMessage.contentType) {
      case "TEXT":
        finalContent = convert.jsonDecode(contentMessage.content)["text"];
        break;
      case "IMAGE":
        finalContent = "[图片]";
        break;
      case "VIDEO":
        finalContent = "[视频]";
        break;
      case "VOICE":
        finalContent = "[语音]";
        break;
      case "GEO":
        finalContent = "[地理位置]";
        break;
      case "FILE":
        finalContent =
            "[文件] ${convert.jsonDecode(contentMessage.content)["name"]}";
        break;
      case "URL":
        finalContent = convert.jsonDecode(contentMessage.content)["url"];
        break;
      case "CARD":
        finalContent = "[名片]";
        break;
      default:
        finalContent = "[消息]";
        break;
    }
    return finalContent;
  } else {
    return "";
  }
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
    try {
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      return _renderSize(value);
    } catch (e) {
      double value = 0.0;
      return _renderSize(value);
    }

    /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
  }

  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
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
    List<String> unitArr = []
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
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

/// 资料页根据key返回title
String profileTitle(String keyName) {
  String keyCHN = '';
  switch (keyName) {
    case 'loginName':
      keyCHN = '用户名';
      break;
    case 'nickName':
      keyCHN = '昵称';
      break;
    case 'notes':
      keyCHN = '个人签名';
      break;
    case 'phone':
      keyCHN = '手机号';
      break;
    case 'email':
      keyCHN = '电子邮箱';
      break;
    case 'address':
      keyCHN = '地址';
      break;
    case 'createTime':
      keyCHN = '账号创建时间';
      break;
    default:
      keyCHN = keyName;
      break;
  }
  return keyCHN;
}

/// 接收好友邀请状态文案展示
String receiveContactsApplyStatusText(int status) {
  String statusText = '';
  switch (status) {
    case 1:
      statusText = '已同意';
      break;
    case 0:
      statusText = '同意';
      break;
    case -1:
      statusText = '已拒绝';
      break;
    default:
      statusText = '';
      break;
  }
  return statusText;
}

/// 发送好友邀请状态文案展示
String sendContactsApplyStatusText(int status) {
  String statusText = '';
  switch (status) {
    case 1:
      statusText = '已同意';
      break;
    case 0:
      statusText = '申请中';
      break;
    case -1:
      statusText = '已拒绝';
      break;
    default:
      statusText = '';
      break;
  }
  return statusText;
}
