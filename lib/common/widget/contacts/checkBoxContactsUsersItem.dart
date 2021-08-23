import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatchery_im/common/widget/loading_view.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import '../../../config.dart';

class CheckBoxContactsUsersItem extends StatefulWidget {
  final List<Friends> friendsLists;
  final List<GroupMembers>? groupMembersList;
  final SelectContactsType selectContactsType;
  final manager;
  CheckBoxContactsUsersItem(this.friendsLists, this.groupMembersList,
      this.selectContactsType, this.manager);
  @override
  _CheckBoxContactsUsersItemState createState() =>
      _CheckBoxContactsUsersItemState();
}

class _CheckBoxContactsUsersItemState extends State<CheckBoxContactsUsersItem> {
  Map<String, bool> _isChecked = Map();
  List<String> groupMembersFriendId = [];

  @override
  void initState() {
    if (widget.groupMembersList!.isNotEmpty) {
      if (widget.selectContactsType == SelectContactsType.AddGroupMember) {
        print("DEBUG=> groupMembersList ${widget.groupMembersList!}");
        widget.groupMembersList!.forEach((element) {
          groupMembersFriendId.add(element.userID!);
        });
        print("DEBUG=> groupMembersFriendId ${groupMembersFriendId}");
        widget.friendsLists.forEach((element) {
          if (groupMembersFriendId.contains(element.friendId)) {
            _isChecked[element.friendId] = true;
          } else {
            _isChecked[element.friendId] = false;
          }
        });
      } else if (widget.selectContactsType ==
          SelectContactsType.DeleteGroupMember) {
        print("DEBUG=> DeleteGroupMember DeleteGroupMember");
        widget.groupMembersList!.forEach((element) {
          _isChecked[element.userID!] = false;
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
  void dispose() {
    groupMembersFriendId.clear();
    widget.groupMembersList?.clear();
    widget.friendsLists.clear();
    super.dispose();
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
            secondary: _avatarView(index, widget.selectContactsType),
            title: _titleView(index, widget.selectContactsType),
            subtitle: _subtitleView(index, widget.selectContactsType),
            activeColor: Flavors.colorInfo.mainColor,

            /// todo
            value: _isChecked[widget.friendsLists[index].friendId] ?? false,
            onChanged: groupMembersFriendId
                    .contains(widget.friendsLists[index].friendId)
                ? null
                : (value) {
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
                  },
          ),
        );
      },
    );
  }

  Widget _avatarView(int index, SelectContactsType selectContactsType) {
    if (selectContactsType == SelectContactsType.CreateGroup) {
      return widget.friendsLists.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: widget.friendsLists[index].icon,
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
              })
          : CircleAvatar(
              backgroundImage: AssetImage('images/default_avatar.png'),
              maxRadius: 20,
            );
    } else if (selectContactsType == SelectContactsType.AddGroupMember) {
      return widget.friendsLists.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: widget.friendsLists[index].icon,
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
              })
          : CircleAvatar(
              backgroundImage: AssetImage('images/default_avatar.png'),
              maxRadius: 20,
            );
    } else if (selectContactsType == SelectContactsType.DeleteGroupMember) {
      return widget.groupMembersList!.isNotEmpty &&
              widget.groupMembersList != null
          ? CachedNetworkImage(
              imageUrl: widget.groupMembersList![index].icon!,
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
              })
          : CircleAvatar(
              backgroundImage: AssetImage('images/default_avatar.png'),
              maxRadius: 20,
            );
    } else {
      return Container();
    }
  }

  Widget _titleView(int index, SelectContactsType selectContactsType) {
    if (selectContactsType == SelectContactsType.CreateGroup) {
      return Container(
        child: widget.friendsLists.isNotEmpty
            ? Text(
                widget.friendsLists[index].nickName,
                style: Flavors.textStyles.friendsText,
              )
            : LoadingView(),
      );
    } else if (selectContactsType == SelectContactsType.AddGroupMember) {
      return Container(
        child: widget.friendsLists.isNotEmpty
            ? Text(
                widget.friendsLists[index].nickName,
                style: Flavors.textStyles.friendsText,
              )
            : LoadingView(),
      );
    } else if (selectContactsType == SelectContactsType.DeleteGroupMember) {
      return Container(
        child: widget.groupMembersList!.isNotEmpty
            ? Text(
                widget.groupMembersList![index].nickName!,
                style: Flavors.textStyles.friendsText,
              )
            : LoadingView(),
      );
    } else {
      return Container();
    }
  }

  Widget _subtitleView(int index, SelectContactsType selectContactsType) {
    if (selectContactsType == SelectContactsType.CreateGroup) {
      return widget.friendsLists[index].remarks != null &&
              widget.friendsLists[index].remarks != ''
          ? Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: widget.friendsLists.isNotEmpty
                  ? Text(
                      '备注：${widget.friendsLists[index].remarks}',
                      style: Flavors.textStyles.friendsSubtitleText,
                    )
                  : LoadingView(),
            )
          : Container();
    } else if (selectContactsType == SelectContactsType.AddGroupMember) {
      return widget.friendsLists[index].remarks != null &&
              widget.friendsLists[index].remarks != ''
          ? Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: widget.friendsLists.isNotEmpty
                  ? Text(
                      '备注：${widget.friendsLists[index].remarks}',
                      style: Flavors.textStyles.friendsSubtitleText,
                    )
                  : LoadingView(),
            )
          : Container();
    } else if (selectContactsType == SelectContactsType.DeleteGroupMember) {
      return widget.groupMembersList![index].groupNickName != null &&
              widget.groupMembersList![index].groupNickName != ''
          ? Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: widget.groupMembersList!.isNotEmpty
                  ? Text(
                      '备注：${widget.groupMembersList![index].groupNickName}',
                      style: Flavors.textStyles.friendsSubtitleText,
                    )
                  : LoadingView(),
            )
          : Container();
    } else {
      return Container();
    }
  }
}
