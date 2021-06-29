import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/widget/loading_view.dart';
import 'package:hatchery_im/flavors/Flavors.dart';

class CheckBoxContactsUsersItem extends StatefulWidget {
  final List<Friends> friendsLists;
  final manager;
  CheckBoxContactsUsersItem(this.friendsLists, this.manager);
  @override
  _CheckBoxContactsUsersItemState createState() =>
      _CheckBoxContactsUsersItemState();
}

class _CheckBoxContactsUsersItemState extends State<CheckBoxContactsUsersItem>
    with SingleTickerProviderStateMixin {
  Map<String, bool> _isChecked = Map();

  @override
  void initState() {
    widget.friendsLists.forEach((element) {
      print("DEBUG=> ${element.friendId}");
      _isChecked[element.friendId] = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount:
          widget.friendsLists.isNotEmpty ? widget.friendsLists.length : 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 6, right: 6, top: 10, bottom: 10),
          child: CheckboxListTile(
              secondary: widget.friendsLists.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.friendsLists[index].icon,
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
                      backgroundImage: AssetImage('images/default_avatar.png'),
                      maxRadius: 20,
                    ),
              title: Container(
                child: widget.friendsLists.isNotEmpty
                    ? Text(
                        widget.friendsLists[index].nickName,
                        style: Flavors.textStyles.friendsText,
                      )
                    : LoadingView(),
              ),
              subtitle: widget.friendsLists[index].remarks != null
                  ? Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: widget.friendsLists.isNotEmpty
                          ? Text(
                              '备注：${widget.friendsLists[index].remarks}',
                              style: Flavors.textStyles.friendsSubtitleText,
                            )
                          : LoadingView(),
                    )
                  : null,
              activeColor: Flavors.colorInfo.mainColor,
              value: _isChecked[widget.friendsLists[index].friendId],
              onChanged: (value) {
                _isChecked[widget.friendsLists[index].friendId] = value!;
                if (widget.friendsLists.isNotEmpty) {
                  setState(() {
                    if (_isChecked[widget.friendsLists[index].friendId]!) {
                      widget.manager.addSelectedFriendsIntoList(
                          widget.friendsLists[index]);
                    } else {
                      widget.manager.removeSelectedFriendsIntoList(
                          widget.friendsLists[index]);
                    }
                  });
                }
              }),
        );
      },
    );
  }
}
