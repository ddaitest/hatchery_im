import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatchery_im/common/widget/loading_view.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/manager/contacts_manager/selectContactsModelManager.dart';
import '../../../config.dart';
import '../../AppContext.dart';
import '../../log.dart';

class CheckBoxContactsUsersItem extends StatefulWidget {
  final List<Friends>? friendsLists;
  final List<GroupMembers>? groupMembersList;
  final SelectContactsType selectContactsType;
  CheckBoxContactsUsersItem(
      this.friendsLists, this.groupMembersList, this.selectContactsType);
  @override
  _CheckBoxContactsUsersItemState createState() =>
      _CheckBoxContactsUsersItemState();
}

class _CheckBoxContactsUsersItemState extends State<CheckBoxContactsUsersItem> {
  Map<String, bool> _isChecked = Map();
  List<String> groupMembersFriendId = [];
  final manager = App.manager<SelectContactsModelManager>();

  @override
  void initState() {
    Log.green("friendsLists ${widget.friendsLists}");
    // print("DEBUG=> groupMembersList ${widget.groupMembersList!}");
    if (widget.selectContactsType == SelectContactsType.AddGroupMember) {
      if (widget.groupMembersList != null) {
        if (widget.groupMembersList!.isNotEmpty) {
          if (widget.selectContactsType == SelectContactsType.AddGroupMember) {
            widget.groupMembersList!.forEach((element) {
              groupMembersFriendId.add(element.userID!);
            });
            Log.green("groupMembersFriendId ${groupMembersFriendId}");
            widget.friendsLists?.forEach((element) {
              if (groupMembersFriendId.contains(element.friendId)) {
                _isChecked[element.friendId] = true;
              } else {
                _isChecked[element.friendId] = false;
              }
            });
          }
        }
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    groupMembersFriendId.clear();
    widget.groupMembersList?.clear();
    widget.friendsLists?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _listItemCount(widget.selectContactsType),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 6, right: 6, top: 10, bottom: 10),
          child: CheckboxListTile(
              dense: false,
              tristate: false,
              secondary: _avatarView(index, widget.selectContactsType),
              title: _titleView(index, widget.selectContactsType),
              subtitle: _subtitleView(index, widget.selectContactsType),
              activeColor: Flavors.colorInfo.mainColor,
              value: _setCheckBoxValue(index, widget.selectContactsType),
              onChanged: widget.selectContactsType ==
                          SelectContactsType.CreateGroup ||
                      widget.selectContactsType ==
                          SelectContactsType.AddGroupMember ||
                      widget.selectContactsType == SelectContactsType.Share
                  ? groupMembersFriendId
                          .contains(widget.friendsLists?[index].friendId)
                      ? null
                      : (value) {
                          Log.green("value $value");
                          if (widget.friendsLists != null &&
                              widget.friendsLists!.isNotEmpty) {
                            _isChecked[widget.friendsLists![index].friendId] =
                                value!;
                            setState(() {
                              if (_isChecked[
                                  widget.friendsLists![index].friendId]!) {
                                manager.addSelectedFriendsIntoList(
                                    widget.friendsLists![index]);
                              } else {
                                manager.removeSelectedFriendsIntoList(
                                    widget.friendsLists![index]);
                              }
                            });
                          }
                        }
                  : (value) {
                      if (widget.groupMembersList!.isNotEmpty ||
                          widget.groupMembersList != null) {
                        setState(() {
                          _isChecked[widget.groupMembersList![index].userID!] =
                              value!;
                          if (_isChecked[
                              widget.groupMembersList![index].userID]!) {
                            manager.addSelectedGroupMembersIntoList(
                                widget.groupMembersList![index]);
                          } else {
                            manager.removeSelectedGroupMembersIntoList(
                                widget.groupMembersList![index]);
                          }
                        });
                      }
                    }),
        );
      },
    );
  }

  int _listItemCount(selectContactsType) {
    if (selectContactsType == SelectContactsType.DeleteGroupMember) {
      return widget.groupMembersList!.length;
    } else {
      return widget.friendsLists!.length;
    }
  }

  Widget _avatarView(int index, selectContactsType) {
    if (selectContactsType == SelectContactsType.CreateGroup ||
        selectContactsType == SelectContactsType.AddGroupMember ||
        selectContactsType == SelectContactsType.Share) {
      return widget.friendsLists!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: widget.friendsLists![index].icon,
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

  Widget _titleView(int index, selectContactsType) {
    if (selectContactsType == SelectContactsType.CreateGroup ||
        selectContactsType == SelectContactsType.AddGroupMember ||
        selectContactsType == SelectContactsType.Share) {
      return Container(
        child: widget.friendsLists!.isNotEmpty
            ? Text(
                widget.friendsLists![index].nickName,
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

  Widget? _subtitleView(int index, selectContactsType) {
    if (selectContactsType == SelectContactsType.CreateGroup ||
        selectContactsType == SelectContactsType.AddGroupMember ||
        widget.selectContactsType == SelectContactsType.Share) {
      return widget.friendsLists![index].remarks != null &&
              widget.friendsLists![index].remarks != ''
          ? Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: widget.friendsLists!.isNotEmpty
                  ? Text(
                      '备注：${widget.friendsLists![index].remarks}',
                      style: Flavors.textStyles.friendsSubtitleText,
                    )
                  : LoadingView(),
            )
          : null;
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
          : null;
    } else {
      return null;
    }
  }

  bool _setCheckBoxValue(int index, selectContactsType) {
    if (selectContactsType == SelectContactsType.CreateGroup ||
        selectContactsType == SelectContactsType.AddGroupMember ||
        widget.selectContactsType == SelectContactsType.Share) {
      return _isChecked[widget.friendsLists![index].friendId] ?? false;
    } else if (selectContactsType == SelectContactsType.DeleteGroupMember) {
      return _isChecked[widget.groupMembersList![index].userID] ?? false;
    } else {
      return false;
    }
  }
}
