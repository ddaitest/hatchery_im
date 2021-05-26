import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/busniess/models/chat_users.dart';
import 'package:hatchery_im/common/widget/contacts/ContactsUsersListItem.dart';
import 'package:hatchery_im/common/widget/contacts/groupListItem.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<ContactsPage>
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
  late TabController _tabController;
  int tabIndex = 0;

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
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
      appBar: AppBarFactory.getMain("联系人(${contactsUsers.length})", actions: [
        Container(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(
            Icons.person_add_outlined,
            color: Colors.black,
            size: 25,
          ),
        ),
      ]),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SearchBarView(),
            _tabBarContainer(),
            _tabViewInfo(),
          ],
        ),
      ),
    );
  }

  _tabBarContainer() {
    return Container(
        padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
        child: TabBar(
            controller: _tabController,
            onTap: (value) {
              setState(() {
                tabIndex = value;
                print("DEBUG=> LC $value");
              });
            },
            indicator: const BoxDecoration(),
            // unselectedLabelStyle: Flavors.textStyles.contactsIconTextUnSelect,
            tabs: <Widget>[
              _tabBarView('images/new_friend.png', '新的朋友', 0),
              _tabBarView('images/group.png', '群组', 1),
              // _topViewItem('images/new_friend.png', '新的朋友', 2),
            ]));
  }

  _tabBarView(String imagePath, String iconText, int selectIndex) {
    return Container(
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: 54.0.h,
            width: 54.0.w,
          ),
          SizedBox(height: 5.0.h),
          Text(
            iconText,
            style: selectIndex == tabIndex
                ? Flavors.textStyles.contactsIconTextSelect
                : Flavors.textStyles.contactsIconTextUnSelect,
          )
        ],
      ),
    );
  }

  _tabViewInfo() {
    return Container(
      height: Flavors.sizesInfo.screenHeight,
      child: TabBarView(
          controller: _tabController,
          children: [_contactsListView(), _groupListView()]),
    );
  }

  _contactsListView() {
    return ListView.builder(
      itemCount: contactsUsers.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return ContactsUsersListItem(
          text: contactsUsers[index].text,
          image: contactsUsers[index].image,
        );
      },
    );
  }

  _groupListView() {
    return Container(
      padding: const EdgeInsets.only(left: 38, right: 38, top: 23, bottom: 23),
      child: GridView.builder(
        itemCount: contactsUsers.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //横轴元素个数
            crossAxisCount: 2,
            //纵轴间距
            mainAxisSpacing: 20.0,
            //横轴间距
            crossAxisSpacing: 38.0,
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
