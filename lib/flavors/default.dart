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
  final String API_HOST = 'http://119.23.74.10:5858/api';
  final String File_UPLOAD_PATH = 'http://119.23.74.10:5858/resources';
  final int API_CONNECT_TIMEOUT = 600000;
  final int API_RECEIVE_TIMEOUT = 600000;
  final String CONTENT_TYPE = 'application/json';
}

class TextStyles {
  final TextStyle mainPopText = TextStyle(
      fontSize: 13.0.sp,
      fontWeight: FontWeight.normal,
      color: ColorInfo().darkGreyColor);
  final TextStyle noDataText = TextStyle(
      fontSize: 16.0.sp,
      fontWeight: FontWeight.w400,
      color: ColorInfo().subtitleColor);

  final TextStyle splashLogoText = TextStyle(
      fontSize: 52.0.sp,
      fontWeight: FontWeight.bold,
      color: ColorInfo().mainTextColor);

  final TextStyle contactsIconTextSelect = TextStyle(
      fontSize: 16.0.sp, fontWeight: FontWeight.w500, color: ColorInfo().diver);

  final TextStyle contactsIconTextUnSelect = TextStyle(
      fontSize: 16.0.sp,
      fontWeight: FontWeight.w400,
      color: ColorInfo().subtitleColor);

  final TextStyle groupMainName = TextStyle(
      fontSize: 14.0.sp, fontWeight: FontWeight.w500, color: ColorInfo().diver);

  final TextStyle groupMembersNumberText =
      TextStyle(fontSize: 12.0.sp, color: ColorInfo().subtitleColor);

  final TextStyle groupMembersMoreText = TextStyle(
      fontSize: 9.0.sp,
      fontWeight: FontWeight.w500,
      color: ColorInfo().mainTextColor);

  final TextStyle loginNormalText = TextStyle(
    fontSize: 14.0.sp,
    color: ColorInfo().mainTextColor,
    fontWeight: FontWeight.normal,
  );

  final TextStyle loginMainTitleText = TextStyle(
      fontSize: 30.0.sp,
      fontWeight: FontWeight.w500,
      color: ColorInfo().mainTextColor);

