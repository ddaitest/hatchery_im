import 'dart:convert';
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
import 'package:hatchery_im/manager/selectContactsModelManager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/widget/loading_Indicator.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/busniess/group_page/createNewGroupDetail.dart';

class SelectContactsModelPage extends StatefulWidget {
  final String titleText;
  final int leastSelected;
  final String nextPageBtnText;
  final String tipsText;
  final SelectContactsType selectContactsType;
  SelectContactsModelPage(
      {required this.titleText,
      required this.leastSelected,
      required this.nextPageBtnText,
      required this.tipsText,
      required this.selectContactsType});

  @override
  _SelectContactsModelState createState() => _SelectContactsModelState();
}

class _SelectContactsModelState extends State<SelectContactsModelPage> {
  final manager = App.manager<SelectContactsModelManager>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SelectContactsModelManager(),
        child: Consumer(
          builder: (BuildContext context,
              SelectContactsModelManager selectContactsModelManager,
              Widget? child) {
            return WillPopScope(
                onWillPop: _onWillPop,
                child: Scaffold(
                    appBar: AppBarFactory
                        .backButton('${widget.titleText}', actions: [
                      Container(
                          padding: const EdgeInsets.all(6.0),
                          child: TextButton(
                            onPressed: () {
                              selectContactsModelManager
                                          .selectFriendsList.length <
                                      widget.leastSelected
                                  ? showToast('最少选择${widget.leastSelected}名好友')
                                  : _submitBtn(selectContactsModelManager);
                            },
                            child: Text(
                              '${widget.nextPageBtnText}',
                              style: Flavors.textStyles.newGroupNextBtnText,
                            ),
                          )),
                    ]),
                    body: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        SearchBarView(
                            searchHintText: "搜索好友",
                            textEditingController:
                                selectContactsModelManager.searchController,
                            isEnabled: true),
                        selectContactsModelManager.selectFriendsList.isNotEmpty
                            ? _tipsView("已选择的好友")
                            : Container(),
                        _selectedContactsView(selectContactsModelManager),
                        SizedBox(
                          height: 10.0.w,
                        ),
                        _tipsView("${widget.tipsText}"),
                        _contactsListView(selectContactsModelManager),
                      ],
                    )));
          },
        ));
  }

  Widget _selectedContactsView(selectContactsModelManager) {
    List<Widget> selectList = [];
    selectContactsModelManager.selectFriendsList.forEach((element) {
      selectList.add(_selectContactsItem(element.icon));
    });
    return selectContactsModelManager.selectFriendsList.isNotEmpty
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

  Widget _contactsListView(selectContactsModelManager) {
    return selectContactsModelManager.friendsList != null
        ? CheckBoxContactsUsersItem(
            selectContactsModelManager.friendsList, selectContactsModelManager)
        : IndicatorView();
  }

  ///提交并返回
  void _submitBtn(selectContactsModelManager) {
    String myNickName = '';
    String? stored = SP.getString(SPKey.userInfo);
    if (stored != null) {
      try {
        var userInfo = MyProfile.fromJson(jsonDecode(stored)['info']);
        myNickName = userInfo.nickName;
        print("_myProfileData ${userInfo.nickName}");
      } catch (e) {}
      String groupName = '';
      String groupDescription = '';
      String groupNotes = '';
      String groupImageUrl = '';
      List<Friends> selectFriends =
          selectContactsModelManager.selectFriendsList;
      List<String> friendsId = [];
      for (var i = 0; i < selectFriends.length; i++) {
        friendsId.add(selectFriends[i].friendId);
        if (i < 2) {
          groupName =
              '${selectFriends[i].remarks ?? selectFriends[i].nickName}${i != 1 ? '' : '、'}' +
                  groupName;
        }
      }
      groupName = myNickName + ' ' + groupName + '的群组';

      if (widget.selectContactsType == SelectContactsType.Group) {
        print("DEBUG=> groupName $groupName");
        print("DEBUG=> friendsId $friendsId");
        selectContactsModelManager.submit(
            groupName, groupDescription, groupImageUrl, groupNotes, friendsId);
      } else if (widget.selectContactsType == SelectContactsType.Share) {}
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.of(App.navState.currentContext!).pop(true);
    return true;
  }

  @override
  void dispose() {
    manager.selectFriendsList.clear();
    manager.searchController.dispose();
    super.dispose();
  }
}
