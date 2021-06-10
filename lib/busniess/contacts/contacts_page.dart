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

class ContactsPage extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<ContactsPage>
    with SingleTickerProviderStateMixin {
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
    return Scaffold(
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          SearchBarView(),
          _newFriendsView(),
          SizedBox(
            height: 16.0.w,
          ),
          _contactsListView(),
        ],
      ),
    );
  }

  _newFriendsView() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage('images/new_friends.png'),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 16.0.w,
                ),
                Container(
                  color: Colors.transparent,
                  child: Text(
                    '新的朋友',
                    style: Flavors.textStyles.friendsText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
