import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:image_stack/image_stack.dart';

class GroupListItem extends StatelessWidget {
  final List<Groups> groupsLists;
  GroupListItem(this.groupsLists);

  @override
  Widget build(BuildContext context) {
    return groupsLists.isNotEmpty
        ? GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChatDetailPage();
              }));
            },
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: groupsLists.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //横轴元素个数
                    crossAxisCount: 2,
                    //纵轴间距
                    mainAxisSpacing: 16.0,
                    //横轴间距
                    crossAxisSpacing: 16.0,
                    //子组件宽高长度比例
                    childAspectRatio: 150 / 190),
                itemBuilder: (context, index) {
                  return Container(
                    width: 150.0.w,
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(236, 240, 250, 1), width: 1),
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular((4.0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /// 群头像，没有头像则返回top3Members中的三个头像合集
                        groupsLists[index].group.icon != ''
                            ? Container(
                                padding: const EdgeInsets.only(
                                    left: 42.0, right: 42.0, top: 20.0),
                                child: _netWorkAvatar(
                                    groupsLists[index].group.icon!, 33.0),
                              )
                            : Container(
                                padding: const EdgeInsets.only(
                                    left: 42.0, right: 42.0, top: 20.0),
                                child: _noGroupAvatar(
                                    groupsLists[index].top3Members)),

                        /// 群名字
                        Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 8.5, bottom: 8.5),
                            child: Text(groupsLists[index].group.groupName!,
                                style: Flavors.textStyles.groupMainName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)),

                        /// 群简介
                        Text('${groupsLists[index].group.notes}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Flavors.textStyles.groupMembersNumberText),

                        /// 前三名群成员头像
                        Expanded(
                            child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: _groupMembersAvatar(
                                      groupsLists[index].top3Members,
                                      groupsLists[index].membersCount),
                                )))
                      ],
                    ),
                  );
                }))
        : Container();
  }

  Widget _netWorkAvatar(String avatarUrl, double radius) {
    return CachedNetworkImage(
        imageUrl: avatarUrl,
        placeholder: (context, url) => CircleAvatar(
              backgroundImage: AssetImage('images/default_avatar.png'),
              maxRadius: radius,
            ),
        errorWidget: (context, url, error) => CircleAvatar(
              backgroundImage: AssetImage('images/default_avatar.png'),
              maxRadius: radius,
            ),
        imageBuilder: (context, imageProvider) {
          return CircleAvatar(
            backgroundImage: imageProvider,
            maxRadius: radius,
          );
        });
  }

  _groupMembersAvatar(List<GroupsTop3Members> top3Members, int groupsMembers) {
    List<Widget> _avatarList = [];
    for (int i = 0; i < top3Members.length; i++) {
      _avatarList.add(
        _netWorkAvatar(top3Members[i].icon!, 12.0),
      );
    }
    if (groupsMembers > 3) {
      _avatarList.add(CircleAvatar(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white70,
          ),

          /// 剩余群成员人数，如群成员少于等于3人时，不显示此view
          child: Center(
              child: Text('+${groupsMembers - 3}',
                  style: Flavors.textStyles.groupMembersMoreText)),
        ),
        maxRadius: 12,
      ));
    }
    return _avatarList;
  }

  Widget _noGroupAvatar(List<GroupsTop3Members> top3Members) {
    return Container(
      width: 66.0.w,
      height: 66.0.h,
      decoration: BoxDecoration(
        color: Flavors.colorInfo.mainTextColor,
        shape: BoxShape.circle,
        border: Border.all(color: Flavors.colorInfo.dividerColor),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        // textDirection: TextDirection.rtl,
        children: [
          Positioned(
            child: _netWorkAvatar(top3Members[2].icon!, 12.0),
            top: 10.0,
          ),
          Positioned(
            top: 25.0,
            bottom: 10.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _netWorkAvatar(top3Members[0].icon!, 12.0),
                _netWorkAvatar(top3Members[1].icon!, 12.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
