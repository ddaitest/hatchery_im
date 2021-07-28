import 'dart:convert';
import 'package:hatchery_im/business/test/Model.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/config.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/api/engine/Protocols.dart';
import 'package:hatchery_im/common/Engine.dart';
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
  static String _token = '';
  var data = Map<String, dynamic>();

  // String to = "U202115215031100001";
  // String from = "U202114522384900001";
  String to = "U202114522384900001";
  String from = "U202115215031100001";

  static _checkToken() {
    _userInfoData = SP.getString(SPKey.userInfo);
    if (_userInfoData != null) {
      _token = jsonDecode(SP.getString(SPKey.userInfo))['token'];
    }
    return _token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test Socket")),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Text(_message),
          ElevatedButton(onPressed: hive1, child: Text("HIVE 1")),
          ElevatedButton(onPressed: hive2, child: Text("HIVE 2")),
          ElevatedButton(onPressed: hive3, child: Text("HIVE 3")),
          ElevatedButton(onPressed: test0, child: Text("INIT")),
          ElevatedButton(onPressed: test1, child: Text("CONNECT")),
          ElevatedButton(onPressed: test2, child: Text("SEND")),
          ElevatedButton(onPressed: test3, child: Text("SEND_请求认证消息")),
          ElevatedButton(onPressed: test4, child: Text("CLOSE")),
          ElevatedButton(
              onPressed: () => sendMessageModel("TEXT"),
              child: Text("SEND_TEXT")),
          ElevatedButton(
              onPressed: () => sendMessageModel("IMAGE"),
              child: Text("SEND_IMAGE")),
          ElevatedButton(
              onPressed: () => sendMessageModel("VIDEO"),
              child: Text("SEND_VIDEO")),
          ElevatedButton(
              onPressed: () => sendMessageModel("VOICE"),
              child: Text("SEND_VOICE")),
          ElevatedButton(
              onPressed: () => sendMessageModel("TEXT"), child: Text("SEND_5"))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    hive0();
  }

  Box? box;
  Box<TestMessage>? msgBox;

  hive0() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TestMsgAdapter());
    box = await Hive.openBox('testBox');
    msgBox = await Hive.openBox<TestMessage>('msgBox');
    print("box is ready!");
  }

  hive1() {
    DateTime nowTime = DateTime.now();
    var t = TestMessage("AAA $nowTime", nowTime.millisecond);
    msgBox?.add(t);
  }

  hive2() {
    DateTime nowTime = DateTime.now();
    print("before msgBox.length = ${msgBox?.length}");
    var t = TestMessage("BBB $nowTime", nowTime.millisecond);
    print("TestMessage = ${t.toString()};${t.key}");
    msgBox?.add(t);
    print("msgBox?.add(t)");
    print("after msgBox.length = ${msgBox?.length}");
    print("after TestMessage.key = ${t.key}");
    t.title = "XXX";
    t.save();
    print("t.save()");
    print("TestMessage = ${t.toString()};${t.key}");
    print("after msgBox.length = ${t.key}");
  }

  hive3() {
    print("${msgBox?.getAt(0)?.title}");
    print("${msgBox?.getAt(1)?.title}");
    print("${msgBox?.getAt(2)?.title}");
    print("${msgBox?.getAt(3)?.title}");
  }

  // save message
  // update message.
  // get message for one friend
  // get session.

  Engine engine = Engine.getInstance();

  test0() {
    engine.init('ws://149.129.176.107:5889/ws', "U202115215031100001");
  }

  test1() {
    print("test1");
    engine.connect();
  }

  test2() {
    var data = Map<String, dynamic>();
    data["msg_id"] = "10001";
    data["user_id"] = "U202115215031100001";
    data["type"] = "AUTH";
    data["token"] = _checkToken();
    data["source"] = "ANDROID";
    data["device_id"] = "device_id_123";
    data["login_ip"] = "1.2.3.4";
    engine.sendProtocol(data);
  }

  test3() {
    engine.sendProtocol(
        Protocols.auth("source", "userId", "token", "deviceId", "loginIp")
            .toJson());
  }

  test4() {
    engine.disconnect();
  }

  sendMessageModel(String messageType) {
    switch (messageType) {
      case "TEXT":
        data["msg_id"] = "10001";
        data["type"] = "CHAT";
        data["to"] = to;
        data["nick"] = "nick";
        data["from"] = from;
        data["icon"] = "icon";
        data["source"] = "ANDROID";
        data["content"] = textTest;
        data["content_type"] = messageType;
        engine.sendProtocol(data);
        break;
      case "IMAGE":
        data["msg_id"] = "10001";
        data["type"] = "CHAT";
        data["to"] = to;
        data["nick"] = "nick";
        data["from"] = from;
        data["icon"] = "icon";
        data["source"] = "ANDROID";
        data["content"] = imageTestUrl;
        data["content_type"] = messageType;
        engine.sendProtocol(data);
        break;
      case "VIDEO":
        data["msg_id"] = "10001";
        data["type"] = "CHAT";
        data["to"] = to;
        data["nick"] = "nick";
        data["from"] = from;
        data["icon"] = "icon";
        data["source"] = "ANDROID";
        data["content"] = videoTestUrl;
        data["content_type"] = messageType;
        engine.sendProtocol(data);
        break;
      case "VOICE":
        data["msg_id"] = "10001";
        data["type"] = "CHAT";
        data["to"] = to;
        data["nick"] = "nick";
        data["from"] = from;
        data["icon"] = "icon";
        data["source"] = "ANDROID";
        data["content"] = voiceTestUrl;
        data["content_type"] = messageType;
        engine.sendProtocol(data);
        break;
    }
  }
}
