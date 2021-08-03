import 'package:hatchery_im/api/entity.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/common/widget/loading_view.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/contactsManager.dart';
import 'package:hatchery_im/manager/contactsApplicationManager.dart';
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

class ReceiveContactsUsersList extends StatelessWidget {
  final List<FriendsApplicationInfo>? contactsApplicationList;
  ReceiveContactsUsersList({this.contactsApplicationList});

  final manager = App.manager<ContactsApplyManager>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contactsApplicationList!.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Slidable(
            actionPane: SlidableScrollActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions: contactsApplicationList![index].status == 0
                ? <Widget>[
                    IconSlideAction(
                      caption: '拒绝',
                      color: Colors.redAccent,
                      icon: Icons.no_accounts,
                      onTap: () => manager.replyNewContactsResTap(
                          contactsApplicationList![index].friendId, -1),
                    ),
                  ]
                : null,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(5.0),
              child: ListTile(
                onTap: () => Routers.navigateTo('/friend_profile',
                    arg: contactsApplicationList![index].friendId),
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
                trailing: contactsApplicationList![index].status == 0
                    ? TextButton(
                        onPressed: () => manager.replyNewContactsResTap(
                            contactsApplicationList![index].friendId, 1),
                        child: Container(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                              receiveContactsApplyStatusText(
                                  contactsApplicationList![index].status),
                              style: Flavors
                                  .textStyles.contactsApplicationAgreeText),
                        ),
                      )
                    : Text(
                        receiveContactsApplyStatusText(
                            contactsApplicationList![index].status),
                        style: Flavors.textStyles.contactsApplyStatusText),
              ),
            ));
      },
    );
  }
}

class SendContactsUsersList extends StatelessWidget {
  final List<FriendsApplicationInfo>? contactsApplicationList;
  SendContactsUsersList({this.contactsApplicationList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contactsApplicationList!.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(5.0),
          child: ListTile(
            dense: true,
            onTap: () => Routers.navigateTo('/friend_profile',
                arg: contactsApplicationList![index].friendId),
            leading: CachedNetworkImage(
                imageUrl: contactsApplicationList![index].icon,
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
            title: Container(
              child: Text(contactsApplicationList![index].nickName,
                  style: Flavors.textStyles.searchContactsNameText,
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            subtitle: Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(contactsApplicationList![index].remarks ?? '没有发送申请理由',
                  style: Flavors.textStyles.searchContactsNotesText,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
            trailing: Text(
                sendContactsApplyStatusText(
                    contactsApplicationList![index].status),
                style: Flavors.textStyles.contactsApplyStatusText),
          ),
        );
      },
    );
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
