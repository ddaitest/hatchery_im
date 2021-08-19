import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatchery_im/common/widget/loading_view.dart';
import 'package:hatchery_im/flavors/Flavors.dart';

class CheckBoxGroupMembersItem extends StatefulWidget {
  final List<GroupMembers> groupMembers;
  final manager;
  CheckBoxGroupMembersItem(this.groupMembers, this.manager);
  @override
  _CheckBoxGroupMembersItemState createState() =>
      _CheckBoxGroupMembersItemState();
}

class _CheckBoxGroupMembersItemState extends State<CheckBoxGroupMembersItem> {
  Map<String, bool> _isChecked = Map();

  @override
  void initState() {
    if (widget.groupMembers.isNotEmpty) {
      widget.groupMembers.forEach((element) {
        _isChecked[element.userID!] = false;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.groupMembers.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 6, right: 6, top: 10, bottom: 10),
          child: CheckboxListTile(
              tristate: false,
              secondary: widget.groupMembers.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.groupMembers[index].icon!,
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
                child: widget.groupMembers.isNotEmpty
                    ? Text(
                        widget.groupMembers[index].nickName!,
                        style: Flavors.textStyles.friendsText,
                      )
                    : LoadingView(),
              ),
              activeColor: Flavors.colorInfo.mainColor,
              value: _isChecked[widget.groupMembers[index].userID] ?? false,
              onChanged: (value) {
                print("DEBUG=> value $value");
                _isChecked[widget.groupMembers[index].userID!] = value!;
                if (widget.groupMembers.isNotEmpty) {
                  setState(() {
                    if (_isChecked[widget.groupMembers[index].userID]!) {
                      widget.manager.addSelectedFriendsIntoList(
                          widget.groupMembers[index]);
                    } else {
                      widget.manager.removeSelectedFriendsIntoList(
                          widget.groupMembers[index]);
                    }
                  });
                }
              }),
        );
      },
    );
  }
}
