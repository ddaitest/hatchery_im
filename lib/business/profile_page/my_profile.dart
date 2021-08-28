import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/manager/profile_manager/myProfile_manager/myProfileManager.dart';
import 'package:flutter/cupertino.dart';
import 'body.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/routers.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyProfileManager(),
      child: _bodyContainer(),
    );
  }

  _bodyContainer() {
    return Consumer(builder: (BuildContext context,
        MyProfileManager myProfileManager, Widget? child) {
      return Scaffold(
          appBar: buildAppBar(myProfileManager),
          body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ProfileBody(myProfileManager)));
    });
  }

  AppBar buildAppBar(myProfileManager) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Flavors.colorInfo.mainColor,
      brightness: Brightness.light,
      actions: <Widget>[
        TextButton(
          onPressed: () => Routers.navigateTo("/profile_edit")
              .then((value) => value ? myProfileManager.refreshData() : null),
          child: Text(
            "编辑",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16, //16
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
