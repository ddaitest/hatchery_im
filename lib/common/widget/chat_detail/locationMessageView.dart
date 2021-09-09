import 'dart:async';
import 'package:hatchery_im/business/chat_detail/chat_detail_page.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/api/engine/entity.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/utils.dart';

import '../../../config.dart';
import '../../../routers.dart';

class LocationMessageWidget extends StatelessWidget {
  final MessageBelongType messageBelongType;
  final Map<String, dynamic> content;
  final MapOriginType mapOriginType;
  LocationMessageWidget(
      this.messageBelongType, this.content, this.mapOriginType);
  @override
  Widget build(BuildContext context) {
    return _locationMessageView(messageBelongType);
  }

  Widget _locationMessageView(MessageBelongType belongType) {
    LatLng position = LatLng(
        double.parse(content['latitude']), double.parse(content['longitude']));
    return GestureDetector(
      onTap: () => Routers.navigateTo('/map_view',
          arg: {'mapOriginType': mapOriginType, 'position': position}),
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
                height: 80.0.h,
                width: 150.0.w,
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Image.asset('images/location_thumb.png',
                    fit: BoxFit.fitWidth),
              ),
              dividerViewCommon(indent: 0.0, endIndent: 0.0),
              Container(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('${content['name']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Flavors.textStyles.chatStyleCardBottomText))
            ],
          )),
    );
  }
}
