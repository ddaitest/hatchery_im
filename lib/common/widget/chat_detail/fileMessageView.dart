import 'dart:async';
import 'package:hatchery_im/business/chat_detail/chat_detail_page.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/api/engine/entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';
import '../../../config.dart';
import '../../../routers.dart';

class FileMessageWidget extends StatelessWidget {
  final MessageBelongType messageBelongType;
  final Map<String, dynamic> content;
  FileMessageWidget(this.messageBelongType, this.content);

  @override
  Widget build(BuildContext context) {
    return _fileMessageView(messageBelongType);
  }

  Widget _fileMessageView(MessageBelongType belongType) {
    return GestureDetector(
      onTap: () => launchUrl(content['file_url'].toString()),
      child: Container(
          width: 180.0.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 150.0.w,
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  '${content['name']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              dividerViewCommon(indent: 0.0, endIndent: 0.0),
              Container(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('${setFileSize(content['content_length'])}',
                      style: Flavors.textStyles.chatStyleCardBottomText))
            ],
          )),
    );
  }

  String setFileSize(var fileSize) {
    return fileSize.toString();
    // if (fileSize != null) {
    //   if (fileSize >= 1000) {
    //     return "${(content['content_length'] / 1000).toStringAsFixed(2)} MB";
    //   } else {
    //     return "${content['content_length'].toStringAsFixed(0)} KB";
    //   }
    // } else {
    //   return '';
    // }
  }
}
