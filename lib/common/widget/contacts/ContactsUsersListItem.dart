import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactsUsersListItem extends StatelessWidget {
  final List<Friends> friendsLists;
  ContactsUsersListItem(this.friendsLists);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friendsLists.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
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
                        backgroundImage: CachedNetworkImageProvider(
                            friendsLists[index].icon),
                        maxRadius: 20,
                      ),
                      SizedBox(
                        width: 16.0.w,
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(friendsLists[index].remarks != null
                                  ? friendsLists[index].remarks!
                                  : friendsLists[index].nickName),
                              SizedBox(
                                height: 6.0.h,
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
      },
    );
  }
}
