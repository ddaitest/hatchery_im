import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/common/widget/aboutAvatar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:hatchery_im/common/utils.dart';

class QRCodeCardPage extends StatefulWidget {
  final String? avatarUrl, nickName, account, userID;
  QRCodeCardPage({this.avatarUrl, this.nickName, this.account, this.userID});
  @override
  QRCodeCardState createState() => QRCodeCardState();
}

class QRCodeCardState extends State<QRCodeCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '二维码名片',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 17.0, color: Colors.black),
          ),
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          centerTitle: false,
          leading: IconButton(
              icon: Icon(Icons.chevron_left),
              iconSize: 30.0,
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              }),
          elevation: 0,
          backgroundColor: Colors.grey[200],
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: IconButton(
                icon: Icon(Icons.more_horiz),
                iconSize: 25.0,
                color: Colors.black,
                onPressed: () {},
              ),
            )
          ],
        ),
        body: _bodyContainer());
  }

  _bodyContainer() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Container(
          width: Flavors.sizesInfo.screenWidth - 60.0.w,
          height: Flavors.sizesInfo.screenHeight - 350.0.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((10.0)),
            color: Colors.white,
          ),
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      netWorkAvatar(widget.avatarUrl, 30.0),
                      Container(
                        width: 15.0.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                widget.nickName!,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                              ),
                            ],
                          ),
                          Text(
                            '账号：${widget.account}',
                            style: TextStyle(
                                fontSize: 12.0, color: Colors.grey[400]),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child:
                          qrImageModel(key: 'userID', value: widget.userID!)),
                ),
                Container(
                  child: Text(
                    '扫一扫上面的二维码图案，添加我为好友',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey[400]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
