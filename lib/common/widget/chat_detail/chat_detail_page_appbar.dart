import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/manager/chat_manager/chatHomeManager.dart';
import 'package:provider/provider.dart';

import '../../../routers.dart';

class ChatDetailPageAppBar {
  static AppBar chatDetailAppBar(String? name,
      {String? otherId,
      String? chatType,
      String? groupName,
      String? groupIcon}) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text(
        name!,
        style: Flavors.textStyles.chatDetailAppBarNameText,
        softWrap: true,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: Container(
          padding: const EdgeInsets.only(left: 9.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20.0, color: Colors.black),
            onPressed: () => Navigator.of(App.navState.currentContext!).pop(),
          )),
      actions: [
        Container(
          padding: const EdgeInsets.only(right: 9.0),
          child: IconButton(
              icon: Icon(Icons.more_vert, size: 25.0, color: Colors.black),
              onPressed: () => Routers.navigateTo("/chat_setting", arg: {
                    "otherId": otherId,
                    "chatType": chatType,
                  })),
        )
      ],
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }
}
