import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/manager/splashManager.dart';
import 'package:hatchery_im/manager/appManager.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AppManager _appManager = App.manager<AppManager>();
  SplashManager _splashManager = App.manager<SplashManager>();

  @override
  void initState() {
    _appManager.init();
    _splashManager.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder:
        (BuildContext context, SplashManager splashManager, Widget? child) {
      return Scaffold(
        backgroundColor: Flavors.colorInfo.mainColor,
        body: _fullScreenBackgroundView(splashManager),
      );
    });
  }

  Widget _fullScreenBackgroundView(splashManager) {
    print('DEBUG=> _fullScreenBackgroundView 重绘了。。。。。。。。。。');
    return Container(
      height: double.infinity,
      width: double.infinity,
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
            WavyAnimatedText('BEE  IM'),
          ],
          isRepeatingAnimation: false,
          onFinished: () {
            splashManager.goto();
          },
        ),
      ),
    );
  }
}
