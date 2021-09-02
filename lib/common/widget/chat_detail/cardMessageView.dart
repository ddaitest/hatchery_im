import 'dart:async';
import 'package:hatchery_im/business/chat_detail/chat_detail_page.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/api/engine/entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';

import '../../../routers.dart';

class CardMessageWidget extends StatelessWidget {
  final MessageBelongType messageBelongType;
  final Map<String, dynamic> content;
  CardMessageWidget(this.messageBelongType, this.content);

  @override
  Widget build(BuildContext context) {
    return _cardMessageView(messageBelongType);
  }

  Widget _cardMessageView(MessageBelongType belongType) {
    return GestureDetector(
      onTap: () =>
          Routers.navigateTo('/friend_profile', arg: content['user_id']),
      child: Container(
          width: 180.0.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: belongType == MessageBelongType.Receiver
                ? Colors.white
                : Flavors.colorInfo.mainColor,
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  width: 150.0.w,
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      netWorkAvatar(content['icon'], 15.0),
                      SizedBox(
                        width: 10.0.w,
                      ),
                      Container(
                          width: 100.0.w,
                          child: Text(
                            '${content['nick']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ],
                  )),
              dividerViewCommon(indent: 0.0, endIndent: 0.0),
              Container(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('个人名片',
                      style: Flavors.textStyles.chatStyleCardBottomText))
            ],
          )),
    );
  }
}
