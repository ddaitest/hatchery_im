import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/flavors/Flavors.dart';

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
