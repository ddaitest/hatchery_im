import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/utils.dart';

class BlockListManager extends ChangeNotifier {
  //拉黑列表
  List<BlockList>? blockContactsList;

  /// 初始化
  init() {
    _queryBlockListRes();
  }

  _queryBlockListRes({
    int size = 999,
    int current = 0,
  }) async {
    API.getBlockList(size, current).then((value) {
      print("DEBUG=> $value");
      if (value.isSuccess()) {
        blockContactsList =
            value.getDataList((m) => BlockList.fromJson(m), type: 1);

        notifyListeners();
      }
    });
  }

  Future<dynamic> delBlockFriend(String userID) async {
    List<String> blackUserIds = [];
    blackUserIds.add(userID);
    ApiResult result = await API.delBlockFriend(blackUserIds);
    if (result.isSuccess()) {
      showToast('已解除拉黑');
    } else {
      showToast('${result.info}');
    }
  }

  void refreshData() {
    _queryBlockListRes();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
