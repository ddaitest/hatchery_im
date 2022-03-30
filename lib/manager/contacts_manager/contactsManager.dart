import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/api/entity.dart';

import '../app_manager/app_handler.dart';

class ContactsManager extends ChangeNotifier {
  final TextEditingController _searchController = TextEditingController();
  //联系人列表 数据
  List<Friends>? _friendsList;
  //未处理的好友申请
  int _untreatedReceiveContactsApplyLength = 0;
  List<Friends> _backupFriendsList = [];
  TextEditingController get searchController => _searchController;
  List<Friends>? get friendsList => _friendsList;
  List<Friends> get backupFriendsList => _backupFriendsList;
  int get untreatedReceiveContactsApplyLength =>
      _untreatedReceiveContactsApplyLength;
  static const size = 999; //暂时一次取完。

  /// 初始化
  init() {
    _queryFriendsRes();
    _receiveNewFriendsApplicationRes();
    _searchInputListener();
  }

  void _searchInputListener() {
    _searchController.addListener(() {
      String _inputText = _searchController.text;
      _friendsList = List.from(_backupFriendsList);
      if (_inputText.isNotEmpty) {
        _friendsList!
            .removeWhere((element) => !element.nickName.contains(_inputText));
        _friendsList!.removeWhere((element) =>
            element.remarks != null && !element.remarks!.contains(_inputText));
      } else {
        _friendsList = List.from(_backupFriendsList);
      }

      notifyListeners();
    });
  }

  ///刷新好友列表.
  /// Step1. 返回本地存储的数据。
  /// Step2. 从Server获取最新数据。
  /// Step3. 刷新本地数据。
  _queryFriendsRes({
    int size = 999,
    int current = 0,
  }) async {
    // Step1. 返回本地存储的数据。
    AppHandler.getFriends().then((value) {
      if (value.length > 0) {
        _friendsList = value;
        notifyListeners();
      }
    });
    // Step2. 从Server获取最新数据。
    API.getFriendsListData(size, current).then((value) {
      if (value.isSuccess()) {
        _friendsList = value.getDataList((m) => Friends.fromJson(m), type: 1);
        _backupFriendsList = List.from(_friendsList!);
        // Step3. 刷新本地数据。
        AppHandler.saveFriends(_friendsList);
        print('DEBUG=>  _queryFriendsRes ${_friendsList}');
        notifyListeners();
      }
    });
  }

  _receiveNewFriendsApplicationRes({
    int size = 999,
    int current = 0,
  }) async {
    API.getReceiveNewFriendsApplicationListData(size, current).then((value) {
      if (value.isSuccess()) {
        value.getDataList(
            (m) => m.forEach((key, value) {
                  if (key == 'status') {
                    if (value == 0) {
                      _untreatedReceiveContactsApplyLength =
                          _untreatedReceiveContactsApplyLength + 1;
                    }
                  }
                }),
            type: 1);
        notifyListeners();
      }
    });
  }

  void refreshData() {
    _searchController.clear();
    _untreatedReceiveContactsApplyLength = 0;
    FocusScope.of(App.navState.currentContext!).requestFocus(FocusNode());
    _queryFriendsRes();
    _receiveNewFriendsApplicationRes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _untreatedReceiveContactsApplyLength = 0;
    super.dispose();
  }
}
