import 'package:flutter/material.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';

class GroupProfileMenuItem extends StatelessWidget {
  final String? titleText;
  final String trailingText;
  final int trailingTextMaxLine;
  final GestureTapCallback? onTap;
  final bool showDivider;
  final Widget? trailingView;
  GroupProfileMenuItem(
      {this.titleText,
      this.trailingText = '',
      this.trailingTextMaxLine = 1,
      this.onTap,
      this.showDivider = true,
      this.trailingView});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Flavors.colorInfo.mainBackGroundColor,
        child: Column(
          children: <Widget>[
            ListTile(
              dense: false,
              title: Text(
                titleText ?? '',
                style: Flavors.textStyles.meListTitleText,
              ),
              trailing: Container(
                constraints:
                    BoxConstraints(maxWidth: 200.0.w, minWidth: 30.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      constraints:
                          BoxConstraints(maxWidth: 150.0.w, minWidth: 30.0.w),
                      child: Text(
                        trailingText,
                        maxLines: trailingTextMaxLine,
                        overflow: TextOverflow.ellipsis,
                        style: Flavors.textStyles.loginSubTitleText,
                      ),
                    ),
                    SizedBox(width: 5.0.w),
                    trailingView == null
                        ? Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 15.0,
                          )
                        : trailingView!,
                  ],
                ),
              ),
              onTap: onTap,
            ),
            showDivider ? dividerViewCommon() : Container(),
          ],
        ));
  }
}
