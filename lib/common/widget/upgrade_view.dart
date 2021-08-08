import 'package:flutter/material.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showDialogFunction({upgradeInfo}) async {
  return showDialog<void>(
    context: App.navState.currentContext!,
    barrierDismissible: upgradeInfo.upgradeType == 1 ? true : false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: AlertDialog(
          scrollable: true,
          title: Text(
            "${upgradeInfo.title}",
          ),
          titlePadding: const EdgeInsets.only(
              left: 24.0, right: 24.0, top: 24.0, bottom: 20.0),
          //title 的内边距，默认 left: 24.0,top: 24.0, right 24.0
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '更新说明:',
                ),
                Container(
                  height: 8.0.h,
                ),
                Text(
                  '${upgradeInfo.newFeature}',
                ),
              ],
            ),
          ),
          contentPadding: const EdgeInsets.only(left: 24.0, right: 24.0),
          actions: <Widget>[
            upgradeInfo.upgradeType == 1
                ? TextButton(
                    child: Text("下次再说"),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  )
                : Container(),
            TextButton(
              child: Text("立即更新"),
              onPressed: () {
                //关闭 返回true
                Navigator.of(context).pop(true);
                launchUrl(upgradeInfo.apkUrl!);
              },
            ),
          ],
        ),
      );
    },
  );
}
