import 'dart:convert';

import 'package:hatchery_im/api/engine/entity.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Protocols {
  static int _timestamp = DateTime.now().millisecond;
  static int flag = 0;

  static getMsgID() {
    flag++;
    return "${_timestamp}_$flag";
  }

  ///心跳发送消息（C-->S）
  static CSPing ping(String source, String userId) =>
      CSPing(getMsgID(), Types.PING.toString(), source, userId);

  ///请求认证消息（C--->S）
  static CSAuthMessage auth(String source, String userId, String token,
          String deviceId, String loginIp) =>
      CSAuthMessage(getMsgID(), userId, Types.AUTH.toString(), token, source,
          deviceId, loginIp);

  ///单聊消息（C-->S）
  static CSSendMessage sendMessage(String from, String nick, String to,
          String icon, String source, String content, String contentType) =>
      CSSendMessage(getMsgID(), Types.CHAT.toString(), "", from, nick, to, icon,
          source, content, contentType);

  ///群聊消息（C-->S）
  static CSSendGroupMessage sendGroupMessage(
          String from,
          String nick,
          String groupId,
          String groupName,
          String icon,
          String source,
          String content,
          String contentType) =>
      CSSendGroupMessage(getMsgID(), Types.GROUP.toString(), "", from, nick,
          groupId, groupName, icon, source, content, contentType);

  ///单聊客户端ACK消息（C-->S）
  static ackMessage(String ackMsgId, String from, String to, String serverMsgId,
          String source) =>
      CSAckMessage(getMsgID(), ackMsgId, Types.CHAT_ACK.toString(), from, to,
          serverMsgId, source);
}

class DispatchProtocol {
  static parser(data) {
    if (data is String) {
      try {
        var json = jsonDecode(data);
        String type = json['type'];
        Types t = Types.values.firstWhere((e) => e.toString() == type);
        switch (t) {
          case Types.AUTH_RESULT:
            return SCAuthMessage.fromJson(json);
          case Types.GROUP_INIT:
            return SCGroupCreate.fromJson(json);
          case Types.GROUP_KICK:
            return SCGroupKick.fromJson(json);
          case Types.GROUP_JOIN:
            return SCGroupJoin.fromJson(json);
          case Types.GROUP_UPDATE:
            return SCGroupUpdate.fromJson(json);
          case Types.GROUP_REMOVE:
            return SCGroupRemove.fromJson(json);
          case Types.SERVER_ACK:
            return SCAck.fromJson(json);
          case Types.FRIEND_APPL:
            return SCFriendApply.fromJson(json);
          case Types.FRIEND_RESULT:
            return SCFriendResult.fromJson(json);
          case Types.OCCUPATION_LINE:
            return SCKickOut.fromJson(json);
          case Types.PONG:
            return SCPong.fromJson(json);
        }
      } catch (e) {}
    }
  }
}

enum Types {
  AUTH,
  AUTH_RESULT,
  CHAT,
  GROUP,
  CHAT_ACK,
  GROUP_INIT,
  GROUP_KICK,
  GROUP_JOIN,
  GROUP_UPDATE,
  GROUP_REMOVE,
  SERVER_ACK,
  FRIEND_APPL,
  FRIEND_RESULT,
  OCCUPATION_LINE,
  PING,
  PONG
}
