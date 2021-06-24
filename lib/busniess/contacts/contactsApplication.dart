import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/busniess/models/chat_users.dart';
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

class ContactsApplicationPage extends StatefulWidget {
  final List<FriendsApplicationInfo> newContactsApplicationList;
  ContactsApplicationPage(this.newContactsApplicationList);
  @override
  _ContactsApplicationPageState createState() =>
      _ContactsApplicationPageState();
}

class _ContactsApplicationPageState extends State<ContactsApplicationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final manager = App.manager<ContactsApplicationManager>();
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
    super.build(context);
    return Scaffold(
      appBar: AppBarFactory.backButton('好友申请'),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        // shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: 16.0.w,
          ),
          _addFriendsView(),
          SizedBox(
            height: 16.0.w,
          ),
          _contactsListView(),
        ],
      ),
    );
  }

  Widget _addFriendsView() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
          onTap: () => Routers.navigateTo('/search_new_contacts'),
          leading: CircleAvatar(
            backgroundColor: Colors.pink,
            maxRadius: 20,
            child: Center(
              child: Icon(
                Icons.person_add,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            '添加朋友',
            style: Flavors.textStyles.friendsText,
          ),
          trailing: Container(width: 30.0.w),
        ));
  }

  Widget _contactsListView() {
    if (widget.newContactsApplicationList.isEmpty) {
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
      return NewContactsUsersList(
          widget.newContactsApplicationList, null, manager.slideAction);
    }
  }
}
