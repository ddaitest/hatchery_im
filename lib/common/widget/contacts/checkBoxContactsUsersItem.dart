import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatchery_im/common/widget/loading_view.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import '../../../config.dart';

class CheckBoxContactsUsersItem extends StatefulWidget {
  final List<Friends> friendsLists;
  final List<String> groupMembersFriendId;
  final SelectContactsType selectContactsType;
  final manager;
  CheckBoxContactsUsersItem(this.friendsLists, this.groupMembersFriendId,
      this.selectContactsType, this.manager);
  @override
  _CheckBoxContactsUsersItemState createState() =>
      _CheckBoxContactsUsersItemState();
}

class _CheckBoxContactsUsersItemState extends State<CheckBoxContactsUsersItem> {
  Map<String, bool> _isChecked = Map();

  @override
  void initState() {
    if (widget.friendsLists.isNotEmpty) {
      if (widget.selectContactsType == SelectContactsType.AddGroupMember &&
          widget.groupMembersFriendId.isNotEmpty) {
        print("DEBUG=> groupMembersFriendId ${widget.groupMembersFriendId}");
        widget.friendsLists.forEach((element) {
          if (widget.groupMembersFriendId.contains(element.friendId)) {
            _isChecked[element.friendId] = true;
          } else {
            _isChecked[element.friendId] = false;
          }
        });
      } else {
        print("DEBUG=> initState initState");
        widget.friendsLists.forEach((element) {
          _isChecked[element.friendId] = false;
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.friendsLists.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        /// todo 缺少蒙层；缺少不可点击
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 6, right: 6, top: 10, bottom: 10),
          child: CheckboxListTile(
              dense: false,
              tristate: false,
              selected: false,
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
                      padding: const EdgeInsets.only(top: 5.0),
                      child: widget.friendsLists.isNotEmpty
                          ? Text(
                              '备注：${widget.friendsLists[index].remarks}',
                              style: Flavors.textStyles.friendsSubtitleText,
                            )
                          : LoadingView(),
                    )
                  : null,
              activeColor: Flavors.colorInfo.mainColor,
              value: _isChecked[widget.friendsLists[index].friendId] ?? false,
              onChanged: (value) {
                print("DEBUG=> value $value");
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
