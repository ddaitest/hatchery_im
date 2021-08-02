import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/business/models/chat_users.dart';
import 'package:hatchery_im/common/widget/contacts/ContactsUsersListItem.dart';
import 'package:hatchery_im/common/widget/groups/groupListItem.dart';
import 'package:hatchery_im/common/widget/loading_Indicator.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:hatchery_im/manager/contactsApplicationManager.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/routers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendContactsApplyPage extends StatelessWidget {
  final manager = App.manager<ContactsApplyManager>();

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => ContactsApplyManager(),
        child: Scaffold(
          appBar: AppBarFactory.backButton('发送的好友申请'),
          body: _contactsListView(),
        ));
  }

  Widget _contactsListView() {
    if (manager.sendContactsApplyList.isEmpty) {
      return Container(
        width: Flavors.sizesInfo.screenWidth,
        height: Flavors.sizesInfo.screenHeight / 2,
        child: Center(
          child: Text(
            "没有发送的申请",
            style: Flavors.textStyles.noDataText,
          ),
        ),
      );
    } else {
      return NewContactsUsersList(
          contactsApplicationList: manager.sendContactsApplyList,
          agreeBtnTap: null,
          slideAction: manager.slideAction,
          denyResTap: null);
    }
  }
}
