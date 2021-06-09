import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/busniess/models/chat_users.dart';
import 'package:hatchery_im/common/widget/contacts/checkBoxContactsUsersItem.dart';
import 'package:hatchery_im/common/widget/groups/groupListItem.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:hatchery_im/manager/contactsManager.dart';
import 'package:hatchery_im/manager/newGroupsManager.dart';
import 'package:hatchery_im/busniess/group_page/createNewGroupDetail.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/routers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewGroupPage extends StatefulWidget {
  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroupPage>
    with SingleTickerProviderStateMixin {
  final manager = App.manager<NewGroupsManager>();
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
    return Scaffold(
      appBar: AppBarFactory.backButton('创建群组', actions: [
        Container(
            padding: const EdgeInsets.all(6.0),
            child: TextButton(
              onPressed: () {
                if (manager.selectFriendsList.length < 2) {
                  showToast('最少选择2名好友');
                } else {
                  Routers.navigateTo('/create_group_detail');
                }
              },
              child: Text(
                '下一步',
                style: Flavors.textStyles.newGroupNextBtnText,
              ),
            )),
      ]),
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          SearchBarView(),
          _tipsView(),
          SizedBox(
            height: 16.0.w,
          ),
          _contactsListView(),
        ],
      ),
    );
  }

  Widget _tipsView() {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 6.0),
      child: Text(
        '请至少选择两名好友作为群成员',
        style: Flavors.textStyles.loginSubTitleText,
      ),
    );
  }

  Widget _contactsListView() {
    return Selector<NewGroupsManager, List<Friends>>(
      builder: (BuildContext context, List<Friends> value, Widget? child) {
        print("DEBUG=> _FriendsView 重绘了。。。。。");
        return value.isNotEmpty
            ? CheckBoxContactsUsersItem(value, manager)
            : Container();
      },
      selector: (BuildContext context, NewGroupsManager newGroupsManager) {
        return newGroupsManager.friendsList;
      },
      shouldRebuild: (pre, next) =>
          ((pre != next) || (pre.length != next.length)),
    );
  }
}
