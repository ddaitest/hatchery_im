import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/widget/loading_view.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/contactsManager.dart';
import 'package:hatchery_im/manager/blockListManager.dart';
import 'package:hatchery_im/common/widget/loading_Indicator.dart';
import 'package:cool_alert/cool_alert.dart';

class ContactsUsersList extends StatelessWidget {
  final List<Friends>? friendsLists;
  ContactsUsersList(this.friendsLists);
  final manager = App.manager<ContactsManager>();

  @override
  Widget build(BuildContext context) {
    return friendsLists != null
        ? ListView.builder(
            itemCount: friendsLists != null ? friendsLists!.length : 8,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Routers.navigateTo('/friend_profile',
                          arg: friendsLists![index].friendId)
                      .then((value) =>
                          value ?? false ? manager.refreshData() : null);
                },
                child: Container(
                  color: Colors.white,
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      friendsLists!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: friendsLists![index].icon,
                              placeholder: (context, url) => CircleAvatar(
                                    backgroundImage:
                                        AssetImage('images/default_avatar.png'),
                                    maxRadius: 20,
                                  ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                    backgroundImage:
                                        AssetImage('images/default_avatar.png'),
                                    maxRadius: 20,
                                  ),
                              imageBuilder: (context, imageProvider) {
                                return CircleAvatar(
                                  backgroundImage: imageProvider,
                                  maxRadius: 20,
                                );
                              })
                          : CircleAvatar(
                              backgroundImage:
                                  AssetImage('images/default_avatar.png'),
                              maxRadius: 20,
                            ),
                      SizedBox(
                        width: 16.0.w,
                      ),
                      Container(
                        color: Colors.transparent,
                        width: Flavors.sizesInfo.screenWidth - 100.0.w,
                        child: friendsLists != null
                            ? Text(
                                friendsLists![index].remarks != null
                                    ? friendsLists![index].remarks!
                                    : friendsLists![index].nickName,
                                style: Flavors.textStyles.friendsText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)
                            : LoadingView(),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : IndicatorView();
  }
}

class SearchContactsUsersList extends StatelessWidget {
  final List<SearchNewContactsInfo> newContactsList;
  SearchContactsUsersList(this.newContactsList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newContactsList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            onTap: () => Routers.navigateTo('/friend_profile',
                arg: newContactsList[index].userID),
            dense: true,
            leading: CachedNetworkImage(
                imageUrl: newContactsList[index].icon,
                placeholder: (context, url) => CircleAvatar(
                      backgroundImage: AssetImage('images/default_avatar.png'),
                      maxRadius: 30,
                    ),
                errorWidget: (context, url, error) => CircleAvatar(
                      backgroundImage: AssetImage('images/default_avatar.png'),
                      maxRadius: 30,
                    ),
                imageBuilder: (context, imageProvider) {
                  return CircleAvatar(
                    backgroundImage: imageProvider,
                    maxRadius: 30,
                  );
                }),
            title: Container(
              color: Colors.transparent,
              child: Text(newContactsList[index].nickName,
                  style: Flavors.textStyles.searchContactsNameText,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            subtitle: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(newContactsList[index].notes ?? '这家伙很懒什么也没有写',
                  style: Flavors.textStyles.searchContactsNotesText,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            trailing: Container(
              width: 40.0.w,
              child: newContactsList[index].isFriends
                  ? Icon(Icons.change_circle_outlined,
                      color: Flavors.colorInfo.lightGrep)
                  : Container(),
            ),
          ),
        );
      },
    );
  }
}

class NewContactsUsersList extends StatelessWidget {
  final List<FriendsApplicationInfo>? contactsApplicationList;
  final Function? agreeBtnTap;
  final List<SlideActionInfo>? slideAction;
  final Function? denyResTap;
  NewContactsUsersList(
      {this.contactsApplicationList,
      this.agreeBtnTap,
      this.slideAction,
      this.denyResTap});

