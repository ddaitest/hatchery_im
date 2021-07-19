import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/manager/myProfileManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/manager/friendProfileManager.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/routers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FriendProfilePage extends StatefulWidget {
  final String friendId;
  FriendProfilePage(this.friendId);
  @override
  _FriendProfilePageState createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  final manager = App.manager<FriendProfileManager>();
  @override
  void initState() {
    manager.init(widget.friendId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarFactory.backButton('', actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 9.0),
            child: Icon(Icons.more_vert, size: 30, color: Colors.black),
          )
        ]),
        body: Container());
  }
}
