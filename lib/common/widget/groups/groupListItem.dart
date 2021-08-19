import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/widget/loading_Indicator.dart';
import 'package:hatchery_im/manager/group_manager/groupsManager.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';

class GroupListItem extends StatelessWidget {
  final List<Groups>? groupsLists;
  final manager = App.manager<GroupsManager>();
  GroupListItem(this.groupsLists);

  @override
  Widget build(BuildContext context) {
    return groupsLists != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: groupsLists!.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                  color: Flavors.colorInfo.mainBackGroundColor,
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    dense: true,
                    onTap: () => Routers.navigateTo('/group_profile',
                            arg: groupsLists![index].group.groupId)
                        .then((value) => value ? manager.refreshData() : null),

                    /// 群头像，没有头像则返回默认头像
                    leading: Container(
                      child: groupsLists![index].group.icon != null
                          ? netWorkAvatar(groupsLists![index].group.icon!, 20.0)
                          : _noGroupAvatar(),
                    ),

                    /// 群名称
                    title: Container(
                        child: Text(groupsLists![index].group.groupName!,
                            style: Flavors.textStyles.groupMainName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis)),
                    subtitle: Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                          '${groupsLists![index].group.groupDescription ?? '没有群简介'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Flavors.textStyles.groupMembersNumberText),
                    ),

                    /// 前三名群成员头像+剩余成员数
                    trailing: Container(
                      width: 80.0.w,
                      child: Stack(
                        alignment: Alignment.center,
                        children: _groupMembersAvatar(
                            groupsLists![index].top3Members,
                            groupsLists![index].membersCount),
                      ),
                    ),
                  ));
            })
        : IndicatorView();
  }

  _groupMembersAvatar(List<GroupMembers> top3Members, int groupsMembers) {
    List<Widget> _avatarList = [];
    double off = 18.0;
    for (var i = 0; i < 3; i++) {
      _avatarList.add(Positioned(
          left: off * i, child: netWorkAvatar(top3Members[i].icon!, 12.0)));
    }
    if (groupsMembers > 3) {
      _avatarList.add(Positioned(
        left: off * 3,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Flavors.colorInfo.mainBackGroundColor,
          ),

          /// 剩余群成员人数，如群成员少于等于3人时，不显示此view
          child: CircleAvatar(
            backgroundColor: Flavors.colorInfo.blueGrey,
            child: Container(
                child: Text('+${groupsMembers - 3}',
                    style: Flavors.textStyles.groupMembersMoreText)),
            maxRadius: 12,
          ),
        ),
      ));
    }
    return _avatarList;
  }

  Widget _noGroupAvatar() {
    return CircleAvatar(
      backgroundColor: Flavors.colorInfo.blueGrey,
      maxRadius: 20,
      child: Center(
        child: Icon(
          Icons.group,
          color: Colors.white,
        ),
      ),
    );
  }
}
