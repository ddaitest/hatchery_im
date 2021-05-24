import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/tools.dart';
import 'dart:convert';
import 'package:hatchery_im/config.dart';

class AppID {
  final client_id = '36ff662f-3041-5c10-8bde-65e6fb86523b';
  final serviceAd = 'tab1';
  final serviceTab1 = 'tab1';
  final serviceTab2 = 'tab2';
  final serviceTab3 = 'tab3';
}

class StringsInfo {
  final community_name = "新雅名轩";
  final community_info = "智能物业、服务业主";
  final post_title = "物业公告";
  final articles_title = "便民信息";
  final agreement_card_text =
      '欢迎使用本软件\n在您使用本软件前，请您认真阅读并同意用户协议和隐私政策，我们将严格按照用户协议和隐私政策为您提供服务，保护您的个人信息。';
  final user_agreement_url = 'https://www.baidu.com/';
  final privacy_agreement_url = 'https://www.sina.com.cn/';

  final refresh_complete = "刷新成功";
  final refresh_fail = "刷新失败";
  final load_fail = "加载失败";
  final loading = "加载中...";
  final load_complete = "加载成功";
  final load_no_data = "没有更多数据";
}

class ApiInfo {
  final String API_HOST = 'http://106.12.147.150:8080/';
  final int RESPONSE_STATUS_CODE = 100000;
  final int API_CONNECT_TIMEOUT = 60000;
  final int API_RECEIVE_TIMEOUT = 60000;
  final String CONTENT_TYPE = 'application/json';
  final String BASIC_AUTH =
      'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImlzcyI6IjM2ZmY2NjJmLTMwNDEtNWMxMC04YmRlLTY1ZTZmYjg2NTIzYiIsImV4cCI6MTYxNzg5MDkzM30.6-zJZ5Eoq83mx1KAdWs6Fr6gm4wkdXV49tlqKAKJOrU';
}

class TextStyles {
  final TextStyle title = TextStyle(fontSize: 27.0.sp, color: Colors.black87);

  final TextStyle title1 = TextStyle(fontSize: 20.0.sp, color: Colors.black87);

  final TextStyle title2 = TextStyle(fontSize: 18.0.sp, color: Colors.black87);

  final TextStyle content = TextStyle(fontSize: 16.0.sp, color: Colors.black54);

  final TextStyle secondary =
      TextStyle(fontSize: 16.0.sp, color: Colors.black38);

  /// mainTab未选中时的字体样式
  final TextStyle tabBarTextUnSelected = TextStyle(
      fontSize: 10.0.sp, fontWeight: FontWeight.w400, color: Color(0x8A000000));

  /// mainTab选中时的字体样式
  final TextStyle tabBarTextSelected = TextStyle(
      fontSize: 10.0.sp, fontWeight: FontWeight.w400, color: Color(0xFF006EE7));

  /// 协议title
  final TextStyle agreementTitle = TextStyle(
      fontSize: 16.0.sp, color: Color(0xDE000000), fontWeight: FontWeight.w500);

  /// 协议提示文字
  final TextStyle agreementText = TextStyle(
      fontSize: 14.0.sp, color: Colors.grey, fontWeight: FontWeight.w400);

  /// 协议文字样式
  final TextStyle agreementLink =
      TextStyle(decoration: TextDecoration.underline, color: Color(0xFF006EE7));

  /// 确认按钮
  final TextStyle agreementConfirmBtn = TextStyle(
      fontSize: 16.0.sp, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w500);

  /// 关闭app按钮
  final TextStyle agreementCloseAppBtn = TextStyle(
      fontSize: 14.0.sp, color: Color(0x61000000), fontWeight: FontWeight.w400);

  /// 开屏倒计时
  final TextStyle splashFont = TextStyle(
      fontSize: 16.0.sp, fontWeight: FontWeight.w400, color: Colors.white);

  /// 分类主标题，如：物业公告
  final TextStyle sortTitle = TextStyle(
      fontWeight: FontWeight.w400, fontSize: 16.0.sp, color: Color(0xFF333333));

  /// 分类更多按钮
  final TextStyle moreText = TextStyle(
      fontWeight: FontWeight.w500, fontSize: 14.0.sp, color: Color(0xFF666666));

  /// service text
  final TextStyle serviceTitle = TextStyle(
      fontSize: 12.0.sp, fontWeight: FontWeight.w400, color: Color(0xFF666666));

  /// 软文主标题
  final TextStyle articleTitle =
      TextStyle(fontSize: 14.0.sp, color: Color(0xDE000000));

  /// 软文副标题
  final TextStyle articleSummary =
      TextStyle(fontSize: 12.0.sp, color: Color(0x61000000));

  /// 软文日期
  final TextStyle articleDate =
      TextStyle(fontSize: 18.0.sp, color: Colors.black38);

  /// 通知文字
  final TextStyle noticeText =
      TextStyle(fontSize: 14.0.sp, color: Color(0xFF333333));

  /// 报事报修列表时间
  final TextStyle feedBackCreateTime = TextStyle(
      fontSize: 15.0.sp, color: Color(0xFF333333), fontWeight: FontWeight.w400);

  /// 报事报修主标题
  final TextStyle feedBackTitle = TextStyle(
      fontSize: 15.0.sp, color: Color(0xFF666666), fontWeight: FontWeight.w400);

  /// 报事报修副标题
  final TextStyle feedBackSummary = TextStyle(
      fontSize: 13.0.sp, color: Color(0xFF999999), fontWeight: FontWeight.w400);

  /// 联系物业title
  final TextStyle contactTitle = TextStyle(
      fontSize: 16.0.sp, color: Color(0xFF333333), fontWeight: FontWeight.w500);

  /// 联系物业电话
  final TextStyle contactPhone = TextStyle(
      fontSize: 15.0.sp, color: Colors.redAccent, fontWeight: FontWeight.w400);

  /// 联系物业副标题
  final TextStyle contactSummary = TextStyle(
      fontSize: 14.0.sp, color: Color(0xFF999999), fontWeight: FontWeight.w400);

  /// 反馈&报事报修详情页内容
  final TextStyle feedBackDetailText = TextStyle(
      fontSize: 16.0.sp, color: Color(0xFF000000), fontWeight: FontWeight.w400);

  /// 反馈&报事报修详情页标分类文字
  final TextStyle feedBackDetailSort = TextStyle(
      fontSize: 16.0.sp, color: Color(0xFF666666), fontWeight: FontWeight.w400);

  /// 问题反馈提交按钮文字
  final TextStyle submitButtonText = TextStyle(
      fontSize: 15.0.sp, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w500);

  /// 升级提醒主标题
  final TextStyle upgradeTitle = TextStyle(
      fontSize: 18.0.sp, fontWeight: FontWeight.w400, color: Color(0xDE000000));

  /// 升级提醒主标题
  final TextStyle upgradeDesc =
      TextStyle(fontSize: 14.0.sp, color: Color(0xFF666666), height: 1.5);
}

class SizesInfo {
  final articleItemHeight = 120.0;
  final articleThumbnail = 100.0;
  final postItemHeight = 60.0;
  final screenWidth = 1.sw; // 屏幕宽度
  final screenHeight = 1.sh; // 屏幕高度
}

class ColorInfo {
  final diver = Colors.black87;
  final homeTabSelected = const Color(0xFF006EE7);
  final homeTabUnSelected = const Color(0x8A000000);
}
