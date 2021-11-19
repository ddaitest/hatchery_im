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

class _ChatPageState extends State<ChatPage> {
  final manager = App.manager<ChatHomeManager>();
  var sessionBox = LocalStore.listenSessions();

  @override
  void initState() {
    manager.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  valueListenable: sessionBox.listenable(),
                  builder: (context, Box<Session> box, _) {
                    Log.yellow("ValueListenableBuilder ${box.values.length}");
                    if (box.values.isEmpty) {
                      return IndicatorView(
                          tipsText: "没有聊天记录", showLoadingIcon: false);
                    } else {
                      return ListView.builder(
                        itemCount: box.values.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          Session? session = box.getAt(index);
                          // Log.yellow("chat page ${box.get(key)}");
                          if (session != null) {
                            return ChatUsersListItem(
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
                                    : session.lastGroupChatMessage));
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
