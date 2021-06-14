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
    data["token"] =
        "F65E6D12A9E36E624D847EC0F5B64E8ED4CBE5AEB962C0902BA9DCFD6A00561BDEC8847F6ED8E68D8675AE5D21C1FA7FE2D9792C5741180B18A47D2F235B6ADCD201F2482807825D2B569421AAD22D5656439FABBF3C1F68199B6566AF5DB5A75D7AA044668AA66911ABEC56C00E13DDDA9E02B9F445ABBFD32162A0CC06B05D53AFD686189DECDC6163D0519E9393BE91A583399B13E73A50DD827C710E0AA085423B18D87854E6932433F33943EB20C2B9A341F3E2D1480693D72901EDBE54AA5A5822F08E4D3BD09D78B00A19DF7831E888B1DD9CFFE4A0F947F57A973C816595F6FB5678FE379AB49099D106E7B0923BC8079C8B809CDCD6D9F76BB0EC5200A3E7EFA502C3BB0D1D7CA9952BA614";
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

  send1() {
    var data = Map<String, dynamic>();
    data["msg_id"] = "10001";
    data["type"] = "CHAT";
    data["to"] = "U202114522384900001";
    data["nick"] = "nick";
    data["frome"] = "U202115215031100001";
    data["icon"] = "icon";
    data["source"] = "ANDROID";
    data["content"] = "DDDDDDDDDDDDDDDDDD";
    data["content_type"] = "TEXT";
    engine.sendProtocol(data);
  }
}
