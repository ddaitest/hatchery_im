import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/widget/chat_home/ChatUsersListItem.dart';
import 'package:hatchery_im/common/widget/loading_Indicator.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:hatchery_im/manager/chat_manager/chatHomeManager.dart';
import 'package:hatchery_im/store/LocalStore.dart';
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
    print("DEBUG=> sessionBox.length ${sessionBox.length}");
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SearchBarView(),
            Container(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: manager.sessions.length != 0
                  ? ListView.builder(
                      itemCount: manager.sessions.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Session? session = manager.sessions[index];
                        //TODO 渲染 Session
                        return ChatUsersListItem(
                          chatSession: session,
                          // text: session.title,
                          // secondaryText: finalContent,
                          // image: session.icon,
                          // time: session.updateTime,
                          // isMessageRead: (index == 0 || index == 2) ? true : false,
                          // chatId: session.otherID,
                        );
                      },
                    )
                  : IndicatorView(tipsText: "没有聊天记录", showLoadingIcon: false),
            ),
          ],
        ),
      ),
    );
  }
}
