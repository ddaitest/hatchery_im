import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/manager/chat_manager/chatHomeManager.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import 'dart:convert' as convert;
import '../../../routers.dart';
import '../../log.dart';
import '../../utils.dart';
import '../aboutAvatar.dart';

class ChatUsersListItem extends StatelessWidget {
  final int? chatTopType;
  final int? chatMute;
  final String title;
  final String senderName;
  final String icon;
  final int chatType;
  final String chatId;
  final int updateTime;
  final String content;
  final int sessionKey;
  final int unReadNum;
  ChatUsersListItem(
      {required this.chatTopType,
      required this.chatMute,
      required this.title,
      required this.senderName,
      required this.icon,
      required this.chatType,
      required this.chatId,
      required this.updateTime,
      required this.content,
      required this.sessionKey,
      required this.unReadNum});
  final manager = App.manager<ChatHomeManager>();

  @override
  Widget build(BuildContext context) {
    List<SlideActionInfo> slideAction = [
      SlideActionInfo(
          chatTopType == 1 ? '取消置顶' : '置顶',
          chatTopType == 1 ? Icons.download_rounded : Icons.upload_sharp,
          Flavors.colorInfo.mainColor,
          onPressed: (_) => LocalStore.setChatTop(
              otherId: chatId, chatTopType: chatTopType == 1 ? 0 : 1)),
      SlideActionInfo(
          chatMute == 0 ? '关闭提醒' : '打开提醒',
          chatTopType == 0 ? Icons.notifications_off : Icons.notifications_on,
          Flavors.colorInfo.blueGrey,
          onPressed: (_) => LocalStore.setChatMute(
              otherId: chatId, chatMuteType: chatMute == 1 ? 0 : 1)),
      SlideActionInfo('删除', Icons.delete, Colors.pinkAccent,
          onPressed: (_) => LocalStore.deleteSession(sessionKey)),
    ];
    return Slidable(
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const DrawerMotion(),
        // All actions are defined in the children parameter.
        children: slideAction.map((e) => slideActionModel(e)).toList(),
        extentRatio: 0.8,
      ),
      child: Container(
        color: chatTopType == 1 ? Colors.grey[200] : Colors.white,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: ListTile(
          onTap: () => Routers.navigateTo("/chat_detail",
              arg: chatType == 0
                  ? {
                      "chatType": "CHAT",
                      "otherName": title,
                      "otherIcon": icon,
                      "friendId": chatId
                    }
                  : {
                      "chatType": "GROUP",
                      "groupId": chatId,
                      "groupName": title,
                      "groupIcon": icon
                    }),
          dense: false,
          visualDensity: VisualDensity.comfortable,
          leading: Badge(
              position: BadgePosition.topEnd(top: -5, end: -5),
              toAnimate: false,
              showBadge: unReadNum == 0 ? false : true,
              elevation: 0.5,
              badgeContent: Text('$unReadNum',
                  style: Flavors.textStyles.homeTabBubbleText),
              animationType: BadgeAnimationType.scale,
              child: netWorkAvatar(icon, 25.0,
                  avatarType: chatType != 0 ? "groupAvatar" : "avatar")),
          title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              chatType == 0 ? content : "$senderName: $content",
              style: Flavors.textStyles.groupMembersNumberText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: Text(
            "${checkMessageTime(updateTime).toString().contains("-") ? checkMessageTime(updateTime).toString().split(" ")[0] : checkMessageTime(updateTime)}",
            style: TextStyle(fontSize: 12.0, color: Colors.grey.shade500),
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  Widget slideActionModel(SlideActionInfo slideActionInfo) {
    return SlidableAction(
      label: slideActionInfo.label,
      backgroundColor: slideActionInfo.backgroundColor,
      icon: slideActionInfo.icon,
      foregroundColor: Colors.white,
      onPressed: slideActionInfo.onPressed,
    );
  }
}
