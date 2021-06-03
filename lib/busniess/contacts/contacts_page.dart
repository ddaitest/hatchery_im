import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/busniess/models/chat_users.dart';
import 'package:hatchery_im/common/widget/contacts/ContactsUsersListItem.dart';
import 'package:hatchery_im/common/widget/contacts/groupListItem.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:hatchery_im/manager/contactsManager.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<ContactsPage>
    with SingleTickerProviderStateMixin {
  ContactsManager _contactsManager = ContactsManager();
  void initState() {
    _contactsManager.init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.getMain(
          "联系人(${_contactsManager.friendsList.length})",
          actions: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.person_add,
                color: Colors.black,
                size: 30,
              ),
            ),
          ]),
      backgroundColor: Colors.white,
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          SearchBarView(),
          _contactsListView(),
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
      shouldRebuild: (pre, next) =>
          ((pre != next) || (pre.length != next.length)),
    );
  }
}
