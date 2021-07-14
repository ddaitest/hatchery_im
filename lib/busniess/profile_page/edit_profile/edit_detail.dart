import 'package:flutter/material.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';

class NormalProfileEditPage extends StatelessWidget {
  final String appBarText;
  final String trailingText;
  final GestureTapCallback? onTap;
  NormalProfileEditPage(this.appBarText, {this.trailingText = '', this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.backButton('$appBarText', actions: [
        Container(
            padding: const EdgeInsets.all(6.0),
            child: TextButton(
              onPressed: () {},
              child: Text(
                '保存',
                style: Flavors.textStyles.newGroupNextBtnText,
              ),
            )),
      ]),
      body: Container(),
    );
  }
}
