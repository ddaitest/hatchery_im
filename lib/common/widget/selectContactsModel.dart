import 'dart:convert';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/widget/contacts/checkBoxContactsUsersItem.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:hatchery_im/manager/contacts_manager/selectContactsModelManager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/widget/loading_Indicator.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/manager/userCentre.dart';

class SelectContactsModelPage extends StatefulWidget {
  final String groupId;
  final String titleText;
  final int leastSelected;
  final String nextPageBtnText;
  final String tipsText;
  final SelectContactsType selectContactsType;
  final List<GroupMembers>? groupMembersList;
  SelectContactsModelPage(
      {required this.groupId,
      required this.titleText,
      required this.leastSelected,
      required this.nextPageBtnText,
      required this.tipsText,
      required this.selectContactsType,
      this.groupMembersList});

  @override
  _SelectContactsModelState createState() => _SelectContactsModelState();
}

class _SelectContactsModelState extends State<SelectContactsModelPage> {
  final manager = App.manager<SelectContactsModelManager>();

  @override
  void initState() {
    if (widget.selectContactsType == SelectContactsType.DeleteGroupMember) {
      widget.groupMembersList
          ?.removeWhere((element) => element.userID == UserCentre.getUserID());
      manager.copyGroupMembersToList(widget.groupMembersList!);
    }
    manager.init(widget.selectContactsType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBarFactory.backButton('${widget.titleText}', actions: [
              Container(
                  padding: const EdgeInsets.all(6.0),
                  child: TextButton(
                    onPressed: () {
                      if (widget.selectContactsType ==
                              SelectContactsType.DeleteGroupMember
                          ? manager.selectGroupMembersList.length <
                              widget.leastSelected
                          : manager.selectFriendsList.length <
                              widget.leastSelected) {
                        showToast(
                            '最少选择${widget.leastSelected}${widget.selectContactsType == SelectContactsType.DeleteGroupMember ? '名群成员' : '名好友'}');
                      } else {
                        _submitBtnVoid(
                            widget.selectContactsType, widget.groupId);
                      }
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
                    textEditingController: manager.searchController,
                    isEnabled: true),
                manager.selectFriendsList.isNotEmpty ||
                        manager.selectGroupMembersList.isNotEmpty
                    ? _tipsView("已选择的群成员")
                    : Container(),
                Consumer(
                  builder: (BuildContext context,
                      SelectContactsModelManager selectContactsModelManager,
                      Widget? child) {
                    return _selectedContactsView(
                        selectContactsModelManager, widget.selectContactsType);
                  },
                ),
                SizedBox(
                  height: 10.0.w,
                ),
                _tipsView("${widget.tipsText}"),
                _contactsListView(),
              ],
            )));
  }

  Widget _selectedContactsView(
      selectContactsModelManager, SelectContactsType selectContactsType) {
    List<Widget> selectList = [];
    if (selectContactsType == SelectContactsType.DeleteGroupMember) {
      selectContactsModelManager.selectGroupMembersList.forEach((element) {
        selectList.add(_selectContactsItem(element.icon!));
      });
    } else {
      selectContactsModelManager.selectFriendsList.forEach((element) {
        selectList.add(_selectContactsItem(element.icon));
      });
    }
    return selectContactsModelManager.selectFriendsList.isNotEmpty |
            selectContactsModelManager.selectGroupMembersList.isNotEmpty
        ? Container(
            color: Flavors.colorInfo.mainBackGroundColor,
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

  Widget _contactsListView() {
    // print("DEBUG=> manager.friendsList! ${friendsList}");
    return Selector<SelectContactsModelManager, List<dynamic>?>(
        builder: (BuildContext context, List<dynamic>? value, Widget? child) {
          if (value != null) {
            if (value.isNotEmpty) {
              if (widget.selectContactsType ==
                  SelectContactsType.DeleteGroupMember) {
                return CheckBoxContactsUsersItem(
                    manager.friendsList ?? [],
                    value as List<GroupMembers>,
                    widget.selectContactsType,
                    manager);
              } else {
                return CheckBoxContactsUsersItem(
                    value as List<Friends>,
                    widget.groupMembersList,
                    widget.selectContactsType,
                    manager);
              }
            } else {
              return IndicatorView(tipsText: '没有群成员', showLoadingIcon: false);
            }
          } else {
            return IndicatorView();
          }
        },
        selector: (BuildContext context,
            SelectContactsModelManager selectContactsModelManager) {
          return widget.selectContactsType ==
                  SelectContactsType.DeleteGroupMember
              ? selectContactsModelManager.groupMembersList ?? null
              : selectContactsModelManager.friendsList ?? null;
        },
        shouldRebuild: (pre, next) => (pre != next));
  }

  ///提交并返回
  void _submitBtnVoid(SelectContactsType selectContactsType, String groupId) {
    if (selectContactsType == SelectContactsType.CreateGroup) {
      String? myNickName = UserCentre.getInfo()!.nickName ?? '';
      String groupName = '';
      String groupDescription = '';
      String groupNotes = '';
      String groupImageUrl = '';
      List<Friends> selectFriends = manager.selectFriendsList;
      List<String> friendsIdList = [];
      for (var i = 0; i < selectFriends.length; i++) {
        friendsIdList.add(selectFriends[i].friendId);
        if (i < 2) {
          groupName =
              '${selectFriends[i].nickName}${i != 1 ? '' : '、'}' + groupName;
        }
      }
      groupName = myNickName + '、' + groupName + '的群组';
      print("DEBUG=> groupName $groupName");
      print("DEBUG=> friendsIdList $friendsIdList");
      manager.submit(
          selectContactsType: selectContactsType,
          groupName: groupName,
          groupDescription: groupDescription,
          groupIcon: groupImageUrl,
          notes: groupNotes,
          members: friendsIdList);
    } else if (selectContactsType == SelectContactsType.AddGroupMember) {
      manager.submit(
          selectContactsType: selectContactsType,
          groupID: groupId,
          inviteJoinMembersInfo: null);
    } else if (selectContactsType == SelectContactsType.DeleteGroupMember) {
      List<Map<String, String>> _deleteMembersInfo = [];
      manager.selectGroupMembersList.forEach((element) {
        Map<String, String> _membersInfoMap = {
          'kcikUserID': '',
          'kcikUserNick': ''
        };
        _membersInfoMap['kcikUserID'] = element.userID!;
        _membersInfoMap['kcikUserNick'] = element.nickName!;
        _deleteMembersInfo.add(_membersInfoMap);
      });
      print("DEBUG=> _deleteMembersInfo $_deleteMembersInfo");
      manager.submit(
          selectContactsType: selectContactsType,
          groupID: groupId,
          deleteMembersInfo: _deleteMembersInfo);
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.of(App.navState.currentContext!).pop(true);
    return true;
  }

  @override
  void dispose() {
    manager.selectFriendsList.clear();
    manager.selectGroupMembersList.clear();
    manager.selectList.clear();
    manager.searchController.dispose();
    super.dispose();
  }
}
