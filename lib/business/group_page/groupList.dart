import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/widget/groups/groupListItem.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/group_manager/groupsManager.dart';
import 'package:hatchery_im/common/widget/selectContactsModel.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/routers.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final groupsManager = App.manager<GroupsManager>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void initState() {
    groupsManager.init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    groupsManager.refreshData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SmartRefresher(
      enablePullDown: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          SearchBarView(
              searchHintText: "搜索群组",
              isAutofocus: false,
              textEditingController: groupsManager.searchController,
              isEnabled: true),
          _createGroupsView(),
          // dividerViewCommon(),
          // _newGroupsApply(),
          _groupListView(),
        ],
      ),
    ));
  }

  Widget _groupListView() {
    return Selector<GroupsManager, List<Groups>?>(
      builder: (BuildContext context, List<Groups>? value, Widget? child) {
        print("DEBUG=> _groupListView 重绘了。。。。。");
        return Container(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: GroupListItem(value));
      },
      selector: (BuildContext context, GroupsManager groupsManager) {
        return groupsManager.groupsList ?? null;
      },
      shouldRebuild: (pre, next) =>
          ((pre != next) || (pre!.length != next!.length)),
    );
  }

  Widget _createGroupsView() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
          onTap: () => Routers.navigateTo('/select_contacts_model', arg: {
            'titleText': '创建群组',
            'tipsText': '请至少选择两名好友作为群成员',
            'leastSelected': 2,
            'nextPageBtnText': '完成',
            'selectContactsType': SelectContactsType.CreateGroup,
            'groupMembersFriendId': ['']
          }).then((value) => value ? groupsManager.refreshData() : null),
          leading: CircleAvatar(
            backgroundColor: Colors.pink,
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
          trailing: Container(
            width: 20.0.w,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: Flavors.colorInfo.lightGrep,
            ),
          ),
        ));
  }
}
