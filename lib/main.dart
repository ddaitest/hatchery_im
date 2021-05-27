import 'package:flutter/material.dart';
import 'package:hatchery_im/routers.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'common/AppContext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  if (Platform.isAndroid) {
    SystemUiOverlayStyle style = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

        ///这是设置状态栏的图标和字体的颜色
        ///Brightness.light  一般都是显示为白色
        ///Brightness.dark 一般都是显示为黑色
        statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  /// 强制竖屏
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: App.navState,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        onGenerateRoute: Routers.generateRoute,
      ),
    );
  }
}
