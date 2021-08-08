import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndicatorView extends StatelessWidget {
  final String tipsText;
  final bool showLoadingIcon;
  IndicatorView({this.tipsText = '数据加载中...', this.showLoadingIcon = true});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showLoadingIcon ? CupertinoActivityIndicator() : Container(),
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
      ),
    );
  }
}
