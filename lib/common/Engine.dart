import 'dart:async';
import 'dart:convert';

import 'package:hatchery_im/api/engine/Protocols.dart';
import 'package:hatchery_im/common/log.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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

  ///连接
  connect() {
    Log.log("connect()");
    forceStop = false;
    if (_channel != null) {
      Log.log("connect() _channel is existed.");
      return;
    }
    _channel = WebSocketChannel.connect(Uri.parse(_address));
    _channel?.stream
        .listen(_handleData, onError: _handleError, onDone: _handleDone);
    _startHeartBeat();
  }

  _startHeartBeat() {
    Log.log("_startHeartBeat");
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

  _handleData(message) {
    Log.yellow("_handleData() message is $message");
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
  }

  sendProtocol(Map<String, dynamic> object) {
    _send(object);
  }
}
