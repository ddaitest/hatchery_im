import 'dart:convert';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/config.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/engine/Protocols.dart';
import 'package:hatchery_im/common/Engine.dart';
import 'package:hatchery_im/manager/messageCentre.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TestPage extends StatefulWidget {
  @override
  TestState createState() => TestState();
}

class TestState extends State<TestPage> {
  String _message = "...";
  String textTest =
      "鲁迅（1881年9月25日～1936年10月19日），原名周樟寿，后改名周树人，字豫山，后改字豫才，浙江绍兴人。著名文学家、思想家、革命家、教育家 [179]  、民主战士，新文化运动的重要参与者，中国现代文学的奠基人之一。";
  String voiceTestUrl =
      'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3';
  String imageTestUrl =
      'https://img0.baidu.com/it/u=2407531684,1522315943&fm=11&fmt=auto&gp=0.jpg';
  String videoTestUrl =
      'https://vd4.bdstatic.com/mda-kfeejrf38q7chb72/hd/mda-kfeejrf38q7chb72.mp4';
  static String? _userInfoData;
  var data = Map<String, dynamic>();

  // String to = "U202115215031100001";
  // String from = "U202114522384900001";
  // sender: U202121622163000001
  // receiver: U202115215031100001
  String to = "U202121622163000001";
  String from = "U202115215031100001";

  var ts1 = TextStyle(color: Colors.red);
  var ts2 = TextStyle(color: Colors.white);

  TextEditingController _controllerUID1 =
      TextEditingController(text: "U202121622163000001");
  TextEditingController _controllerUID2 =
      TextEditingController(text: "U202115215031100001");
  TextEditingController _controllerContent =
      TextEditingController(text: "HELLO");

  @override
  void initState() {
    super.initState();
    MessageCentre().listenNewMessages((news) {
      setState(() {
        _message = "New = ${news.toString()}";
        Log.red(_message);
      });
    });
  }

  @override
  void dispose() {
    _controllerUID1.dispose();
    _controllerUID2.dispose();
    _controllerContent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test Socket")),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Text(_message),
          ElevatedButton(onPressed: c0, child: Text("User Info")),
          TextField(controller: _controllerUID1),
          TextField(controller: _controllerUID2),
          TextField(controller: _controllerContent),
          ElevatedButton(
              onPressed: test1, child: Text("SEND MSG 1", style: ts2)),
          ElevatedButton(
              onPressed: test2, child: Text("SEND MSG 2", style: ts2)),
          // ElevatedButton(onPressed: test2, child: Text("Sessions", style: ts2)),
          ElevatedButton(onPressed: test3, child: Text("CLOSE")),
          ValueListenableBuilder(
              valueListenable: LocalStore.listenMessage(),
              builder: (context, Box<Message> box, _) {
                String content = "<${box.values.length}>";
                box.values.forEach((element) {
                  content += "(${element.content})";
                });
                return Text(content);
              }),
          // ElevatedButton(
          //     onPressed: () => sendMessageModel("TEXT"),
          //     child: Text("SEND_TEXT")),
          // ElevatedButton(
          //     onPressed: () => sendMessageModel("IMAGE"),
          //     child: Text("SEND_IMAGE")),
          // ElevatedButton(
          //     onPressed: () => sendMessageModel("VIDEO"),
          //     child: Text("SEND_VIDEO")),
          // ElevatedButton(
          //     onPressed: () => sendMessageModel("VOICE"),
          //     child: Text("SEND_VOICE")),
          // ElevatedButton(
          //     onPressed: () => sendMessageModel("TEXT"), child: Text("SEND_5"))
        ],
      ),
    );
  }

  Box? box;

  MyProfile? _userInfo;
  String? _token;

  c0() async {
    setState(() {
      _userInfo = UserCentre.getInfo();
      _token = UserCentre.getToken();
      _message = "userID=${_userInfo?.userID}";
      Log.red("userID=${_userInfo?.userID};token=$_token");
    });
    // MessageCentre().listenMessage((news) { }, friendId)
  }

  // s0() async {
  //   MessageCentre.init();
  // }
  //
  // s1() async {
  //   print("sendAuth");
  //   MessageCentre.sendAuth();
  // }
  // sender: U202121622163000001
  // receiver: U202115215031100001
  test1() {
    print("sendTextMessage");
    MessageCentre.sendTextMessage("CHAT", _controllerContent.text,
        friendId: _controllerUID1.text);
  }

  test2() {
    print("sendTextMessage");
    MessageCentre.sendTextMessage("CHAT", _controllerContent.text,
        friendId: _controllerUID2.text);
  }

  test3() {
    MessageCentre.disconnect();
  }

  test4() {
    var centre = MessageCentre();
    var s = centre.sessions;
    print("sessions >> " + s.toString());
  }
}
