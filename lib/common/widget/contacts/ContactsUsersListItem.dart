import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/widget/loading_view.dart';
import 'package:hatchery_im/flavors/Flavors.dart';

class ContactsUsersList extends StatelessWidget {
  final List<Friends> friendsLists;
  ContactsUsersList(this.friendsLists);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friendsLists.isNotEmpty ? friendsLists.length : 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChatDetailPage(friendsLists[index]);
            }));
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                friendsLists.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: friendsLists[index].icon,
                        placeholder: (context, url) => CircleAvatar(
                              backgroundImage:
                                  AssetImage('images/default_avatar.png'),
                              maxRadius: 20,
                            ),
                        errorWidget: (context, url, error) => CircleAvatar(
                              backgroundImage:
                                  AssetImage('images/default_avatar.png'),
                              maxRadius: 20,
                            ),
                        imageBuilder: (context, imageProvider) {
                          return CircleAvatar(
                            backgroundImage: imageProvider,
                            maxRadius: 20,
                          );
                        })
                    : CircleAvatar(
                        backgroundImage:
                            AssetImage('images/default_avatar.png'),
                        maxRadius: 20,
                      ),
                SizedBox(
                  width: 16.0.w,
                ),
                Container(
                  color: Colors.transparent,
                  width: Flavors.sizesInfo.screenWidth - 100.0.w,
                  child: friendsLists.isNotEmpty
                      ? Text(
                          friendsLists[index].remarks != null
                              ? friendsLists[index].remarks!
                              : friendsLists[index].nickName,
                          style: Flavors.textStyles.friendsText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis)
                      : LoadingView(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchContactsUsersList extends StatelessWidget {
  final List<SearchNewContactsInfo> newContactsList;
  SearchContactsUsersList(this.newContactsList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newContactsList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            dense: true,
            leading: CachedNetworkImage(
                imageUrl: newContactsList[index].icon,
                placeholder: (context, url) => CircleAvatar(
                      backgroundImage: AssetImage('images/default_avatar.png'),
                      maxRadius: 30,
                    ),
                errorWidget: (context, url, error) => CircleAvatar(
                      backgroundImage: AssetImage('images/default_avatar.png'),
                      maxRadius: 30,
                    ),
                imageBuilder: (context, imageProvider) {
                  return CircleAvatar(
                    backgroundImage: imageProvider,
                    maxRadius: 30,
                  );
                }),
            title: Container(
              color: Colors.transparent,
              child: Text(newContactsList[index].nickName,
                  style: Flavors.textStyles.searchContactsNameText,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            subtitle: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(newContactsList[index].notes ?? '这家伙很懒什么也没有写',
                  style: Flavors.textStyles.searchContactsNotesText,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            trailing: Container(
              color: Colors.transparent,
              width: 40.0.w,
              child: Text('好友'),
            ),
          ),
        );
      },
    );
  }
}

class NewContactsUsersList extends StatelessWidget {
  final List<FriendsApplicationInfo> contactsApplicationList;
  NewContactsUsersList(this.contactsApplicationList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contactsApplicationList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            dense: true,
            leading: CachedNetworkImage(
                imageUrl: contactsApplicationList[index].icon,
                placeholder: (context, url) => CircleAvatar(
                      backgroundImage: AssetImage('images/default_avatar.png'),
                      maxRadius: 20,
                    ),
                errorWidget: (context, url, error) => CircleAvatar(
                      backgroundImage: AssetImage('images/default_avatar.png'),
                      maxRadius: 20,
                    ),
                imageBuilder: (context, imageProvider) {
                  return CircleAvatar(
                    backgroundImage: imageProvider,
                    maxRadius: 20,
                  );
                }),
            title: Container(
              color: Colors.transparent,
              child: Text(contactsApplicationList[index].nickName,
                  style: Flavors.textStyles.searchContactsNameText,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            subtitle: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(contactsApplicationList[index].remarks ?? '',
                  style: Flavors.textStyles.searchContactsNotesText,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            trailing: Container(
              color: Colors.transparent,
              // width: 40.0.w,
              child: TextButton(
                onPressed: () {},
                child: Text('同意'),
              ),
            ),
          ),
        );
      },
    );
  }
}
