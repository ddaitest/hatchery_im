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
      appBar: AppBarFactory.getMain("联系人(${contactsUsers.length})", actions: [
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
    return ListView.builder(
      itemCount: contactsUsers.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ContactsUsersListItem(
          text: contactsUsers[index].text,
          image: contactsUsers[index].image,
        );
      },
    );
  }
}
