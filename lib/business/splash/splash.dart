import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/manager/splash_manager/splashManager.dart';
import 'package:hatchery_im/manager/app_manager/appManager.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _appManager = App.manager<AppManager>();
  final _splashManager = App.manager<SplashManager>();

  @override
  void initState() {
    _appManager.init();
    // _splashManager.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 素材比例适配，需放到第一个页面且只需要一次就行
    ScreenUtil.init(App.navState.currentContext!,
        minTextAdapt: true, orientation: Orientation.portrait);
    return Scaffold(
      body: _fullScreenBackgroundView(),
    );
  }

  Widget _fullScreenBackgroundView() {
    print('DEBUG=> _fullScreenBackgroundView 重绘了。。。。。。。。。。');
    return Container(
      height: Flavors.sizesInfo.screenHeight,
      width: Flavors.sizesInfo.screenWidth,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 200.0),
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
      child: DefaultTextStyle(
        style: Flavors.textStyles.splashLogoText,
        child: AnimatedTextKit(
          animatedTexts: [
            WavyAnimatedText('BEE IM'),
          ],
          isRepeatingAnimation: false,
          onFinished: () {
            _splashManager.goto();
          },
        ),
      ),
    );
  }
}
