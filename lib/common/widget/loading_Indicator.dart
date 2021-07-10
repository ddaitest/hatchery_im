import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndicatorView extends StatelessWidget {
  final String tipsText;
  IndicatorView({this.tipsText = '数据加载中...'});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 200.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(),
            SizedBox(
              height: 10.0.h,
            ),
            Container(
              child:
                  Text(tipsText, style: Flavors.textStyles.loginSubTitleText),
            ),
          ],
        ),
      ),
    );
  }
}
