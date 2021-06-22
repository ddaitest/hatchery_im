import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/busniess/models/chat_users.dart';
import 'package:hatchery_im/common/widget/contacts/ContactsUsersListItem.dart';
import 'package:hatchery_im/common/widget/groups/groupListItem.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:hatchery_im/manager/contactsManager.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchNewContactsPage extends StatefulWidget {
  @override
  _SearchNewContactsPageState createState() => _SearchNewContactsPageState();
}

class _SearchNewContactsPageState extends State<SearchNewContactsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final manager = App.manager<ContactsManager>();
  void initState() {
    manager.init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          _topBarView(),
        ],
      ),
    );
  }

  Widget _topBarView() {
    return Row(
      children: [
        Container(
          width: Flavors.sizesInfo.screenWidth - 70.0.w,
          child: SearchBarView(
            searchHintText: "通过账号/手机号搜索朋友",
            isEnabled: true,
            padding: const EdgeInsets.only(
                left: 16.0, right: 0.0, top: 16.0, bottom: 16.0),
            isAutofocus: true,
          ),
        ),
        TextButton(
            onPressed: () {},
            child: Text('取消', style: Flavors.textStyles.searchBtnText)),
      ],
    );
  }

  _addFriendsView() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
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

  _newFriendsApply() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            maxRadius: 20,
            child: Center(
              child: Icon(
                Icons.contact_phone,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            '好友申请',
            style: Flavors.textStyles.friendsText,
          ),
          trailing: Container(
            width: 30.0.w,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              maxRadius: 10,
              child: Center(
                child: Text('5', style: Flavors.textStyles.homeTabBubbleText),
              ),
            ),
          ),
        ));
  }

  _contactsListView() {
    return Selector<ContactsManager, List<Friends>>(
      builder: (BuildContext context, List<Friends> value, Widget? child) {
        print("DEBUG=> _FriendsView 重绘了。。。。。");
        return ContactsUsersListItem(value);
      },
      selector: (BuildContext context, ContactsManager contactsManager) {
        return contactsManager.friendsList;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }
}
