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
  late List<bool> _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(widget.friendsLists.length, false);
  }

  @override
  void dispose() {
    widget.manager.selectFriendsList.clear();
    super.dispose();
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
          child: Row(
            children: <Widget>[
              Checkbox(
                  activeColor: Flavors.colorInfo.mainColor,
                  value: _isChecked[index],
                  fillColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                    return Flavors.colorInfo.mainColor;
                  }),
                  onChanged: (value) {
                    if (widget.friendsLists.isNotEmpty) {
                      setState(() {
                        _isChecked[index] = value!;
                        if (_isChecked[index]) {
                          widget.manager.selectFriendsList
                              .add(widget.friendsLists[index].friendId);
                        } else {
                          widget.manager.selectFriendsList
                              .remove(widget.friendsLists[index].friendId);
                        }
                      });
                    } else {
                      return;
                    }
                  }),
              Expanded(
                child: Row(
                  children: <Widget>[
                    widget.friendsLists.isNotEmpty
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
                            backgroundImage:
                                AssetImage('images/default_avatar.png'),
                            maxRadius: 20,
                          ),
                    SizedBox(
                      width: 16.0.w,
                    ),
                    Container(
                      color: Colors.transparent,
                      child: widget.friendsLists.isNotEmpty
                          ? Text(
                              widget.friendsLists[index].remarks != null
                                  ? widget.friendsLists[index].remarks!
                                  : widget.friendsLists[index].nickName,
                              style: Flavors.textStyles.friendsText,
                            )
                          : LoadingView(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
