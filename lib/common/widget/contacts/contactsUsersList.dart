import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';
import 'package:flutter/material.dart';

class ContactsUsersListItem extends StatelessWidget {
  final String? text;
  final String? image;
  ContactsUsersListItem({@required this.text, @required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatDetailPage();
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(image!),
                    maxRadius: 20,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(text!),
                          SizedBox(
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
