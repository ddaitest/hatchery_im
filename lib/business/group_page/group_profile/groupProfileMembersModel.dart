import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/profile_manager/groupProfile_manager/groupProfileManager.dart';

enum ManagerType {
  add,
  delete,
}

class GroupMembersGrid extends StatelessWidget {
  final List<GroupMembers>? groupMembersList;
  GroupMembersGrid(this.groupMembersList);
  final manager = App.manager<GroupProfileManager>();
  final managerAddType = ManagerType.add;
  final managerDeleteType = ManagerType.delete;

  @override
  Widget build(BuildContext context) {
    return groupMembersList != null
        ? Container(
            color: Flavors.colorInfo.mainBackGroundColor,
            padding: const EdgeInsets.all(13.0),
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
                    return _managerBtnView(managerAddType);
                  } else if (index == groupMembersList!.length + 1) {
                    return _managerBtnView(managerDeleteType);
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
          height: 50.0,
          child: Text('$name'),
        )),
      ],
    );
  }

  Widget _managerBtnView(ManagerType managerType) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(bottom: 12.0),
        child: CircleAvatar(
          backgroundColor: Colors.blueGrey,
          radius: 20.0,
          child: Center(
            child: Icon(
              managerType == managerAddType ? Icons.add : Icons.remove,
              color: Colors.white,
              size: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
