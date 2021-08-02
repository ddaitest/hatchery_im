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

class ReceiveContactsApplyPage extends StatefulWidget {
  final List<FriendsApplicationInfo>? receiveContactsApplyList;
  ReceiveContactsApplyPage({this.receiveContactsApplyList});
  @override
  _ReceiveContactsApplyPageState createState() =>
      _ReceiveContactsApplyPageState();
}

class _ReceiveContactsApplyPageState extends State<ReceiveContactsApplyPage> {
  final manager = App.manager<ContactsApplyManager>();
  void initState() {
    manager.init();
    super.initState();
  }

  @override
  void dispose() {
    manager.slideAction.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBarFactory.backButton('收到的好友申请'),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            // shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: 16.0.w,
              ),
              _sendContactsApplyBtnView(),
              SizedBox(
                height: 16.0.w,
              ),
              _contactsListView(),
            ],
          ),
        ));
  }

  Widget _sendContactsApplyBtnView() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
          onTap: () => Routers.navigateTo('/send_contacts_apply'),
          leading: CircleAvatar(
            backgroundColor: Colors.pink,
            maxRadius: 20,
            child: Center(
              child: Icon(
                Icons.person_add_alt_1,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            '发出的好友邀请',
            style: Flavors.textStyles.friendsText,
          ),
          trailing: Container(width: 30.0.w),
        ));
  }

  Widget _contactsListView() {
    if (widget.receiveContactsApplyList!.isEmpty) {
      return Container(
        width: Flavors.sizesInfo.screenWidth,
        height: Flavors.sizesInfo.screenHeight / 2,
        child: Center(
          child: Text(
            "没有新的好友申请",
            style: Flavors.textStyles.noDataText,
          ),
        ),
      );
    } else {
      return ReceiveContactsUsersList(
          contactsApplicationList: widget.receiveContactsApplyList,
          agreeBtnTap: null,
          slideAction: manager.slideAction,
          denyResTap: null);
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.of(App.navState.currentContext!).pop(true);
    return true;
  }
}
