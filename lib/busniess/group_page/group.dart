import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/busniess/models/chat_users.dart';
import 'package:hatchery_im/common/widget/contacts/ContactsUsersListItem.dart';
import 'package:hatchery_im/common/widget/contacts/groupListItem.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  void initState() {
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

  _groupListView() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: contactsUsers.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //横轴元素个数
            crossAxisCount: 2,
            //纵轴间距
            mainAxisSpacing: 16.0,
            //横轴间距
            crossAxisSpacing: 16.0,
            //子组件宽高长度比例
            childAspectRatio: 150 / 190),
        itemBuilder: (context, index) {
          return GroupListItem(
            mainImageUrl: 'images/userImage2.jpeg',
            groupName: '印度基友群',
            groupMembersImageUrl: [
              'images/userImage1.jpeg',
              'images/userImage2.jpeg',
              'images/userImage3.jpeg'
            ],
            membersNumber: 20,
          );
        },
      ),
    );
  }
}
