import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/busniess/models/chat_users.dart';
import 'package:hatchery_im/common/contacts/contactsUsersList.dart';

class ContactsPage extends StatelessWidget {
  final List<ContactsUsers> contactsUsers = [
    ContactsUsers(
      text: "Jane Russel",
      image: "images/userImage1.jpeg",
    ),
    ContactsUsers(
      text: "Glady's Murphy",
      image: "images/userImage2.jpeg",
    ),
    ContactsUsers(
      text: "Jorge Henry",
      image: "images/userImage3.jpeg",
    ),
    ContactsUsers(
      text: "Philip Fox",
      image: "images/userImage4.jpeg",
    ),
    ContactsUsers(
      text: "Debra Hawkins",
      image: "images/userImage5.jpeg",
    ),
    ContactsUsers(
      text: "Jacob Pena",
      image: "images/userImage6.jpeg",
    ),
    ContactsUsers(
      text: "Andrey Jones",
      image: "images/userImage7.jpeg",
    ),
    ContactsUsers(
      text: "John Wick",
      image: "images/userImage8.jpeg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "联系人(20)",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.more_vert,
                      color: Colors.black,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              itemCount: contactsUsers.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ContactsUsersListItem(
                  text: contactsUsers[index].text,
                  image: contactsUsers[index].image,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
