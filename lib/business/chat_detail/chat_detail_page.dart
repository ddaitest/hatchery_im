import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/manager/emojiModel_manager.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import 'package:hive/hive.dart';
import 'package:vibration/vibration.dart';
import 'package:hatchery_im/business/models/send_menu_items.dart';
import 'package:hatchery_im/common/widget/chat_detail/chat_detail_page_appbar.dart';
import 'package:hatchery_im/common/widget/chat_home/chat_bubble.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/manager/chat_manager/chatDetailManager.dart';
import 'package:hatchery_im/manager/map_manager/showMapManager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/common/widget/emojiModel.dart';
import '../../routers.dart';

class ChatDetailPage extends StatefulWidget {
  final UsersInfo? usersInfo;

  ChatDetailPage({this.usersInfo});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final manager = App.manager<ChatDetailManager>();
  final emojiModelManager = App.manager<EmojiModelManager>();
  List<SendMenuItems> menuItems = [];

  @override
  void initState() {
    menuItems = [
      SendMenuItems(
          text: "相册",
          icons: Icons.image,
          color: Colors.amber,
          onTap: () => manager.getImageByGallery()),
      SendMenuItems(
          text: "拍摄",
          icons: Icons.camera_alt,
          color: Colors.orange,
          onTap: () => App.manager<ChatDetailManager>()
              .pickCamera(App.navState.currentContext!)),
      SendMenuItems(
          text: "文件", icons: Icons.insert_drive_file, color: Colors.blue),
      SendMenuItems(
          text: "位置",
          icons: Icons.location_on,
          color: Colors.green,
          onTap: () => Routers.navigateTo('/map_view',
              arg: {'mapOriginType': MapOriginType.Send, 'position': null})),
      // SendMenuItems(text: "名片", icons: Icons.person, color: Colors.purple),
    ];
    manager.init(widget.usersInfo!.userID);
    // manager.queryFriendsHistoryMessages(widget.usersInfo.friendId, 0);
    super.initState();
  }

