import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/busniess/models/chat_message.dart';
import 'package:vibration/vibration.dart';
import 'package:hatchery_im/busniess/models/send_menu_items.dart';
import 'package:hatchery_im/common/widget/chat_detail/chat_detail_page_appbar.dart';
import 'package:hatchery_im/common/widget/chat_home/chat_bubble.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/manager/chatDetailManager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:hatchery_im/common/utils.dart';

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
    SendMenuItems(text: "照片", icons: Icons.image, color: Colors.amber),
    SendMenuItems(text: "视频", icons: Icons.camera_alt, color: Colors.orange),
    SendMenuItems(
        text: "文件", icons: Icons.insert_drive_file, color: Colors.blue),
    SendMenuItems(text: "位置", icons: Icons.location_on, color: Colors.green),
    SendMenuItems(text: "名片", icons: Icons.person, color: Colors.purple),
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
    manager.isVoiceModel = false;
    manager.cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatDetailPageAppBar.chatDetailAppBar(widget.friendInfo.nickName),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: <Widget>[
          _messageInfoView(),
          _inputMainView(),
        ],
      ),
    );
  }

  Widget _messageInfoView() {
    return Selector<ChatDetailManager, List<FriendsHistoryMessages>>(
      builder: (BuildContext context, List<FriendsHistoryMessages> value,
          Widget? child) {
        print("DEBUG=> _messageInfoView _messageInfoView");
        return Flexible(
          child: ListView.builder(
            itemCount: value.length,
            reverse: true,
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
                  : _textInputView(),
              Container(
                constraints: BoxConstraints(maxHeight: 300.0.h),
                height: 50.0.h,
                child: VerticalDivider(
                  color: Colors.grey[400],
                  indent: 0.5,
                  endIndent: 0.5,
                  width: 0.5,
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

  Widget _moreBtnView() {
    return GestureDetector(
        onTap: () {
          /// 点击先收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
          showModal();
        },
        child: Container(
          // padding: const EdgeInsets.only(bottom: 20),
          child: Image.asset('images/moreBtn.png', height: 30.0, width: 30.0),
        ));
  }

  Widget _textInputView() {
    return Container(
      width: Flavors.sizesInfo.screenWidth - 140.0.w,
      child: TextField(
        controller: textEditingController,
        maxLines: null,
        minLines: 1,
        maxLength: 140,
        keyboardType: TextInputType.name,
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
                manager.isRecording
                    ? Container(
                        height: 20.0,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballScaleMultiple,
                          color: Colors.red,
                        ),
                      )
                    : Icon(Icons.lens, color: Colors.red, size: 20.0),
                SizedBox(
                  width: 20.0.w,
                ),
                Text("${durationTransform(value)}"),
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
        manager.startVoiceRecord(widget.friendInfo.friendId);
      },
      onLongPressEnd: (LongPressEndDetails details) {
        print("DEBUG=> ${details.localPosition.dx}");
        Vibration.vibrate(duration: 100);
        manager.changeInputView();
        manager.cancelTimer();
        manager.stopVoiceRecord();
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

  void showVoiceCord() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: Flavors.sizesInfo.screenHeight / 4,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                )),
                Positioned(
                    top: -20.0,
                    child: RawMaterialButton(
                      onPressed: () {},
                      elevation: 0.5,
                      fillColor: Colors.pink,
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 30,
                      ),
                    )),
                Positioned(
                    top: -20.0,
                    child: RawMaterialButton(
                      onPressed: () {},
                      elevation: 0.5,
                      fillColor: Colors.pink,
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.cancel_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }

  _voiceRecordView1() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150.0.w,
              height: 60.0.h,
              padding: const EdgeInsets.only(
                  right: 30.0, left: 30.0, top: 20.0, bottom: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Flavors.colorInfo.mainColor,
              ),
              child: LoadingIndicator(
                  indicatorType: Indicator.lineScale,
                  color: Flavors.colorInfo.mainBackGroundColor),
            ),
            SizedBox(height: 100.0),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.cancel_outlined,
                  size: 50.0, color: Colors.grey[400]),
            ),
          ],
        ));
      },
    );
  }
}
