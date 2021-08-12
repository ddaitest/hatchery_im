import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/widget/contacts/ContactsUsersListItem.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/manager/block_manager/blockListManager.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/widget/loading_Indicator.dart';

class BlockListPage extends StatefulWidget {
  @override
  _BlockListPageState createState() => _BlockListPageState();
}

class _BlockListPageState extends State<BlockListPage> {
  final manager = App.manager<BlockListManager>();
  @override
  void initState() {
    manager.init();
    super.initState();
  }

  @override
  void dispose() {
    manager.blockContactsList = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context,
        BlockListManager blockListManager, Widget? child) {
      return Scaffold(
        appBar: AppBarFactory.backButton('黑名单列表'),
        body: _contactsListView(blockListManager),
      );
    });
  }

  Widget _contactsListView(blockListManager) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: blockListManager.blockContactsList != null
          ? blockListManager.blockContactsList.length != 0
              ? BlockListItem(blockListManager.blockContactsList)
              : IndicatorView(
                  tipsText: '没有被拉黑的联系人',
                  showLoadingIcon: false,
                )
          : IndicatorView(),
    );
  }
}
