import 'dart:async';
import 'dart:convert';
import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatUsersListItem extends StatefulWidget {
  final String? text;
  final String? secondaryText;
  final String? image;
  final String? time;
  final bool? isMessageRead;
  ChatUsersListItem(
      {@required this.text,
      @required this.secondaryText,
      @required this.image,
      @required this.time,
      @required this.isMessageRead});
  @override
  _ChatUsersListState createState() => _ChatUsersListState();
}

class _ChatUsersListState extends State<ChatUsersListItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChatDetailPage('Jacob Pena');
          }));
        },
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: '置顶',
              color: Flavors.colorInfo.mainColor,
              icon: Icons.upload_rounded,
              onTap: () {},
            ),
            IconSlideAction(
              caption: '删除',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {},
            ),
          ],
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage(widget.image!),
                        maxRadius: 30,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.text!),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                widget.secondaryText!,
                                style:
                                    Flavors.textStyles.groupMembersNumberText,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.time!,
                  style: TextStyle(
                      fontSize: 12,
                      color: widget.isMessageRead!
                          ? Colors.pink
                          : Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ));
  }
}
