import 'dart:convert';

import 'package:flutter/material.dart';
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
          ElevatedButton(onPressed: test1, child: Text("connect")),
          ElevatedButton(onPressed: test2, child: Text("SEND")),
          ElevatedButton(onPressed: test3, child: Text("CLOSE")),
          ElevatedButton(onPressed: send1, child: Text("SEND_请求认证消息")),
          ElevatedButton(onPressed: send1, child: Text("SEND_1")),
          ElevatedButton(onPressed: send1, child: Text("SEND_2")),
          ElevatedButton(onPressed: send1, child: Text("SEND_3")),
          ElevatedButton(onPressed: send1, child: Text("SEND_4")),
          ElevatedButton(onPressed: send1, child: Text("SEND_5"))

        ],
      ),
    );
  }

  WebSocketChannel? _channel;

  test1() {
    print("test1");
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://149.129.176.107:5889/ws'),
      // Uri.parse('ws://106.12.147.150:5889/ws'),
      // Uri.parse('wss://echo.websocket.org'),
    );
    _channel?.stream.listen((message) {
      setState(() {
        _message = message;
      });
    });
  }

  test2() {
    _channel?.sink.add("HELLO 789");
  }

  test3() {
    _channel?.sink.close();
  }

  send1() {
    var data = Map();
    data["msg_id"] = "10001";
    data["user_id"] = "1";
    data["type"] = "AUTH";
    data["token"] = "1";
    data["source"] = "ANDROID";
    data["device_id"] = "device_id_123";
    data["login_ip"] = "1.2.3.4";
    _channel?.sink.add(jsonEncode(data).toString());
  }
}
