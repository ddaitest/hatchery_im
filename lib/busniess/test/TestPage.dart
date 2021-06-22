import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hatchery_im/api/engine/Protocols.dart';
import 'package:hatchery_im/common/Engine.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TestPage extends StatefulWidget {
  @override
  TestState createState() => TestState();
}

class TestState extends State<TestPage> {
  String _message = "...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test Socket")),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Text(_message),
          ElevatedButton(onPressed: test0, child: Text("INIT")),
          ElevatedButton(onPressed: test1, child: Text("CONNECT")),
          ElevatedButton(onPressed: test2, child: Text("SEND")),
          ElevatedButton(onPressed: test3, child: Text("SEND_请求认证消息")),
          ElevatedButton(onPressed: test4, child: Text("CLOSE")),
          ElevatedButton(onPressed: send1, child: Text("SEND_1")),
          ElevatedButton(onPressed: send1, child: Text("SEND_2")),
          ElevatedButton(onPressed: send1, child: Text("SEND_3")),
          ElevatedButton(onPressed: send1, child: Text("SEND_4")),
          ElevatedButton(onPressed: send1, child: Text("SEND_5"))
        ],
      ),
    );
  }

  Engine engine = Engine.getInstance();

  test0() {
    engine.init('ws://149.129.176.107:5889/ws', "userId");
  }

  test1() {
    print("test1");
    engine.connect();
  }

  test2() {
    var data = Map<String, dynamic>();
    data["msg_id"] = "10001";
    data["user_id"] = "1";
    data["type"] = "AUTH";
    data["token"] = "1";
    data["source"] = "ANDROID";
    data["device_id"] = "device_id_123";
    data["login_ip"] = "1.2.3.4";
    engine.sendProtocol(data);
  }

  test3() {
    //发送认证
    engine.sendProtocol(
        Protocols.auth("source", "userId", "token", "deviceId", "loginIp")
            .toJson());
    //发送 消息
    engine.sendProtocol(
        Protocols.sendMessage("from", "nick", "to", "icon", "source", "content", "contentType")
            .toJson());
  }

  test4() {
    engine.disconnect();
  }

  send1(){

  }
}
