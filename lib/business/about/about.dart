import 'package:flutter/material.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/common/utils.dart';

class AboutPage extends StatelessWidget {
  static Map<String, dynamic> commonParamMap = DeviceInfo.info;

  @override
  Widget build(BuildContext context) {
    String version = commonParamMap['version'] ?? '';
    String vc = commonParamMap['vc'] ?? '';
    String wechatNumber = "86161190";
    String homePageUrl = "http://chenings.com";
    return Scaffold(
      appBar: AppBarFactory.getCommon("关于与帮助"),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: ListView(
              children: [
                _getItem("软件版本", "v $version.$vc"),
                _getItem("联系微信", wechatNumber, click: () {
                  copyData('$wechatNumber');
                  showToast('微信号复制成功');
                }),
                _getItem("官方网站", homePageUrl,
                    click: () => Routers.navWebView(homePageUrl)),
                _getItem("检查更新", "点击升级到最新版本", click: () => showUpgrade()),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () => Routers.navigateTo("/pact"),
                    child: Text("用户协议")),
                Container(width: 1, height: 10, color: Colors.black54),
                TextButton(
                    onPressed: () => Routers.navigateTo("/privacy"),
                    child: Text("隐私政策")),
              ],
            ),
          )
        ],
      ),
    );
  }

  _getItem(String title, String content, {VoidCallback? click}) {
    var child = (click == null)
        ? ListTile(
            title: Text(
              title,
            ),
            subtitle: Text(content),
          )
        : ListTile(
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text(
              title,
            ),
            subtitle: Text(content),
            onTap: click,
          );
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
        BoxShadow(color: Colors.black26),
      ]),
      child: child,
    );
  }
}
