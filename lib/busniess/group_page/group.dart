import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/busniess/models/chat_users.dart';
import 'package:hatchery_im/common/widget/contacts/ContactsUsersListItem.dart';
import 'package:hatchery_im/common/widget/groups/groupListItem.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/groupsManager.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/widget/loading_Indicator.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final manager = App.manager<GroupsManager>();

  void initState() {
    manager.init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          SearchBarView(),
          _createGroupsView(),
          dividerViewCommon(),
          _addGroupsView(),
          dividerViewCommon(),
          _newGroupsApply(),
          SizedBox(height: 10.0.h),
          _groupListView(),
        ],
      ),
    );
  }

  Widget _groupListView() {
    return Selector<GroupsManager, List<Groups>>(
      builder: (BuildContext context, List<Groups> value, Widget? child) {
        print("DEBUG=> _groupListView 重绘了。。。。。");
        return Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
            child: GroupListItem(value));
      },
      selector: (BuildContext context, GroupsManager groupsManager) {
        return groupsManager.groupsList;
      },
      shouldRebuild: (pre, next) =>
          ((pre != next) || (pre.length != next.length)),
    );
  }

  Widget _addGroupsView() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
          // onTap: () => Routers.navigateTo('/search_new_contacts')
          //     .then((value) => value ? manager.refreshData() : null),
          leading: CircleAvatar(
            backgroundColor: Colors.pink,
            maxRadius: 20,
            child: Center(
              child: Icon(
                Icons.group_add,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            '查找群组',
            style: Flavors.textStyles.friendsText,
          ),
          trailing: Container(width: 30.0.w),
        ));
  }

  Widget _createGroupsView() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
          // onTap: () => Routers.navigateTo('/search_new_contacts')
          //     .then((value) => value ? manager.refreshData() : null),
          leading: CircleAvatar(
            backgroundColor: Colors.blueGrey,
            maxRadius: 20,
            child: Center(
              child: Icon(
                Icons.groups,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            '创建群组',
            style: Flavors.textStyles.friendsText,
          ),
          trailing: Container(width: 30.0.w),
        ));
  }

  Widget _newGroupsApply() {
    return Selector<GroupsManager, List<FriendsApplicationInfo>>(
      builder: (BuildContext context, List<FriendsApplicationInfo> value,
          Widget? child) {
        print("DEBUG=> _FriendsView 重绘了。。。。。");
        return Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ListTile(
              // onTap: () =>
              //     Routers.navigateTo("/contacts_application", arg: value),
              // onTap: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => ContactsApplicationPage(value)))
              //     .then((value) => value ? manager.refreshData() : null),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                maxRadius: 20,
                child: Center(
                  child: Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                '入群申请',
                style: Flavors.textStyles.friendsText,
              ),
              trailing: value.isNotEmpty
                  ? Container(
                      width: 30.0.w,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        maxRadius: 10,
                        child: Center(
                          child: Text('${value.length}',
                              style: Flavors.textStyles.homeTabBubbleText),
                        ),
                      ),
                    )
                  : Container(width: 30.0.w),
            ));
      },
      selector: (BuildContext context, GroupsManager groupsManager) {
        return groupsManager.groupApplicationList;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }
}