  final TextStyle loginSubTitleText = TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.w400,
      color: ColorInfo().subtitleColor);

  final TextStyle hintTextText = TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.w400,
      color: ColorInfo().mainTextColor);

  final TextStyle otpText = TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.w400,
      color: ColorInfo().darkGreyColor);

  final TextStyle loginLinkText = TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.bold,
      color: ColorInfo().mainTextColor);

  final TextStyle loginInButtonText = TextStyle(
      fontSize: 18.0.sp,
      fontWeight: FontWeight.bold,
      color: ColorInfo().btnTextColor);

  final TextStyle friendsText = TextStyle(
      fontSize: 15.0.sp, fontWeight: FontWeight.w400, color: ColorInfo().diver);

  final TextStyle friendsSubtitleText = TextStyle(
      fontSize: 13.0.sp,
      fontWeight: FontWeight.w400,
      color: ColorInfo().subtitleColor);

  final TextStyle meNickNameText = TextStyle(
      fontSize: 19.0.sp, fontWeight: FontWeight.w500, color: ColorInfo().diver);

  final TextStyle meNotesText = TextStyle(
      fontSize: 15.0.sp, fontWeight: FontWeight.w300, color: ColorInfo().diver);

  final TextStyle meListTitleText = TextStyle(
      fontSize: 15.0.sp, fontWeight: FontWeight.w400, color: ColorInfo().diver);

  final TextStyle meListSettingText = TextStyle(
      fontSize: 15.0.sp, fontWeight: FontWeight.w300, color: ColorInfo().diver);

  final TextStyle newGroupSettingTitleText = TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.normal,
      color: ColorInfo().mainColor);

  final TextStyle newGroupNextBtnText = TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.w500,
      color: ColorInfo().btnTextColor);

  final TextStyle chatDetailAppBarNameText = TextStyle(
      fontSize: 15.0.sp, fontWeight: FontWeight.w600, color: ColorInfo().diver);

  final TextStyle chatBubbleSenderText = TextStyle(
      fontSize: 13.0.sp, color: ColorInfo().mainTextColor, height: 1.5);

  final TextStyle chatBubbleReceiverText =
      TextStyle(fontSize: 13.0.sp, color: ColorInfo().diver, height: 1.5);

  final TextStyle chatBubbleTimeText =
      TextStyle(fontSize: 10.0.sp, color: ColorInfo().subtitleColor);

  final TextStyle chatStyleCardBottomText =
      TextStyle(fontSize: 10.0.sp, color: ColorInfo().subtitleColor);

  final TextStyle chatBubbleVoiceSenderText =
      TextStyle(fontSize: 15.0.sp, color: ColorInfo().mainTextColor);

  final TextStyle chatBubbleVoiceReceiverText =
      TextStyle(fontSize: 15.0.sp, color: ColorInfo().blueGrey);

  final TextStyle chatVideoTimerText =
      TextStyle(fontSize: 10.0.sp, color: ColorInfo().mainTextColor);

  final TextStyle chatVoiceTimerText = TextStyle(
      fontSize: 15.0.sp, color: ColorInfo().diver, fontWeight: FontWeight.w400);

  final TextStyle logOutBtnText =
      TextStyle(fontSize: 18.0.sp, color: ColorInfo().mainTextColor);

  final TextStyle homeTabBubbleText = TextStyle(
      fontSize: 11.0.sp,
      color: ColorInfo().mainTextColor,
      fontWeight: FontWeight.w400);

  final TextStyle homeTabFloatingText = TextStyle(
      fontSize: 12.0.sp,
      color: ColorInfo().normalGreyColor,
      fontWeight: FontWeight.w500);

  final TextStyle chatHomeSlideText = TextStyle(
      fontSize: 13.0.sp,
      color: ColorInfo().mainTextColor,
      fontWeight: FontWeight.w400);

  final TextStyle searchBtnText = TextStyle(
      fontSize: 16.0.sp,
      color: ColorInfo().mainColor,
      fontWeight: FontWeight.w400);

  final TextStyle searchContactsNameText = TextStyle(
      fontSize: 15.0.sp, fontWeight: FontWeight.w400, color: ColorInfo().diver);

  final TextStyle searchContactsNotesText = TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.w400,
      color: ColorInfo().subtitleColor);

  final TextStyle contactsApplicationAgreeText =
      TextStyle(fontSize: 14.0.sp, color: ColorInfo().mainColor);

  final TextStyle contactsApplicationDenyText =
      TextStyle(fontSize: 14.0.sp, color: ColorInfo().redColor);

  final TextStyle contactsApplyStatusText =
      TextStyle(fontSize: 14.0.sp, color: ColorInfo().subtitleColor);

  final TextStyle friendProfileMainText = TextStyle(
      fontSize: 18.0.sp, fontWeight: FontWeight.w500, color: ColorInfo().diver);

  final TextStyle friendProfileSubtitleText = TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.w400,
      color: ColorInfo().subtitleColor);

  final TextStyle friendProfileBtnText = TextStyle(
      fontSize: 15.0.sp,
      fontWeight: FontWeight.bold,
      color: ColorInfo().mainColor);

  final TextStyle deleteFriendBtnText = TextStyle(
      fontSize: 14.0.sp,
      fontWeight: FontWeight.bold,
      color: ColorInfo().mainTextColor);

  final TextStyle friendProfileBlockWarnText =
      TextStyle(color: ColorInfo().redColor);

  final TextStyle blockListDelBtnText = TextStyle(color: ColorInfo().redColor);

  final TextStyle friendApplyTitleText = TextStyle(
    fontSize: 14.0.sp,
    color: ColorInfo().diver,
    fontWeight: FontWeight.normal,
  );

  final TextStyle friendApplyBtnText = TextStyle(
      fontSize: 15.0.sp,
      fontWeight: FontWeight.bold,
      color: ColorInfo().mainTextColor);

  final TextStyle groupProfileMembersNameText = TextStyle(
    fontSize: 12.0.sp,
    color: ColorInfo().subtitleColor,
    fontWeight: FontWeight.normal,
  );

  final TextStyle groupProfileQuitBtnText = TextStyle(
      fontSize: 16.0.sp,
      fontWeight: FontWeight.normal,
      color: ColorInfo().redColor);

  final TextStyle qrCodeCardNickNameText = TextStyle(
    fontSize: 16.0.sp,
    color: ColorInfo().diver,
    fontWeight: FontWeight.normal,
  );

  final TextStyle qrCodeCardSubtitleText = TextStyle(
    fontSize: 12.0.sp,
    color: ColorInfo().subtitleColor,
    fontWeight: FontWeight.normal,
  );

  final TextStyle sheetMenuText = TextStyle(
      fontSize: 16.0.sp, color: ColorInfo().diver, fontWeight: FontWeight.w500);
}

class SizesInfo {
  final screenWidth = 1.sw; // 屏幕宽度
  final screenHeight = 1.sh; // 屏幕高度
}

/// 配色网站：https://mycolor.space/?hex=%2373AEF5&sub=1
class ColorInfo {
  final mainColor = const Color(0xFF73AEF5);
  final mainTextColor = Colors.white;
  final mainBackGroundColor = Colors.white;
  final redColor = Colors.red;
  final dividerColor = Colors.black12;
  final darkGreyColor = Colors.grey[800];
  final normalGreyColor = Colors.grey[600];
  final blueGrey = Colors.blueGrey;
  final lightGrep = Colors.grey[400];
  get btnTextColor => mainColor;
  final diver = Colors.black87;
  final subtitleColor = Colors.grey.shade500;
  get homeTabSelected => mainColor;
  get homeTabUnSelected => diver;
}
