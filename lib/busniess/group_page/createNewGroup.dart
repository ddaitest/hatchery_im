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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/routers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewGroupPage extends StatefulWidget {
  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroupPage> {
  final manager = App.manager<NewGroupsManager>();

  @override
  void dispose() {
    manager.groupAvatarUrl = '';
    manager.uploadProgress = 0.0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NewGroupsManager(),
        child: Consumer(
          builder: (BuildContext context, NewGroupsManager newGroupsManager,
              Widget? child) {
            return WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                    appBar: AppBarFactory.backButton('创建群组', actions: [
                      Container(
                          padding: const EdgeInsets.all(6.0),
                          child: TextButton(
                            onPressed: () {
                              if (newGroupsManager.selectFriendsList.length <
                                  2) {
                                showToast('最少选择2名好友');
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => NewGroupDetailPage(
                                            newGroupsManager
                                                .selectFriendsList)));
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
                        SearchBarView(isEnabled: true),
                        newGroupsManager.selectFriendsList.isNotEmpty
                            ? _tipsView("已选择的好友")
                            : Container(),
                        _selectedContactsView(newGroupsManager),
                        SizedBox(
                          height: 10.0.w,
                        ),
                        _tipsView("请至少选择两名好友作为群成员"),
                        _contactsListView(newGroupsManager),
                      ],
                    )));
          },
        ));
  }

  Widget _selectedContactsView(newGroupsManager) {
    List<Widget> selectList = [];
    newGroupsManager.selectFriendsList.forEach((element) {
      selectList.add(_selectContactsItem(element.icon));
    });
    return newGroupsManager.selectFriendsList.isNotEmpty
        ? Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 10, //主轴上子控件的间距
              runSpacing: 5, //交叉轴上子控件之间的间距
              children: selectList, //要显示的子控件集合
            ),
          )
        : Container();
  }

  Widget _selectContactsItem(String imageUrl) {
    return Container(
      child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => CircleAvatar(
                backgroundImage: AssetImage('images/default_avatar.png'),
                maxRadius: 15,
              ),
          errorWidget: (context, url, error) => CircleAvatar(
                backgroundImage: AssetImage('images/default_avatar.png'),
                maxRadius: 15,
              ),
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(
              backgroundImage: imageProvider,
              maxRadius: 15,
            );
          }),
    );
  }

  Widget _tipsView(String text) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 6.0, bottom: 6.0),
      child: Text(
        '$text',
        style: Flavors.textStyles.loginSubTitleText,
      ),
    );
  }

  Widget _contactsListView(newGroupsManager) {
    return newGroupsManager.friendsList.isNotEmpty
        ? CheckBoxContactsUsersItem(
            newGroupsManager.friendsList, newGroupsManager)
        : Container();
  }

  Future<bool> _onWillPop() async {
    Navigator.of(App.navState.currentContext!).pop(true);
    return true;
  }
}
