import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/busniess/login/login_page.dart';
import 'package:hatchery_im/busniess/login/register/register_page.dart';
import 'package:hatchery_im/busniess/login/register/register_page_detail.dart';
import 'package:hatchery_im/busniess/profile_page/edit_profile/profile_edit_page.dart';
import 'package:hatchery_im/busniess/group_page/createNewGroupDetail.dart';
import 'package:hatchery_im/busniess/splash/splash.dart';
import 'package:hatchery_im/busniess/test/TestPage.dart';
import 'package:hatchery_im/busniess/group_page/group.dart';
import 'package:hatchery_im/busniess/contacts/searchNewContacts.dart';
import 'package:hatchery_im/busniess/contacts/contactsApplication.dart';
import 'package:hatchery_im/busniess/login/phone/otp_page.dart';
import 'busniess/main_tab.dart';
import 'common/AppContext.dart';
import 'common/log.dart';

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
      case '/profile_edit':
        return MaterialPageRoute(builder: (_) => ProfileEditPage());
      // case '/create_group_detail':
      //   return MaterialPageRoute(builder: (_) => NewGroupDetailPage());
      case '/search_new_contacts':
        return MaterialPageRoute(builder: (_) => SearchNewContactsPage());
      // case '/contacts_application':
      //   return MaterialPageRoute(builder: (_) => ContactsApplicationPage());
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
