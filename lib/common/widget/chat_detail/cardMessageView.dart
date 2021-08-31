import 'dart:async';
import 'package:hatchery_im/business/chat_detail/chat_detail_page.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/api/engine/entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';

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
      onTap: () => null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: belongType == MessageBelongType.Receiver
              ? Colors.white
              : Flavors.colorInfo.mainColor,
        ),
        padding: const EdgeInsets.all(10),
        child: Container(
          // height: 25.0.h,
          width: 100.0.w,
          child: ListTile(
            trailing: netWorkAvatar(content['icon'], 20.0),
            title: Text('${content['nick'] ?? '无'}'),
            subtitle: Text('${content['user_id'] ?? ''}'),
          ),
        ),
      ),
    );
  }
}
