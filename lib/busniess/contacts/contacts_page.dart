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
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/busniess/contacts/contactsApplication.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<ContactsPage>
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
          SearchBarView(),
          _addFriendsView(),
          Divider(
            height: 0.5,
            thickness: 0.5,
            indent: 10,
            endIndent: 10,
            color: Flavors.colorInfo.dividerColor,
          ),
          _newFriendsApply(),
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

  Widget _newFriendsApply() {
    return Selector<ContactsManager, List<FriendsApplicationInfo>>(
      builder: (BuildContext context, List<FriendsApplicationInfo> value,
          Widget? child) {
        print("DEBUG=> _FriendsView 重绘了。。。。。");
        return Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ListTile(
              // onTap: () =>
              //     Routers.navigateTo("/contacts_application", arg: value),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ContactsApplicationPage(value))),
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
              trailing: value.isNotEmpty
                  ? Container(
                      width: 30.0.w,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        maxRadius: 10,
                        child: Center(
                          child: Text('${value.length}',
                              style: Flavors.textStyles.homeTabBubbleText),
                        ),
                      ),
                    )
                  : Container(width: 30.0.w),
            ));
      },
      selector: (BuildContext context, ContactsManager contactsManager) {
        return contactsManager.contactsApplicationList;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }

  Widget _contactsListView() {
    return Selector<ContactsManager, List<Friends>>(
      builder: (BuildContext context, List<Friends> value, Widget? child) {
        print("DEBUG=> _FriendsView 重绘了。。。。。");
        return ContactsUsersList(value);
      },
      selector: (BuildContext context, ContactsManager contactsManager) {
        return contactsManager.friendsList;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }
}
