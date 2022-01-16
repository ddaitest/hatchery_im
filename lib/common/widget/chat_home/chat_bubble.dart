import 'dart:convert' as convert;
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/widget/chat_detail/voiceMessageView.dart';
import 'package:hatchery_im/common/widget/chat_detail/imageMessageView.dart';
import 'package:hatchery_im/common/widget/chat_detail/videoMessageInfo/videoMessageView.dart';
import 'package:hatchery_im/common/widget/chat_detail/cardMessageView.dart';
import 'package:hatchery_im/common/widget/chat_detail/fileMessageView.dart';
import 'package:hatchery_im/common/widget/chat_detail/locationMessageView.dart';
import 'package:hatchery_im/manager/MsgHelper.dart';
import 'package:hatchery_im/manager/chat_manager/chatDetailManager.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';
import '../../../manager/messageCentre.dart';
import '../../log.dart';
import '../aboutAvatar.dart';

class ChatBubble extends StatefulWidget {
  final String userID;
  final MessageBelongType messageBelongType;
  final Message contentMessages;
  final int messageKey;

  ChatBubble(
      {required this.userID,
      required this.messageBelongType,
      required this.contentMessages,
      required this.messageKey});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final manager = App.manager<ChatDetailManager>();
  CustomPopupMenuController? _customPopupMenuController;

  @override
  void initState() {
    _customPopupMenuController = CustomPopupMenuController();
    super.initState();
  }

