import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/profile_manager/groupProfile_manager/groupProfileManager.dart';

import '../../../config.dart';
import '../../../routers.dart';

class GroupMembersGrid extends StatelessWidget {
  final String? groupId;
  final List<GroupMembers>? groupMembersList;
  GroupMembersGrid(this.groupId, this.groupMembersList);
  final manager = App.manager<GroupProfileManager>();

  @override
  Widget build(BuildContext context) {
    return groupMembersList != null
        ? Container(
            color: Flavors.colorInfo.mainBackGroundColor,
            padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
            child: GridView.builder(
              itemCount: manager.isManager
                  ? groupMembersList!.length + 2
                  : groupMembersList!.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 0.9),
              itemBuilder: (BuildContext context, int index) {
                if (manager.isManager) {
                  if (index == groupMembersList!.length) {
                    return _managerBtnView(
                        SelectContactsType.AddGroupMember, index);
                  } else if (index == groupMembersList!.length + 1) {
                    return _managerBtnView(
                        SelectContactsType.DeleteGroupMember, index);
                  } else {
                    return _groupAvatarItem(groupMembersList![index].icon!,
                        groupMembersList![index].nickName!);
                  }
                } else {
                  return _groupAvatarItem(groupMembersList![index].icon!,
                      groupMembersList![index].nickName!);
                }
              },
            ),
          )
        : Container();
  }

  Widget _groupAvatarItem(String image, String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        netWorkAvatar(image, 20.0),
        SizedBox(
          height: 3.0.h,
        ),
        Expanded(
            child: Container(
          height: 50.0.h,
          child: Text('$name',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: Flavors.textStyles.groupProfileMembersNameText,
              overflow: TextOverflow.ellipsis),
        )),
      ],
    );
  }

  Widget _managerBtnView(SelectContactsType selectContactsType, int index) {
    return GestureDetector(
      onTap: () => Routers.navigateTo('/select_contacts_model', arg: {
        'groupId': groupId,
        'titleText': selectContactsType == SelectContactsType.AddGroupMember
            ? '邀请入群'
            : '移出群组',
        'tipsText': '请至少选择一名好友',
        'leastSelected': 1,
        'nextPageBtnText':
            selectContactsType == SelectContactsType.AddGroupMember
                ? '邀请'
                : '确定',
        'selectContactsType':
            selectContactsType == SelectContactsType.AddGroupMember
                ? SelectContactsType.AddGroupMember
                : SelectContactsType.DeleteGroupMember,
        'groupMembersList': manager.groupMembersList!
      }).then((value) =>
          value ? manager.refreshData(manager.groupInfo!.groupId!) : null),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(bottom: 12.0),
        child: CircleAvatar(
          backgroundColor: Colors.blueGrey[200],
          radius: 20.0,
          child: Center(
            child: Icon(
              selectContactsType == SelectContactsType.AddGroupMember
                  ? Icons.add
                  : Icons.remove,
              color: Flavors.colorInfo.mainBackGroundColor,
              size: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
