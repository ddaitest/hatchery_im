import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/widget/loading_Indicator.dart';
import 'package:hatchery_im/common/widget/contacts/ContactsUsersListItem.dart';
import 'package:hatchery_im/manager/contacts_manager/contactsApplicationManager.dart';
import 'package:hatchery_im/common/AppContext.dart';

class SendContactsApplyPage extends StatelessWidget {
  final manager = App.manager<ContactsApplyManager>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.backButton('发送的好友申请'),
      body: _contactsListView(),
    );
  }

  Widget _contactsListView() {
    if (manager.sendContactsApplyList.isEmpty) {
      return IndicatorView(tipsText: '没有发送的申请', showLoadingIcon: false);
    } else {
      return SendContactsUsersList(
          contactsApplicationList: manager.sendContactsApplyList);
    }
  }
}
