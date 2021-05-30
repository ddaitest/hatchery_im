import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/busniess/login/login_page.dart';
import 'package:hatchery_im/busniess/login/register_page.dart';
import 'busniess/main_tab.dart';
import 'common/AppContext.dart';
import 'common/log.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainTab());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());
      // case '/splash':
      //   return CupertinoPageRoute(builder: (_) => SplashPage());
      // case '/feedback_list':
      //   return CupertinoPageRoute(builder: (_) => FeedbackListPage());
      // case '/feedback_new':
      //   return CupertinoPageRoute(builder: (_) => FeedbackNewPage());
      // case '/contact':
      //   return CupertinoPageRoute(builder: (_) => ContactPage());
      // case '/repairs_list':
      //   return CupertinoPageRoute(builder: (_) => RepairListPage());
      // case '/repairs_new':
      //   return CupertinoPageRoute(builder: (_) => RepairNewPage());
      // case '/nearby':
      //   return CupertinoPageRoute(builder: (_) => NearbyTab());
      // case '/about':
      //   return CupertinoPageRoute(builder: (_) => About());
      // case '/privacy':
      //   return CupertinoPageRoute(builder: (_) => PactPage(1));
      // case '/pact':
      //   return CupertinoPageRoute(builder: (_) => PactPage(0));
      // case '/feed_back_detail':
      //   return CupertinoPageRoute(builder: (_) => FeedBackDetail());
      // case '/list_page':
      //   Map map = settings.arguments as Map<String, String>;
      //   return CupertinoPageRoute(
      //       builder: (_) => ListPage(map["title"], map["serviceId"]));
      // case '/web_view':
      //   //跳转 web view, 解析对应参数。
      //   Map map = settings.arguments as Map<String, String>;
      //   return CupertinoPageRoute(
      //       builder: (_) =>
      //           WebViewPage(map["url"], map["path"], map["title"] ?? ""));
      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }

  ///一般跳转，无参数
  static Future<dynamic> navigateTo(String routeName, {Object? arg}) {
    return App.navState.currentState!.pushNamed(routeName, arguments: arg);
  }

  static Future<dynamic> navigateReplace(String routeName, {Object? arg}) {
    Log.log("navigateReplace $routeName", color: LColor.RED);
    return App.navState.currentState!
        .pushReplacementNamed(routeName, arguments: arg);
  }

  ///跳转  WebView, 带参数的页面建议单独定义
  static Future<dynamic> navWebView(String url, {String? path, String? title}) {
    return navigateTo('/web_view',
        arg: {"url": url, "path": path ?? "", "title": title ?? ""});
  }

  static Future<dynamic> navWebViewReplace(String url,
      {String? path, String? title}) {
    return navigateReplace('/web_view',
        arg: {"url": url, "path": path ?? "", "title": title ?? ""});
  }

  ///跳转  WebView, 带参数的页面建议单独定义
  static Future<dynamic> navListPage(String title, String serviceId) {
    return navigateTo('/list_page',
        arg: {"title": title, "serviceId": serviceId});
  }
}
