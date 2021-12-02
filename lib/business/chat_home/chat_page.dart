import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/business/models/chat_users.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/widget/chat_home/ChatUsersListItem.dart';
import 'package:hatchery_im/common/widget/loading_Indicator.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:hatchery_im/manager/chat_manager/chatHomeManager.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  // final manager = App.manager<ChatHomeManager>();
  ValueListenable<Box<Session>> sessionBox = LocalStore.listenSessions();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SearchBarView(),
            Container(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ValueListenableBuilder(
                  valueListenable: sessionBox,
                  builder: (context, Box<Session> box, _) {
                    Log.yellow("ValueListenableBuilder ${box.values.length}");
                    if (box.values.isEmpty) {
                      return IndicatorView(
                          tipsText: "没有聊天记录", showLoadingIcon: false);
                    } else {
                      return ListView.builder(
                        itemCount: box.values.length,
                        shrinkWrap: true,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          Session? session = box.getAt(index);
                          if (session != null) {
                            return ChatUsersListItem(
                              chatTopType: session.top,
                              title: session.title,
                              senderName: session.type == 1
                                  ? session.lastGroupChatMessage!.nick
                                  : "",
                              icon: session.icon,
                              //会话类型，0表示单聊，1表示群聊
                              chatType: session.type,
                              chatId: session.otherID,
                              updateTime: session.updateTime,
                              content: chatHomeSubtitleSet(session.type == 0
                                  ? session.lastChatMessage
                                  : session.lastGroupChatMessage),
                              sessionKey: box.keyAt(index),
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
