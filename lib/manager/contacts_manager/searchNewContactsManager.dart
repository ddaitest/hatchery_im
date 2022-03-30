import 'package:flutter/foundation.dart';
import 'package:hatchery_im/api/API.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/entity.dart';

class SearchNewContactsManager extends ChangeNotifier {
  late final TextEditingController? _searchController = TextEditingController();
  bool _showSearchBtn = false;
  List<SearchNewContactsInfo> _searchNewContactsList = [];
  TextEditingController? get searchController => _searchController;
  bool get showSearchBtn => _showSearchBtn;
  List<SearchNewContactsInfo> get searchNewContactsList =>
      _searchNewContactsList;

  /// 初始化
  void init() {
    _checkSearchBtnListener();
  }

  void querySearchNewContactsData() async {
    _searchNewContactsList.clear();
    if (_searchController?.text != '') {
      API.searchNewContacts(_searchController!.text).then((value) {
        if (value.isSuccess()) {
          _searchNewContactsList =
              value.getDataList((m) => SearchNewContactsInfo.fromJson(m));
          print(
              'DEBUG=>  querySearchNewContactsData ${_searchNewContactsList}');
          notifyListeners();
        }
      });
    }
  }

  void _checkSearchBtnListener() {
    _searchController?.addListener(() {
      if (_searchController?.text != '') {
        _showSearchBtn = true;
      } else {
        _showSearchBtn = false;
      }

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }
}
