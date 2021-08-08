import 'dart:async';
import 'dart:convert';

import 'package:hatchery_im/api/engine/Protocols.dart';
import 'package:hatchery_im/api/engine/entity.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef MessageListener = void Function(Message msg);
// typedef GroupMessageListener = void Function(CSSendGroupMessage msg);

class Engine {
  static Engine _instance = Engine._internal();

  Engine._internal();

  factory Engine.getInstance() => _instance;

  ///连接
  WebSocketChannel? _channel;

  ///服务器地址
  String _address = 'ws://149.129.176.107:5889/ws';
  String _userID = "";
  String _source = "";
  String _deviceId = "";
  String _ipAddress = "";

  Timer? heartBeat;
  int _life = 0;
  bool forceStop = false; // 标示 是否手动 断开连接

  ///初始化，设置服务器地址
  init(String server, String userId,
      {String? source, String? deviceId, String? ipAddress}) {
    _address = server;
    _userID = userId;
    _source = source ?? "";
    _deviceId = deviceId ?? "";
    _ipAddress = ipAddress ?? "";
  }

  MessageListener? _messageListener;

  setListeners(void onMsg(Message t)?) {
    _messageListener = onMsg;
  }

  ///连接
  connect() {
    Log.log("Engine.connect()$_address;_userID=$_userID");
    forceStop = false;
    if (_channel != null) {
      Log.log("connect() _channel is existed.");
      return;
    }
    _channel = WebSocketChannel.connect(Uri.parse(_address));
    _channel?.stream
        .listen(_handleData, onError: _handleError, onDone: _handleDone);
    Log.log("Engine.connect() finish");
    // _startHeartBeat();
  }

  _startHeartBeat() {
    Log.log("Engine._startHeartBeat");
    heartBeat?.cancel();
    heartBeat = null;
    heartBeat = Timer.periodic(Duration(seconds: 9), (timer) {
      _life++;
      Log.log("heartBeat>> $_life");
      var data = Protocols.ping(_source, _userID).toJson();
      _send(data);
    });
  }

  _stopHeartBeat() {
    Log.log("_stopHeartBeat");
    heartBeat?.cancel();
    heartBeat = null;
    _life = 0;
  }

  _handleError(Object error, StackTrace trace) {
    Log.yellow("_handleError() error is $error");
  }

  _handleDone() {
    Log.yellow("_handleDone() !!!");
    if (!forceStop) {
      _reconnect();
    }
  }

  _send(Map<String, dynamic> object) {
    String json = jsonEncode(object).toString();
    Log.log("_send $json");
    _channel?.sink.add(json);
  }

  _reconnect() {
    //ADD Delay
    _channel = null;
    connect();
  }

  disconnect() {
    forceStop = true;
    _channel?.sink.close();
    _channel = null;
    _stopHeartBeat();
  }

  sendProtocol(Map<String, dynamic> object) {
    _send(object);
  }

  _handleData(message) {
    Log.yellow("_handleData() message is $message");
    // var data = DispatchProtocol.parser(message);
    try {
      var json = jsonDecode(message);
      String type = json['type'];
      Types t = Types.values.firstWhere((e) => e.stringValue() == type);
      switch (t) {
        case Types.CHAT:
          _handleChat(CSSendMessage.fromJson(json));
          break;
        case Types.GROUP:
          _handleGroupMessage(CSSendGroupMessage.fromJson(json));
          break;
        case Types.AUTH_RESULT:
          _handleAuthResult(SCAuthMessage.fromJson(json));
          break;
        case Types.GROUP_INIT:
          SCGroupCreate.fromJson(json);
          break;
        case Types.GROUP_KICK:
          SCGroupKick.fromJson(json);
          break;
        case Types.GROUP_JOIN:
          SCGroupJoin.fromJson(json);
          break;
        case Types.GROUP_UPDATE:
          SCGroupUpdate.fromJson(json);
          break;
        case Types.GROUP_REMOVE:
          SCGroupRemove.fromJson(json);
          break;
        case Types.SERVER_ACK:
          SCAck.fromJson(json);
          break;
        case Types.FRIEND_APPL:
          SCFriendApply.fromJson(json);
          break;
        case Types.FRIEND_RESULT:
          SCFriendResult.fromJson(json);
          break;
        case Types.OCCUPATION_LINE:
          SCKickOut.fromJson(json);
          break;
        case Types.PONG:
          SCPong.fromJson(json);
          break;
      }
    } catch (e) {
      Log.red("DispatchProtocol.parser.error:$e :$message");
    }
  }

  _handleAuthResult(SCAuthMessage message) {
    if (message.code == "SUCCESS") {
      _startHeartBeat();
    }
  }

  void _handleChat(CSSendMessage msg) {
    Message message = Message(int.parse(msg.serverMsgId), msg.type, msg.msgId, msg.from, msg.nick, msg.to, msg.icon, msg.source, msg.content, msg.contentType, "100");
    _messageListener?.call(message);
  }

  void _handleGroupMessage(CSSendGroupMessage csSendGroupMessage) {}
}
