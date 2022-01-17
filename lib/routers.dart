import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/business/login/login_page.dart';
import 'package:hatchery_im/business/login/register/register_page.dart';
import 'package:hatchery_im/business/profile_page/edit_profile/profile_edit_page.dart';
import 'package:hatchery_im/business/profile_page/friendProfile/friendInfoMore_page.dart';
import 'package:hatchery_im/business/splash/splash.dart';
import 'package:hatchery_im/business/test/TestPage.dart';
import 'package:hatchery_im/common/widget/qrCode/qr_scan.dart';
import 'package:hatchery_im/business/profile_page/qrcode_card.dart';
import 'package:hatchery_im/business/group_page/groupList.dart';
import 'package:hatchery_im/common/widget/selectContactsModel.dart';
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
import 'package:photo_view/photo_view.dart';
import 'business/chat_detail/chat_detail_page.dart';
import 'business/chat_detail/chat_setting.dart';
import 'business/contacts/contactsApply/receiveContactsApply.dart';
import 'business/contacts/contactsApply/sendContactsApply.dart';
import 'business/main_tab.dart';
import 'common/AppContext.dart';
import 'common/log.dart';
import 'package:hatchery_im/api/entity.dart';

import 'common/widget/chat_detail/videoMessageInfo/videoPlayPage.dart';
import 'common/widget/imageDetail.dart';
import 'common/widget/map_view.dart';

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
      case '/select_contacts_model':
        Map map = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
            builder: (_) => SelectContactsModelPage(
                  groupId: map['groupId'] ?? '',
                  titleText: map['titleText'],
                  leastSelected: map['leastSelected'],
                  nextPageBtnText: map['nextPageBtnText'],
                  tipsText: map['tipsText'],
                  selectContactsType: map['selectContactsType'],
                  contentType: map['contentType'],
                  shareMessageContent: map['shareMessageContent'],
                  groupMembersList: map['groupMembersList'] ?? [],
                ));
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
        Map map = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ChatDetailPage(
                  chatType: map['chatType'],
                  otherName: map['otherName'] ?? null,
                  otherIcon: map['otherIcon'] ?? null,
                  friendId: map['friendId'] ?? null,
                  groupId: map['groupId'] ?? '',
                  groupName: map['groupName'] ?? '',
                  groupIcon: map['groupIcon'] ?? '',
                ));
      case '/chat_setting':
        Map map = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ChatSettingPage(
                  otherId: map['otherId'] ?? '',
                  chatType: map['chatType'] ?? '',
                ));
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
        Map map = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => GroupProfilePage(
                  groupID: map['groupId'],
                  groupName: map['groupName'],
                  groupIcon: map['groupIcon'],
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
      case '/group_profile_edit_detail':
        Map map = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
            builder: (_) => GroupProfileEditDetailPage(
                  groupId: map['groupId'],
                  appBarText: map['appBarText'],
                  inputText: map['inputText'],
                  hintText: map['hintText'],
                  hideText: map['hideText'] ?? false,
                  maxLength: map['maxLength'],
                  maxLine: map['maxLine'] ?? 1,
                  onlyNumber: map['onlyNumber'] ?? false,
                  sendType: map['sendType'] ?? 0,
                ));
      case '/qrCode_scan':
        return MaterialPageRoute(builder: (_) => QRScanPage());
      case '/my_qrCode_card':
        return MaterialPageRoute(builder: (_) => QRCodeCardPage());
      case '/imageDetail':
        Map map = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => PhotoView(imageProvider: map["imageProvider"]));
      case '/video_play':
        Map map = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => VideoPlayPage(map["videoUrl"]));
      case '/map_view':
        Map map = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ShowMapPageBody(
                  mapOriginType: map['mapOriginType'],
                  addressName: map['address'],
                  position: map['position'],
                ));
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
