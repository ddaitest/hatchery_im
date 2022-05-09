import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/widget/contacts/ContactsUsersListItem.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/manager/block_manager/blockListManager.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/widget/loading_Indicator.dart';

import '../../api/entity.dart';
import '../../common/log.dart';

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
    manager.blockContactsList?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.backButton('黑名单列表'),
      body: _contactsListView(),
    );
  }

  Widget _contactsListView() {
    return Selector<BlockListManager, List<BlockList>?>(
        builder: (BuildContext context, List<BlockList>? value, Widget? child) {
          Log.green("BlockList $value");
          if (value != null) {
            if (value.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                child: BlockListItem(value),
              );
            } else {
              return Center(
                child: IndicatorView(
                  tipsText: '没有被拉黑的联系人',
                  showLoadingIcon: false,
                ),
              );
            }
          } else {
            return Center(
                child: IndicatorView(
              showLoadingIcon: true,
            ));
          }
        },
        selector: (BuildContext context, BlockListManager blockListManager) {
          return blockListManager.blockContactsList;
        },
        shouldRebuild: (pre, next) => (pre != next));
  }
}
