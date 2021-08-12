// import 'dart:async';
// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:hatchery_im/api/ApiResult.dart';
// import 'package:hatchery_im/api/API.dart';
// import 'package:flutter/material.dart';
// import 'package:hatchery_im/routers.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hatchery_im/api/entity.dart';
// import 'package:hatchery_im/common/utils.dart';
// import 'package:hatchery_im/common/tools.dart';
// import 'package:hatchery_im/common/AppContext.dart';
// import 'package:hatchery_im/busniess/main_tab.dart';
// import 'package:hatchery_im/flavors/Flavors.dart';
// import 'package:flutter/services.dart';
// import 'package:hatchery_im/config.dart';
// // import 'package:hatchery_im/common/backgroundListenModel.dart';
// import '../config.dart';
//
// class NewGroupsManager extends ChangeNotifier {
//   String groupAvatarUrl = '';
//   double uploadProgress = 0.0;
//   TextEditingController groupNameController = TextEditingController();
//   TextEditingController groupNotesController = TextEditingController();
//   TextEditingController groupDescriptionController = TextEditingController();
//   //联系人列表 数据
//   List<Friends> friendsList = [];
//   List<Friends> selectFriendsList = [];
//
//   /// 初始化
//   init() {
//     _queryFriendsRes();
//   }
//
//   NewGroupsManager() {
//     init();
//   }
//
//   _queryFriendsRes({
//     int size = 999,
//     int page = 0,
//   }) async {
//     API.getFriendsListData(size, page).then((value) {
//       if (value.isSuccess()) {
//         friendsList = value.getDataList((m) => Friends.fromJson(m), type: 1);
//         // print('DEBUG=>  _queryFriendsRes ${friendsList[0].nickName}');
//         notifyListeners();
//       }
//     });
//   }
//
//   Future<bool> uploadImage(String filePath) async {
//     ApiResult result = await compressionImage(filePath)
//         .then((value) => ApiForFileService.uploadFile(value, (count, total) {
//               uploadProgress = count.toDouble() / total.toDouble();
//               print("DEBUG=> uploadProgress = $uploadProgress");
//               notifyListeners();
//             }));
//     if (result.isSuccess()) {
//       final url = result.getData();
//       if (url is String) {
//         groupAvatarUrl = url;
//         print("DEBUG=> uploadUrl = ${groupAvatarUrl}");
//         uploadProgress = 0.0;
//         notifyListeners();
//       }
//     }
//     return result.isSuccess();
//   }
//
//   // Future<bool> submit(
//   //   String groupName,
//   //   String groupDescription,
//   //   String groupIcon,
//   //   String notes,
//   //   List<dynamic> members,
//   // ) async {
//   //   ApiResult result = await API.createNewGroup(
//   //       groupName, groupDescription, groupIcon, notes, members);
//   //   if (result.isSuccess()) {
//   //     print("DEBUG=> result.getData() ${result.getData()}");
//   //     showToast('创建群组成功');
//   //     groupAvatarUrl = '';
//   //     Navigator.of(App.navState.currentContext!).pop(true);
//   //     Navigator.of(App.navState.currentContext!).pop(true);
//   //   } else {
//   //     showToast('创建群组失败');
//   //   }
//   //   return result.isSuccess();
//   // }
//
//   void addSelectedFriendsIntoList(Friends friends) {
//     selectFriendsList.add(friends);
//     notifyListeners();
//   }
//
//   void removeSelectedFriendsIntoList(Friends friends) {
//     selectFriendsList.remove(friends);
//     notifyListeners();
//   }
//
//   @override
//   void dispose() {
//     selectFriendsList.clear();
//     groupNameController.dispose();
//     groupNotesController.dispose();
//     groupDescriptionController.dispose();
//     super.dispose();
//   }
// }