  @override
  void dispose() {
    _customPopupMenuController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: _chatBubbleView('${_getAvatarPicUrl()}'));
  }

  String _getAvatarPicUrl() {
    if (widget.contentMessages.sender == manager.myProfileData!.userID) {
      return manager.myProfileData!.icon!;
    } else {
      return widget.contentMessages.icon;
    }
  }

  Widget _chatBubbleView(String? avatarUrl) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
              "${checkMessageTime(widget.contentMessages.createTime).toString().contains("-") ? checkMessageTime(widget.contentMessages.createTime).toString().split(" ")[0] : checkMessageTime(widget.contentMessages.createTime)}",
              maxLines: 1,
              softWrap: true,
              style: Flavors.textStyles.chatBubbleTimeText),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: widget.messageBelongType == MessageBelongType.Receiver
              ? TextDirection.ltr
              : TextDirection.rtl,
          children: [
            GestureDetector(
              onTap: () =>
                  widget.messageBelongType == MessageBelongType.Receiver
                      ? Routers.navigateTo('/friend_profile',
                          arg: widget.contentMessages.sender)
                      : null,
              child: netWorkAvatar(avatarUrl, 20.0),
            ),
            SizedBox(width: 15.0.w),
            widget.contentMessages.type == "GROUP" &&
                    widget.messageBelongType == MessageBelongType.Receiver
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.contentMessages.nick,
                        style: TextStyle(fontSize: 11.0),
                      ),
                      Container(height: 2.0),
                      switchMessageTypeView(widget.contentMessages.contentType,
                          widget.messageBelongType),
                    ],
                  )
                : switchMessageTypeView(widget.contentMessages.contentType,
                    widget.messageBelongType),
            Container(width: 10.0.w),
            _sentMessageStatusIcon(),
          ],
        ),
      ],
    );
  }

  Widget switchMessageTypeView(
      String messageType, MessageBelongType belongType) {
    Widget finalView;
    Map<String, dynamic> content =
        convert.jsonDecode(widget.contentMessages.content);
    switch (messageType) {
      case "TEXT":
        {
          finalView = _textMessageView(content, belongType);
        }
        break;
      case "IMAGE":
        {
          finalView = ImageMessageWidget(content, belongType);
        }
        break;
      case "VIDEO":
        {
          finalView = VideoMessageWidget(content, belongType);
        }
        break;
      case "VOICE":
        {
          finalView = VoiceMessageWidget(content, belongType);
        }
        break;
      case "FILE":
        {
          finalView = FileMessageWidget(belongType, content);
        }
        break;
      case "URL":
        {
          finalView = _textMessageView(content, belongType);
        }
        break;
      case "CARD":
        {
          finalView = CardMessageWidget(belongType, content);
        }
        break;
      case "GEO":
        {
          finalView =
              LocationMessageWidget(belongType, content, MapOriginType.Share);
        }
        break;
      default:
        {
          finalView = _textMessageView(content, belongType);
        }
        break;
    }
    return CustomPopupMenu(
      child: finalView,
      controller: _customPopupMenuController,
      menuBuilder: _buildLongPressMenu,
      barrierColor: Colors.transparent,
      pressType: PressType.longPress,
    );
  }

  Widget _buildLongPressMenu() {
    List<ItemModel> messageLongPressMenuItems = [
      ItemModel('复制', Icons.copy),
      ItemModel('转发', Icons.reply),
      ItemModel('删除', Icons.delete),
    ];
    if (widget.contentMessages.contentType != "TEXT") {
      messageLongPressMenuItems.removeAt(0);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.all(8),
        width: (messageLongPressMenuItems.length * 50.0).w,
        color: const Color(0xFF4C4C4C),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: messageLongPressMenuItems
              .map((item) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (widget.contentMessages.progress == MSG_SENDING) {
                        showToast("发送成功后才可操作");
                      } else {
                        if (item.title == "复制") {
                          ChatDetailManager.copyText(convert.jsonDecode(
                              widget.contentMessages.content)['text']);
                        } else if (item.title == "转发") {
                          ChatDetailManager.relayMessage(
                              convert
                                  .jsonDecode(widget.contentMessages.content),
                              widget.contentMessages.contentType);
                        } else if (item.title == "删除") {
                          MessageCentre.deleteMessage(widget.messageKey);
                        }
                        _customPopupMenuController?.hideMenu();
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(
                          item.icon,
                          size: 20,
                          color: Colors.white,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          child: Text(
                            item.title,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  String _checkContentType(Message temp) {
    String finalMessage;
    Map<String, dynamic> content = convert.jsonDecode(temp.content);
    switch (temp.contentType) {
      case "TEXT":
        {
          finalMessage = content['text'];
        }
        break;
      case "IMAGE":
        {
          finalMessage = content['img_url'];
        }
        break;
      case "VIDEO":
        {
          finalMessage = content['video_url'];
        }
        break;
      case "VOICE":
        {
          finalMessage = content['voice_url'];
        }
        break;
      // case "FILE":
      //   {
      //     finalMessage = content['file_url'];
      //   }
      //   break;
      case "URL":
        {
          finalMessage = content['text'];
        }
        break;
      // case "CARD":
      //   {
      //     finalMessage = content;
      //   }
      //   break;
      // case "GEO":
      //   {
      //     finalMessage = content;
      //   }
      //   break;
      default:
        {
          finalMessage = content['text'];
        }
        break;
    }
    return finalMessage;
  }

  // 发送状态Widget
  // 0发送失败；1发送中; 2发送完成; 3消息已读; 4收到但未读
  Widget _statusIcon({int progress = 0}) {
    Widget finalView;
    switch (progress) {
      case 0:
        {
          finalView = IconButton(
              onPressed: () {
                showToast("请重新发送");
                // if (contentMessages.contentType != "FILE" &&
                //     contentMessages.contentType != "GEO") {
                //   contentMessages
                //     ..progress = MSG_SENDING
                //     ..createTime = DateTime.now().millisecondsSinceEpoch
                //     ..save();
                //   Message temp = contentMessages;
                //   manager.sendMessage(
                //       _checkContentType(temp), contentMessages.contentType);
                // } else {
                //   showToast("请重新发送");
                // }
              },
              icon: Icon(Icons.error, size: 25.0, color: Colors.red));
        }
        break;
      case 1:
        {
          finalView = CupertinoActivityIndicator(radius: 7.0);
        }
        break;
      case 2:
        {
          finalView = Container();
        }
        break;
      default:
        {
          finalView = Container();
        }
        break;
    }
    return finalView;
  }

  // 0发送失败；1发送中; 2发送完成; 3消息已读; 4收到但未读
  Widget _sentMessageStatusIcon() {
    if (widget.contentMessages.sender == UserCentre.getUserID()) {
      return _statusIcon(progress: widget.contentMessages.progress ?? 2);
    } else {
      return Container();
    }
  }

  Widget _textMessageView(
      Map<String, dynamic> contentMap, MessageBelongType belongType) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: Flavors.sizesInfo.screenWidth - 100.0.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: belongType == MessageBelongType.Receiver
            ? Colors.white
            : Flavors.colorInfo.mainColor,
      ),
      padding: const EdgeInsets.all(10),
      child: Text('${contentMap["text"]}',
          maxLines: 10,
          softWrap: true,
          style: widget.messageBelongType == MessageBelongType.Receiver
              ? Flavors.textStyles.chatBubbleReceiverText
              : Flavors.textStyles.chatBubbleSenderText),
    );
  }
}
