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
  final TextStyle contactsIconTextSelect = TextStyle(
      fontSize: 16.0.sp, fontWeight: FontWeight.w500, color: Color(0x8A000000));

  final TextStyle contactsIconTextUnSelect = TextStyle(
      fontSize: 16.0.sp,
      fontWeight: FontWeight.w400,
      color: Colors.grey.shade400);

  final TextStyle groupMainName = TextStyle(
      fontSize: 16.0.sp,
      fontWeight: FontWeight.w500,
      color: Color.fromRGBO(3, 3, 3, 1));

  final TextStyle groupMembersNumberText = TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.w400,
      color: Color.fromRGBO(169, 178, 199, 1));

  final TextStyle loginMainTitleText = TextStyle(
      fontSize: 36.0.sp,
      fontWeight: FontWeight.w500,
      color: Color.fromRGBO(47, 128, 237, 1));

  final TextStyle loginInputTitleText = TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.w400,
      color: Color.fromRGBO(47, 128, 237, 1));

  final TextStyle loginLinkText = TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.w500,
      color: Color.fromRGBO(47, 128, 237, 1));
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
