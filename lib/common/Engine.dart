import 'dart:async';
import 'dart:convert';

import 'package:hatchery_im/api/engine/Protocols.dart';
import 'package:hatchery_im/api/engine/entity.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:crypto/crypto.dart';
import 'package:hatchery_im/manager/messageCentre.dart';
import 'package:hatchery_im/store/LocalStore.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class EngineCallback {
  void onNewMessage(Message msg) {}

  void onMessageSent(String localId, String serverId) {}

  void onMessageRead(String localId, String serverId) {}

  void onGroupCreated(SCGroupCreate data) {}

  void onGroupKick(SCGroupKick data) {}

  void onGroupJoin(SCGroupJoin data) {}

  void onGroupUpdate(SCGroupUpdate data) {}

  void onGroupRemove(SCGroupRemove data) {}

  void onFriendApply(SCFriendApply data) {}

  void onFriendResult(SCFriendResult data) {}

  void onKickOut(SCKickOut data) {}
}

class Engine {
  static Engine _instance = Engine._internal();

  Engine._internal();

  factory Engine.getInstance() => _instance;

  ///连接
  WebSocketChannel? _channel;

  ///服务器地址
  String _address = 'ws://119.23.74.10:5889/ws';
  String _userID = "";
  String _source = "";
  String _deviceId = "";
  String _ipAddress = "";

  Timer? heartBeat;
  int _life = 0;
  bool forceStop = false; // 标示 是否手动 断开连接
  int retryInterval = 1;

  ///初始化，设置服务器地址
  init(String server, String userId,
      {String? source, String? deviceId, String? ipAddress}) {
    _address = server;
    _userID = userId;
    _source = source ?? "";
    _deviceId = deviceId ?? "";
    _ipAddress = ipAddress ?? "";
  }

  MyEngineHandler? _callback;

  setCallback(MyEngineHandler callback) {
    _callback = callback;
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
    MessageCentre.sendAuth();
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

  /// 连接是否断开
  bool connectStatus() {
    if (_channel == null || heartBeat == null) {
      return false;
    } else {
      return true;
    }
  }

  _handleError(Object error, StackTrace trace) {
    Log.yellow("_handleError() error is $error");
  }

  _handleDone() {
    Log.yellow("_handleDone() !!!");
    _stopHeartBeat();
    if (!forceStop) {
      retryInterval = retryInterval + 10;
      Log.yellow("delay $retryInterval reconnect");
      Future.delayed(Duration(seconds: retryInterval), () {
        _reconnect();
      });
    }
  }

  _send(Map<String, dynamic> object) {
    String json = jsonEncode(object).toString();
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
    // Log.yellow("sendProtocol is $object");
    _send(object);
  }

  _handleData(message) {
    // var data = DispatchProtocol.parser(message);
    try {
      var json = jsonDecode(message);
      String type = json['type'];
      Types t = Types.values.firstWhere((e) => e.stringValue() == type);
      switch (t) {
        case Types.CHAT: //收到消息。
          Log.yellow("_handleData() CHAT is $json");
          _handleChat(CSSendMessage.fromJson(json));
          break;
        case Types.GROUP: //收到群聊消息。
          _handleGroupMessage(CSSendGroupMessage.fromJson(json));
          break;
        case Types.AUTH_RESULT:
          _handleAuthResult(SCAuthMessage.fromJson(json));
          break;
        case Types.SERVER_ACK: //收到 Server ack。 表示发消息成功。
          var scAck = SCAck.fromJson(json);
          Log.yellow("_handleData() SERVER_ACK is $json");
          _callback?.onMessageSent(scAck.ackMsgLocalId, scAck.ackMsgServerId);
          break;
        case Types.CHAT_ACK: //收到 Message ack。 表示已读。
          var ack = CSAckMessage.fromJson(json);
          Log.yellow("_handleData() CHAT_ACK is $json");
          _callback?.onMessageRead(ack.ackMsgId, ack.serverMsgId);
          break;
        case Types.GROUP_INIT:
          _callback?.onGroupCreated(SCGroupCreate.fromJson(json));
          break;
        case Types.GROUP_KICK:
          _callback?.onGroupKick(SCGroupKick.fromJson(json));
          break;
        case Types.GROUP_JOIN:
          _callback?.onGroupJoin(SCGroupJoin.fromJson(json));
          break;
        case Types.GROUP_UPDATE:
          _callback?.onGroupUpdate(SCGroupUpdate.fromJson(json));
          break;
        case Types.GROUP_REMOVE:
          _callback?.onGroupRemove(SCGroupRemove.fromJson(json));
          break;
        case Types.FRIEND_APPL:
          _callback?.onFriendApply(SCFriendApply.fromJson(json));
          break;
        case Types.FRIEND_RESULT:
          _callback?.onFriendResult(SCFriendResult.fromJson(json));
          break;
        case Types.OCCUPATION_LINE:
          _callback?.onKickOut(SCKickOut.fromJson(json));
          break;
        case Types.PONG:
          SCPong.fromJson(json);
          break;
        case Types.AUTH:
          // TODO: Handle this case.
          break;
        case Types.PING:
          // TODO: Handle this case.
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

  ///收到消息。
  void _handleChat(CSSendMessage msg) {
    Log.red("收到消息:${msg.toJson()}");
    sendProtocol(Protocols.ackMessage(
            msg.msgId, msg.to, msg.from, msg.serverMsgId, msg.source)
        .toJson());
    Message message = ModelHelper.convertMessage(msg);
    _callback?.onNewMessage(message);
  }

  ///收到群聊消息。
  void _handleGroupMessage(CSSendGroupMessage msg) {
    sendProtocol(Protocols.ackMessage(
            msg.msgId, msg.from, "", msg.serverMsgId, msg.source)
        .toJson());
    Message message = ModelHelper.convertGroupMessage(msg);
    _callback?.onNewMessage(message);
  }
}