  @override
  void dispose() {
    manager.messagesList.clear();
    manager.isVoiceModel = false;
    manager.cancelTimer();
    manager.emojiShowing = false;
    manager.textEditingController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatDetailPageAppBar.chatDetailAppBar(widget.usersInfo!.nickName),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: <Widget>[
          _messageInfoView(),
          _inputMainView(),
          _emojiInputView()
        ],
      ),
    );
  }

  Widget _messageInfoView2() {
    return ValueListenableBuilder(
        valueListenable: LocalStore.listenMessage(),
        builder: (context, Box<Message> box, _) {
          String content = "<${box.values.length}>";
          box.values.forEach((element) {
            content += "(${element.content})";
          });
          return Text(content);
        });
  }

  Widget _messageInfoView() {
    return Selector<ChatDetailManager, List<Message>>(
      builder: (BuildContext context, List<Message> value, Widget? child) {
        print("DEBUG=> _messageInfoView _messageInfoView");
        return Flexible(
          child: ListView.builder(
            itemCount: value.length,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ChatBubble(
                userID: widget.usersInfo!.userID,
                avatarPicUrl: manager.myProfileData!.userID!
                            .compareTo(value[index].sender) ==
                        0
                    ? '${manager.myProfileData!.icon}'
                    : '${widget.usersInfo!.icon}',
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

  Widget _inputMainView() {
    return Selector<ChatDetailManager, bool>(
      builder: (BuildContext context, bool value, Widget? child) {
        return Container(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
          constraints: BoxConstraints(minHeight: 50.0.h, maxHeight: 300.0.h),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              value ? _voiceRecordView() : _moreBtnView(),
              value
                  ? Container(
                      height: 50.0.h,
                    )
                  : _emojiBtnView(),
              value
                  ? Container(
                      height: 50.0.h,
                    )
                  : _textInputView(),
              Container(
                constraints: BoxConstraints(maxHeight: 300.0.h),
                height: 50.0.h,
                child: VerticalDivider(
                  color: Colors.grey[400],
                  indent: 0.5,
                  endIndent: 0.5,
                  width: 0.5.w,
                  thickness: 0.5,
                ),
              ),
              _voiceRecordBtnView(value),
            ],
          ),
        );
      },
      selector: (BuildContext context, ChatDetailManager chatDetailManager) {
        return chatDetailManager.isVoiceModel;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }

  Widget _emojiInputView() {
    return Selector<ChatDetailManager, bool>(
      builder: (BuildContext context, bool value, Widget? child) {
        return value
            ? Stack(
                alignment: Alignment.bottomRight,
                children: [
                  EmojiModelView(),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: TextButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 0.5,
                        primary: Flavors.colorInfo.mainColor,
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      child: Text(
                        '发送',
                        style: Flavors.textStyles.chatHomeSlideText,
                      ),
                    ),
                  ),
                ],
              )
            : Container();
      },
      selector: (BuildContext context, ChatDetailManager chatDetailManager) {
        return chatDetailManager.emojiShowing;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }

  Widget _moreBtnView() {
    return GestureDetector(
        onTap: () {
          /// 点击先收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
          showModal();
        },
        child: Image.asset('images/moreBtn.png'));
  }

  Widget _emojiBtnView() {
    return GestureDetector(
        onTap: () {
          /// 点击先收起键盘
          FocusScope.of(context).requestFocus(FocusNode());

          /// 设置表情选择框是否显示
          manager.setEmojiShowStatus();
        },
        child: Image.asset('images/emojiBtn.png'));
  }

  Widget _textInputView() {
    return Container(
      width: Flavors.sizesInfo.screenWidth - 140.0.w,
      child: TextFormField(
        controller: manager.textEditingController,
        onTap: () => manager.setEmojiShowStatus(showStatus: false),
        maxLines: null,
        minLines: 1,
        maxLength: 140,
        textInputAction: TextInputAction.send,
        keyboardType: TextInputType.text,
        cursorColor: Flavors.colorInfo.mainColor,
        decoration: InputDecoration(
            hintText: "请输入文字...",
            counterText: '',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: InputBorder.none),
      ),
    );
  }

  Widget _voiceRecordView() {
    return Selector<ChatDetailManager, int>(
      builder: (BuildContext context, int value, Widget? child) {
        return Container(
            width: Flavors.sizesInfo.screenWidth - 140.0.w,
            height: 50.0.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 20.0,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballScaleMultiple,
                    backgroundColor: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 20.0.w,
                ),
                Text("${durationTransform(value)}",
                    style: Flavors.textStyles.chatVoiceTimerText),
              ],
            ));
      },
      selector: (BuildContext context, ChatDetailManager chatDetailManager) {
        return chatDetailManager.recordTiming;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }

  Widget _voiceRecordBtnView(bool isVoice) {
    return GestureDetector(
      onLongPress: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Vibration.vibrate(duration: 100);
        manager.changeInputView();
        manager.timingStartMethod();
        manager.startVoiceRecord(widget.usersInfo!.userID);
      },
      onLongPressEnd: (LongPressEndDetails details) {
        Vibration.vibrate(duration: 100);
        manager.changeInputView();
        manager.stopVoiceRecord();
        manager.checkTimeLength();
      },
      child: Container(
        // padding: const EdgeInsets.only(bottom: 20),
        child: Image.asset(
            isVoice ? 'images/keyboard.png' : 'images/recordAudioBtn.png',
            height: 30.0,
            width: 30.0),
      ),
    );
  }

  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
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
                    height: 16.0.h,
                  ),
                  Center(
                    child: Container(
                      height: 4.0.h,
                      width: 50.0.w,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  ListView.builder(
                    itemCount: menuItems.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: ListTile(
                          onTap: menuItems[index].onTap,
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: menuItems[index].color!.shade50,
                            ),
                            height: 50.0.h,
                            width: 50.0.w,
                            child: Icon(
                              menuItems[index].icons,
                              size: 20.0,
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
