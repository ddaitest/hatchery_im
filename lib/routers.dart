import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/business/login/login_page.dart';
import 'package:hatchery_im/business/login/register/register_page.dart';
import 'package:hatchery_im/business/profile_page/edit_profile/profile_edit_page.dart';
import 'package:hatchery_im/business/profile_page/friendProfile/friendInfoMore_page.dart';
import 'package:hatchery_im/business/splash/splash.dart';
import 'package:hatchery_im/business/test/TestPage.dart';
import 'package:hatchery_im/business/group_page/group.dart';
import 'package:hatchery_im/business/search/searchNewContacts.dart';
import 'package:hatchery_im/business/profile_page/friendProfile/friendProfile_page.dart';
import 'package:hatchery_im/business/profile_page/friendProfile/friendSetting_page.dart';
import 'package:hatchery_im/business/block/blockList.dart';
import 'package:hatchery_im/business/login/phone/otp_page.dart';
import 'package:hatchery_im/business/about/about.dart';
import 'package:hatchery_im/business/profile_page/friendProfile/friendApply_page.dart';
import 'package:hatchery_im/common/widget/profile/edit_detail.dart';
import 'package:hatchery_im/business/group_page/group_profile/group_profile.dart';
import 'package:hatchery_im/common/widget/webview_common.dart';
import 'business/chat_detail/chat_detail_page.dart';
import 'business/contacts/contactsApply/receiveContactsApply.dart';
import 'business/contacts/contactsApply/sendContactsApply.dart';
import 'business/main_tab.dart';
import 'common/AppContext.dart';
import 'common/log.dart';
import 'package:hatchery_im/api/entity.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainTab());
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case '/phone_login':
        return MaterialPageRoute(builder: (_) => OTPPage());
      case '/group':
        return MaterialPageRoute(builder: (_) => GroupPage());
      case '/friend_profile':
        return MaterialPageRoute(
            builder: (_) => FriendProfilePage(
                  userID: settings.arguments as String,
                ));
      case '/profile_edit':
        return MaterialPageRoute(builder: (_) => ProfileEditPage());
      case '/friend_info_more':
        return MaterialPageRoute(
            builder: (_) => FriendInfoMorePage(
                  settings.arguments as UsersInfo,
                ));
      case '/friend_setting':
        return MaterialPageRoute(
            builder: (_) => FriendSettingPage(
                  friendId: settings.arguments.toString(),
                ));
      case '/friend_apply':
        return MaterialPageRoute(
            builder: (_) => FriendApplyPage(
                  usersID: settings.arguments.toString(),
                ));
      case '/block_list':
        return MaterialPageRoute(builder: (_) => BlockListPage());
      case '/chat_detail':
        return MaterialPageRoute(
            builder: (_) =>
                ChatDetailPage(usersInfo: settings.arguments as UsersInfo));
      case '/search_new_contacts':
        return MaterialPageRoute(builder: (_) => SearchNewContactsPage());
      case '/about':
        return MaterialPageRoute(builder: (_) => AboutPage());
      case '/receive_contacts_apply':
        return MaterialPageRoute(builder: (_) => ReceiveContactsApplyPage());
      case '/send_contacts_apply':
        return MaterialPageRoute(builder: (_) => SendContactsApplyPage());
      case '/web_view':
        //跳转 web view, 解析对应参数。
        Map map = settings.arguments as Map<String, String>;
        return CupertinoPageRoute(
            builder: (_) =>
                WebViewPage(map["url"], map["path"], map["title"] ?? ""));
      case '/group_profile':
        return MaterialPageRoute(
            builder: (_) => GroupProfilePage(
                  groupID: settings.arguments as String,
                ));
      case '/profile_edit_detail':
        Map map = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
            builder: (_) => ProfileEditDetailPage(
                appBarText: map['appBarText'],
                inputText: map['inputText'],
                hintText: map['hintText'],
                hideText: map['hideText'] ?? false,
                maxLength: map['maxLength'],
                maxLine: map['maxLine'] ?? 1,
                onlyNumber: map['onlyNumber'] ?? false));
      case '/test':
        return MaterialPageRoute(builder: (_) => TestPage());
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

  static Future<dynamic> navigateAndRemoveUntil(String routeName,
      {Object? arg}) {
    return App.navState.currentState!.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arg);
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
