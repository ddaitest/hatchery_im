import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/busniess/models/chat_message.dart';
import 'package:hatchery_im/busniess/models/send_menu_items.dart';
import 'package:hatchery_im/common/widget/chat_detail/chat_detail_page_appbar.dart';
import 'package:hatchery_im/common/widget/chat_home/chat_bubble.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/manager/chatDetailManager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';

enum MessageBelongType {
  Sender,
  Receiver,
}

class ChatDetailPage extends StatefulWidget {
  final Friends friendInfo;
  ChatDetailPage(this.friendInfo);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  TextEditingController textEditingController = TextEditingController();
  final manager = App.manager<ChatDetailManager>();
  List<SendMenuItems> menuItems = [
    SendMenuItems(
        text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
    SendMenuItems(
        text: "Document", icons: Icons.insert_drive_file, color: Colors.blue),
    SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.orange),
    SendMenuItems(
        text: "Location", icons: Icons.location_on, color: Colors.green),
    SendMenuItems(text: "Contact", icons: Icons.person, color: Colors.purple),
  ];

  @override
  void initState() {
    manager.init();
    manager.queryFriendsHistoryMessages(widget.friendInfo.friendId, 0);
    super.initState();
  }

  @override
  void dispose() {
    manager.messagesList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatDetailPageAppBar.chatDetailAppBar(widget.friendInfo.nickName),
      backgroundColor: Colors.grey[100],
      floatingActionButton: _sendBtnView(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _messageInfoView(),
          _inputView(),
        ],
      ),
    );
  }

  Widget _messageInfoView() {
    return Selector<ChatDetailManager, List<FriendsHistoryMessages>>(
      builder: (BuildContext context, List<FriendsHistoryMessages> value,
          Widget? child) {
        return Flexible(
          child: ListView.builder(
            itemCount: value.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ChatBubble(
                avatarPicUrl: manager.myProfileData!.userID!
                            .compareTo(value[index].sender) ==
                        0
                    ? '${manager.myProfileData!.icon}'
                    : '${widget.friendInfo.icon}',
                messageBelongType: manager.myProfileData!.userID!
                            .compareTo(value[index].sender) ==
                        0
                    ? MessageBelongType.Sender
                    : MessageBelongType.Receiver,
                friendsHistoryMessages: value[index],
              );
            },
          ),
        );
      },
      selector: (BuildContext context, ChatDetailManager chatDetailManager) {
        return chatDetailManager.messagesList;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }

  Widget _inputView() {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 10.0, bottom: 10.0),
      constraints: BoxConstraints(maxHeight: 300.0.h, minHeight: 50.0.h),
      width: Flavors.sizesInfo.screenWidth,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          /// 点击先收起键盘
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              showModal();
            },
            child: Container(
              height: 30.0.h,
              width: 30.0.w,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
          SizedBox(width: 13.0.w),
          Container(
            width: Flavors.sizesInfo.screenWidth - 140.0.w,
            child: TextField(
              controller: textEditingController,
              maxLines: null,
              minLines: 1,
              maxLength: 125,
              keyboardType: TextInputType.multiline,
              cursorColor: Flavors.colorInfo.mainColor,
              decoration: InputDecoration(
                  hintText: "请输入文字...",
                  counterText: '',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sendBtnView() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.send,
          color: Colors.white,
        ),
        backgroundColor: Colors.pink,
        elevation: 0,
      ),
    );
  }

  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            // height: MediaQuery.of(context).size.height / 2,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    itemCount: menuItems.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: menuItems[index].color!.shade50,
                            ),
                            height: 50,
                            width: 50,
                            child: Icon(
                              menuItems[index].icons,
                              size: 20,
                              color: menuItems[index].color!.shade400,
                            ),
                          ),
                          title: Text(menuItems[index].text!),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
