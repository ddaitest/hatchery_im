import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/business/models/chat_users.dart';
import 'package:hatchery_im/common/widget/chat_home/ChatUsersListItem.dart';
import 'package:hatchery_im/common/widget/loading_Indicator.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var sessionBox = LocalStore.listenSessions();

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
                    print("DEBUG=> box.values ${box.values}");
                    if (box.values.isEmpty) {
                      return Center(
                        child: IndicatorView(
                            tipsText: "没有聊天记录", showLoadingIcon: false),
                      );
                    }
                    return ListView.builder(
                      itemCount: box.values.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Session? session = box.getAt(index);
                        //TODO 渲染 Session
                        var content = "";
                        if (session != null) {
                          print("DEBUG=> session session $session");
                          if (0 == session.type) {
                            //会话类型，0表示单聊，1表示群聊
                            if (session.lastChatMessage != null) {
                              content = session.lastChatMessage!.content;
                            } else {
                              content = "";
                            }
                          } else {
                            if (session.lastGroupChatMessage != null) {
                              content = session.lastGroupChatMessage!.content;
                            } else {
                              content = "";
                            }
                          }
                          if (content != "") {
                            return ChatUsersListItem(
                              text: session.title,
                              secondaryText: content,
                              image: session.icon,
                              time: session.updateTime,
                              isMessageRead:
                                  (index == 0 || index == 3) ? true : false,
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Container();
                        }
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
