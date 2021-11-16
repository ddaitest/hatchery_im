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
import '../../utils.dart';
import '../aboutAvatar.dart';

class ChatUsersListItem extends StatelessWidget {
  final String title;
  final String icon;
  final int chatType;
  final String chatId;
  final int updateTime;
  final String content;
  ChatUsersListItem(
      {required this.title,
      required this.icon,
      required this.chatType,
      required this.chatId,
      required this.updateTime,
      required this.content});
  final manager = App.manager<ChatHomeManager>();

  @override
  Widget build(BuildContext context) {
    List<SlideActionInfo> slideAction = [
      SlideActionInfo('置顶', Icons.upload_sharp, Flavors.colorInfo.mainColor),
      SlideActionInfo(
          '不提醒', Icons.notifications_off, Flavors.colorInfo.blueGrey),
      SlideActionInfo('删除', Icons.delete, Colors.red,
          onTap: () => LocalStore.deleteSession(chatId)),
    ];
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: slideAction.map((e) => slideActionModel(e)).toList(),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: ListTile(
          onTap: () => Routers.navigateTo("/chat_detail",
              arg: chatType == 0
                  ? {"chatType": "CHAT", "nickName": title, "friendId": chatId}
                  : {
                      "chatType": "GROUP",
                      "groupId": chatId,
                      "groupName": title,
                      "groupIcon": icon
                    }),
          dense: false,
          visualDensity: VisualDensity.comfortable,
          leading: netWorkAvatar(icon, 25.0,
              avatarType: chatType != 0 ? "groupAvatar" : "avatar"),
          title: Text(title),
          subtitle: Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              content,
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
    return IconSlideAction(
      iconWidget: Container(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text('${slideActionInfo.label}',
              style: Flavors.textStyles.chatHomeSlideText)),
      color: slideActionInfo.iconColor,
      icon: slideActionInfo.icon,
      foregroundColor: Colors.white,
      onTap: () => slideActionInfo.onTap,
    );
  }
}