  @override
  Widget build(BuildContext context) {
    _addSlideAction();
    return ListView.builder(
      itemCount: contactsApplicationList!.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Slidable(
            actionPane: SlidableScrollActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions:
                slideAction!.map((e) => slideActionModel(e)).toList(),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: ListTile(
                dense: true,
                leading: CachedNetworkImage(
                    imageUrl: contactsApplicationList![index].icon,
                    placeholder: (context, url) => CircleAvatar(
                          backgroundImage:
                              AssetImage('images/default_avatar.png'),
                          maxRadius: 20,
                        ),
                    errorWidget: (context, url, error) => CircleAvatar(
                          backgroundImage:
                              AssetImage('images/default_avatar.png'),
                          maxRadius: 20,
                        ),
                    imageBuilder: (context, imageProvider) {
                      return CircleAvatar(
                        backgroundImage: imageProvider,
                        maxRadius: 20,
                      );
                    }),
                title: Container(
                  child: Text(contactsApplicationList![index].nickName,
                      style: Flavors.textStyles.searchContactsNameText,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                subtitle: Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                      contactsApplicationList![index].remarks ?? '对方什么都没有说',
                      style: Flavors.textStyles.searchContactsNotesText,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
                trailing: TextButton(
                  onPressed: () => agreeBtnTap,
                  child: Text('同意',
                      style: Flavors.textStyles.contactsApplicationAgreeText),
                ),
              ),
            ));
      },
    );
  }

  Widget slideActionModel(SlideActionInfo slideActionInfo) {
    return IconSlideAction(
      iconWidget: Container(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text('${slideActionInfo.label}',
              style: Flavors.textStyles.chatHomeSlideText)),
      color: slideActionInfo.iconColor,
      icon: slideActionInfo.icon,
      onTap: () => slideActionInfo.onTap,
    );
  }

  void _addSlideAction() {
    slideAction!.add(
      SlideActionInfo('拒绝', Icons.no_accounts, Colors.red, onTap: denyResTap),
    );
    // slideAction.add(
    //   SlideActionInfo('忽略', Icons.alarm_off, Flavors.colorInfo.mainColor,
    //       onTap: ignoreBtnTap),
    // );
  }
}

class BlockListItem extends StatelessWidget {
  final List<BlockList>? blockContactsList;
  BlockListItem(this.blockContactsList);
  final manager = App.manager<BlockListManager>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: blockContactsList != null ? blockContactsList!.length : 8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          color: Flavors.colorInfo.mainBackGroundColor,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: ListTile(
            dense: true,
            leading: CachedNetworkImage(
                imageUrl: blockContactsList![index].icon!,
                placeholder: (context, url) => CircleAvatar(
                      backgroundImage: AssetImage('images/default_avatar.png'),
                      maxRadius: 20,
                    ),
                errorWidget: (context, url, error) => CircleAvatar(
                      backgroundImage: AssetImage('images/default_avatar.png'),
                      maxRadius: 20,
                    ),
                imageBuilder: (context, imageProvider) {
                  return CircleAvatar(
                    backgroundImage: imageProvider,
                    maxRadius: 20,
                  );
                }),
            title: blockContactsList != null
                ? Container(
                    child: Text(blockContactsList![index].nickName!,
                        style: Flavors.textStyles.searchContactsNameText,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  )
                : LoadingView(),
            trailing: blockContactsList != null
                ? TextButton(
                    onPressed: () => _blockConfirmDialog(index),
                    child: Text('移出黑名单',
                        style: Flavors.textStyles.blockListDelBtnText),
                  )
                : Container(),
          ),
        );
      },
    );
  }

  _blockConfirmDialog(int index) {
    return CoolAlert.show(
      context: App.navState.currentContext!,
      type: CoolAlertType.info,
      showCancelBtn: true,
      cancelBtnText: '取消',
      confirmBtnText: '确认',
      confirmBtnColor: Flavors.colorInfo.mainColor,
      onConfirmBtnTap: () {
        Navigator.of(App.navState.currentContext!).pop(true);
        manager.delBlockFriend(blockContactsList![index].userID).then((value) {
          manager.refreshData();
        });
      },
      title: '确认移出黑名单?',
      text: "移出黑名单后可以收到对方的消息",
    );
  }
}
