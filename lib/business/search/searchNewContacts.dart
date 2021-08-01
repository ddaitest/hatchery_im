import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/widget/contacts/ContactsUsersListItem.dart';
import 'package:hatchery_im/common/widget/search/search_bar.dart';
import 'package:hatchery_im/manager/searchNewContactsManager.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchNewContactsPage extends StatefulWidget {
  @override
  _SearchNewContactsPageState createState() => _SearchNewContactsPageState();
}

class _SearchNewContactsPageState extends State<SearchNewContactsPage> {
  final manager = App.manager<SearchNewContactsManager>();
  void initState() {
    manager.init();
    super.initState();
  }

  @override
  void dispose() {
    manager.searchController!.dispose();
    manager.searchNewContactsList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBarFactory.backButton('添加朋友'),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            // shrinkWrap: true,
            children: <Widget>[
              _topBarView(),
              _contactsListView(),
            ],
          ),
        ));
  }

  Widget _topBarView() {
    return Selector<SearchNewContactsManager, bool>(
      builder: (BuildContext context, bool value, Widget? child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: Flavors.sizesInfo.screenWidth - 70.0.w,
              child: SearchBarView(
                  searchHintText: "通过昵称/账号/手机号搜索朋友",
                  isEnabled: true,
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 0.0, top: 16.0, bottom: 16.0),
                  isAutofocus: false,
                  textEditingController: manager.searchController,
                  showPrefixIcon: value ? true : false),
            ),
            TextButton(
                onPressed: () {
                  !value
                      ? Navigator.of(context).pop(true)
                      : manager.querySearchNewContactsData();
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Text(!value ? '取消' : '搜索',
                    style: Flavors.textStyles.searchBtnText)),
          ],
        );
      },
      selector: (BuildContext context,
          SearchNewContactsManager searchNewContactsManager) {
        return searchNewContactsManager.showSearchBtn;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }

  _contactsListView() {
    return Selector<SearchNewContactsManager, List<SearchNewContactsInfo>>(
      builder: (BuildContext context, List<SearchNewContactsInfo> value,
          Widget? child) {
        print("DEBUG=> _FriendsView 重绘了。。。。。");
        return SearchContactsUsersList(value);
      },
      selector: (BuildContext context,
          SearchNewContactsManager searchNewContactsManager) {
        return searchNewContactsManager.searchNewContactsList;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.of(App.navState.currentContext!).pop(true);
    return true;
  }
}
