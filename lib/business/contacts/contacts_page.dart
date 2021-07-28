import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/widget/contacts/ContactsUsersListItem.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:hatchery_im/manager/contactsManager.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/business/contacts/contactsApplication.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hatchery_im/common/utils.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final manager = App.manager<ContactsManager>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void initState() {
    manager.init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    manager.refreshData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            SearchBarView(
                searchHintText: "搜索好友",
                textEditingController: manager.searchController,
                isEnabled: true),
            _addFriendsView(),
            dividerViewCommon(),
            _newFriendsApply(),
            _contactsListView(),
          ],
        ),
      ),
    );
  }

  Widget _addFriendsView() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
          onTap: () => Routers.navigateTo('/search_new_contacts')
              .then((value) => value ? manager.refreshData() : null),
          leading: CircleAvatar(
            backgroundColor: Colors.pink,
            maxRadius: 20,
            child: Center(
              child: Icon(
                Icons.person_add,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            '添加朋友',
            style: Flavors.textStyles.friendsText,
          ),
          trailing: Container(width: 30.0.w),
        ));
  }

  Widget _newFriendsApply() {
    return Selector<ContactsManager, List<FriendsApplicationInfo>>(
      builder: (BuildContext context, List<FriendsApplicationInfo> value,
          Widget? child) {
        return Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: ListTile(
              // onTap: () =>
              //     Routers.navigateTo("/contacts_application", arg: value),
              onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ContactsApplicationPage(value)))
                  .then((value) => value ? manager.refreshData() : null),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                maxRadius: 20,
                child: Center(
                  child: Icon(
                    Icons.contact_phone,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                '好友申请',
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
      selector: (BuildContext context, ContactsManager contactsManager) {
        return contactsManager.contactsApplicationList;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }

  Widget _contactsListView() {
    return Selector<ContactsManager, List<Friends>?>(
      builder: (BuildContext context, List<Friends>? value, Widget? child) {
        print("DEBUG=> _FriendsView 重绘了。。。。。");
        return Container(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
          child: GestureDetector(
            child: ContactsUsersList(value),
          ),
        );
      },
      selector: (BuildContext context, ContactsManager contactsManager) {
        return contactsManager.friendsList ?? null;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }
}
