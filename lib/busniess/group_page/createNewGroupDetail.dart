import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/manager/newGroupsManager.dart';
import 'package:hatchery_im/common/widget/login_page/textForm_model.dart';
import 'package:hatchery_im/routers.dart';

class NewGroupDetailPage extends StatelessWidget {
  final manager = App.manager<NewGroupsManager>();
  final List<Friends> selectedFriends;
  NewGroupDetailPage(this.selectedFriends);

  @override
  Widget build(BuildContext context) {
    return _bodyContainer();
  }

  _bodyContainer() {
    return Scaffold(
        appBar: AppBarFactory.backButton('填写群资料', actions: [
          Container(
              padding: const EdgeInsets.all(6.0),
              child: TextButton(
                onPressed: () => _submitBtn(),
                child: Text(
                  '完成',
                  style: Flavors.textStyles.newGroupNextBtnText,
                ),
              )),
        ]),
        body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20.0.h),
                _avatarView(),
                SizedBox(height: 10.0.h),
                Text('添加照片',
                    style: Flavors.textStyles.newGroupSettingTitleText),
                SizedBox(height: 20.0.h),
                _buildGroupNameTF(),
                SizedBox(height: 20.0.h),
                _buildGroupDescriptionTF(),
                SizedBox(height: 30.0.h),
                _notificationSwitchView(),
              ],
            ),
          ),
        ));
  }

  Widget _buildGroupNameTF() {
    return TextFormNormalModel(
      '',
      manager.groupNameController,
      TextInputType.text,
      Icons.group,
      '请输入群名称',
    );
  }

  Widget _buildGroupDescriptionTF() {
    return TextFormNormalModel(
      '',
      manager.groupDescriptionController,
      TextInputType.text,
      Icons.event_note_sharp,
      '请输入群介绍',
    );
  }

  Widget _avatarView() {
    return Selector<NewGroupsManager, String>(
      builder: (context, String value, child) {
        print("DEBUG=> imageUrl $value");
        return GestureDetector(
          onTap: () => _showSheetMenu(context),
          child: Container(
            child: value == ''
                ? _selectIconView()
                : CachedNetworkImage(
                    imageUrl: value,
                    placeholder: (context, url) => _selectIconView(),
                    imageBuilder: (context, imageProvider) {
                      return CircleAvatar(
                        backgroundImage: imageProvider,
                        maxRadius: 40,
                      );
                    }),
          ),
        );
      },
      selector: (BuildContext context, NewGroupsManager manager) {
        return manager.groupAvatarUrl;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }

  Widget _selectIconView() {
    return CircleAvatar(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Center(
            child: Icon(
          Icons.photo_camera,
          color: Flavors.colorInfo.mainColor,
          size: 35,
        )),
      ),
      maxRadius: 40,
    );
  }

  Widget _notificationSwitchView() {
    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      height: 50.0.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('群通知开关', style: Flavors.textStyles.newGroupSettingTitleText),
          Switch(
            value: true,
            activeColor: Flavors.colorInfo.mainColor,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  _showSheetMenu(BuildContext context) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('选择图片'),
        actions: <Widget>[
          CupertinoActionSheetAction(
              child: const Text('相册'),
              onPressed: () => Navigator.pop(context, 'Gallery')),
          CupertinoActionSheetAction(
              child: const Text('照相机'),
              onPressed: () => Navigator.pop(context, 'Camera')),
        ],
        cancelButton: CupertinoActionSheetAction(
            child: const Text('取消'),
            // isDefaultAction: true,
            onPressed: () => Navigator.pop(context)),
      ),
    ).then((String? value) {
      if (value != null) {
        getImageBy(value);
      }
    });
  }

  Future getImageBy(String type) async {
    var s = ImageSource.camera;
    File imageFile = File('');
    if (type == "Gallery") {
      s = ImageSource.gallery;
    }
    final pickedFile = await ImagePicker().getImage(source: s);
    if (pickedFile == null) {
      return null;
    }
    imageFile = File(pickedFile.path);
    print("DDAI _image.lengthSync=${imageFile.lengthSync()}");
    if (imageFile.lengthSync() > 2080000) {
      compressionImage(imageFile.path).then((value) {
        _uploadImage(imageFile.path);
      });
    } else {
      _uploadImage(imageFile.path);
    }
  }

  ///上传图片
  _uploadImage(String filePath) {
    App.manager<NewGroupsManager>()
        .uploadImage(filePath)
        .then((value) => showToast(value ? '头像上传成功' : "头像上传失败"));
  }

  ///提交
  _submitBtn() {
    String groupName = manager.groupNameController.text;
    String groupDescription = manager.groupDescriptionController.text;
    String groupNotes = manager.groupNotesController.text;
    String grouopImageUrl = manager.groupAvatarUrl;
    List<String> friendsId = [];
    print("DEBUG=> manager.selectFriendsList ${selectedFriends}");
    selectedFriends.forEach((element) {
      friendsId.add(element.friendId);
    });
    print('${groupName}');
    print('${groupDescription}');
    print('${groupNotes}');
    print('${grouopImageUrl}');
    print('${selectedFriends}');
    if (groupName != '' || manager.selectFriendsList.length < 2) {
      manager.submit(
          groupName, groupDescription, grouopImageUrl, groupNotes, friendsId);
    } else {
      showToast('群名称或群成员不能为空', showGravity: ToastGravity.BOTTOM);
    }
  }
}
