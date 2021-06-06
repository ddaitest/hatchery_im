import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/busniess/models/chat_users.dart';
import 'package:hatchery_im/common/widget/contacts/ContactsUsersListItem.dart';
import 'package:hatchery_im/common/widget/groups/groupListItem.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/groupsManager.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage>
    with SingleTickerProviderStateMixin {
  final Map<String, String> nameInfo = {
    "Jane Russel": "1",
    "Glady's Murphy": "2",
    "Jorge Henry": "3",
    "Jorge Henry": "4",
    "Philip Fox": "5",
    "Jacob Pena": "6",
    "Philip Fox": "7",
    "Debra Hawkins": "8",
    "Jane Russel": "1",
    "Glady's Murphy": "2",
    "Jorge Henry": "3",
    "Jorge Henry": "4",
    "Philip Fox": "5",
    "Jacob Pena": "6",
    "Philip Fox": "7",
    "Debra Hawkins": "8"
  };
  final List<ContactsUsers> contactsUsers = [];
  final manager = App.manager<GroupsManager>();

  void initState() {
    manager.init();
    super.initState();
  }

  @override
  void dispose() {
    nameInfo.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    nameInfo.forEach((key, value) {
      contactsUsers.add(ContactsUsers(
        text: key,
        image: "images/userImage$value.jpeg",
      ));
    });
    return Scaffold(
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          SearchBarView(),
          _groupListView(),
        ],
      ),
    );
  }

  Widget _groupListView() {
    return Selector<GroupsManager, List<Groups>>(
      builder: (BuildContext context, List<Groups> value, Widget? child) {
        print("DEBUG=> _FriendsView 重绘了。。。。。");
        return Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
            child: GroupListItem(value));
      },
      selector: (BuildContext context, GroupsManager groupsManager) {
        return groupsManager.groupsList;
      },
      shouldRebuild: (pre, next) =>
          ((pre != next) || (pre.length != next.length)),
    );
  }
}
