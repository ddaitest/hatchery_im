// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CSAuthMessage _$CSAuthMessageFromJson(Map<String, dynamic> json) {
  return CSAuthMessage(
    json['msg_id'] as String,
    json['user_id'] as String,
    json['type'] as String,
    json['token'] as String,
    json['source'] as String,
    json['device_id'] as String,
    json['login_ip'] as String,
  );
}

Map<String, dynamic> _$CSAuthMessageToJson(CSAuthMessage instance) =>
    <String, dynamic>{
      'msg_id': instance.msgId,
      'user_id': instance.userId,
      'type': instance.type,
      'token': instance.token,
      'source': instance.source,
      'device_id': instance.deviceId,
      'login_ip': instance.loginIp,
    };

SCAuthMessage _$SCAuthMessageFromJson(Map<String, dynamic> json) {
  return SCAuthMessage(
    json['msg_id'] as String,
    json['user_id'] as String,
    json['type'] as String,
    json['code'] as String,
    json['message'] as String,
    json['ack_msg_id'] as String,
  );
}

Map<String, dynamic> _$SCAuthMessageToJson(SCAuthMessage instance) =>
    <String, dynamic>{
      'msg_id': instance.msgId,
      'user_id': instance.userId,
      'type': instance.type,
      'code': instance.code,
      'message': instance.message,
      'ack_msg_id': instance.ackMsgId,
    };

CSSendMessage _$CSSendMessageFromJson(Map<String, dynamic> json) {
  return CSSendMessage(
    json['msg_id'] as String,
    json['type'] as String,
    json['s_msg_id'] as String,
    json['from'] as String,
    json['nick'] as String,
    json['to'] as String,
    json['icon'] as String,
    json['source'] as String,
    json['content'] as String,
    json['content_type'] as String,
  );
}

Map<String, dynamic> _$CSSendMessageToJson(CSSendMessage instance) =>
    <String, dynamic>{
      'msg_id': instance.msgId,
      'type': instance.type,
      's_msg_id': instance.serverMsgId,
      'from': instance.from,
      'nick': instance.nick,
      'to': instance.to,
      'icon': instance.icon,
      'source': instance.source,
      'content': instance.content,
      'content_type': instance.contentType,
    };

CSAckMessage _$CSAckMessageFromJson(Map<String, dynamic> json) {
  return CSAckMessage(
    json['msg_id'] as String,
    json['ack_msg_id'] as String,
    json['type'] as String,
    json['from'] as String,
    json['to'] as String,
    json['s_msg_id'] as String,
    json['source'] as String,
  );
}

Map<String, dynamic> _$CSAckMessageToJson(CSAckMessage instance) =>
    <String, dynamic>{
      'msg_id': instance.msgId,
      'ack_msg_id': instance.ackMsgId,
      'type': instance.type,
      'from': instance.from,
      'to': instance.to,
      's_msg_id': instance.serverMsgId,
      'source': instance.source,
    };

CSSendGroupMessage _$CSSendGroupMessageFromJson(Map<String, dynamic> json) {
  return CSSendGroupMessage(
    json['msg_id'] as String,
    json['type'] as String,
    json['s_msg_id'] as String,
    json['from'] as String,
    json['nick'] as String,
    json['group_id'] as String,
    json['group_name'] as String,
    json['icon'] as String,
    json['source'] as String,
    json['content'] as Map<String, dynamic>,
    json['content_type'] as String,
  );
}

Map<String, dynamic> _$CSSendGroupMessageToJson(CSSendGroupMessage instance) =>
    <String, dynamic>{
      'msg_id': instance.msgId,
      'type': instance.type,
      's_msg_id': instance.serverMsgId,
      'from': instance.from,
      'nick': instance.nick,
      'group_id': instance.groupId,
      'group_name': instance.groupName,
      'icon': instance.icon,
      'source': instance.source,
      'content': instance.content,
      'content_type': instance.contentType,
    };

SCGroupCreate _$SCGroupCreateFromJson(Map<String, dynamic> json) {
  return SCGroupCreate(
    json['msg_id'] as String,
    json['type'] as String,
    json['group_title'] as String,
    json['group_id'] as String,
    json['group_icon'] as String,
    json['group_owner_id'] as String,
    json['group_owner_nick'] as String,
    json['group_owner_icon'] as String,
  );
}

Map<String, dynamic> _$SCGroupCreateToJson(SCGroupCreate instance) =>
    <String, dynamic>{
      'msg_id': instance.msgId,
      'type': instance.type,
      'group_title': instance.groupTitle,
      'group_id': instance.groupId,
      'group_icon': instance.groupIcon,
      'group_owner_id': instance.groupOwnerId,
      'group_owner_nick': instance.groupOwnerNick,
      'group_owner_icon': instance.groupOwnerIcon,
    };

SCGroupInviteContent _$SCGroupInviteContentFromJson(Map<String, dynamic> json) {
  return SCGroupInviteContent(
    json['group_title'] as String,
    json['group_id'] as String,
    json['group_icon'] as String,
    json['url'] as String,
    json['note'] as String,
  );
}

Map<String, dynamic> _$SCGroupInviteContentToJson(
        SCGroupInviteContent instance) =>
    <String, dynamic>{
      'group_title': instance.groupTitle,
      'group_id': instance.groupId,
      'group_icon': instance.groupIcon,
      'url': instance.url,
      'note': instance.note,
    };

SCGroupKick _$SCGroupKickFromJson(Map<String, dynamic> json) {
  return SCGroupKick(
    json['msg_id'] as String,
    json['type'] as String,
    json['group_id'] as String,
    json['kick_id'] as String,
    json['kick_nick'] as String,
    json['operator_id'] as String,
    json['operator_nick'] as String,
  );
}

Map<String, dynamic> _$SCGroupKickToJson(SCGroupKick instance) =>
    <String, dynamic>{
      'msg_id': instance.msgId,
      'type': instance.type,
      'group_id': instance.groupId,
      'kick_id': instance.kickId,
      'kick_nick': instance.kickNick,
      'operator_id': instance.operatorId,
      'operator_nick': instance.operatorNick,
    };

SCGroupJoin _$SCGroupJoinFromJson(Map<String, dynamic> json) {
  return SCGroupJoin(
    json['msg_id'] as String,
    json['type'] as String,
    json['group_title'] as String,
    json['group_id'] as String,
    json['inviter_id'] as String,
    json['inviter_nick'] as String,
    json['receiver_id'] as String,
    json['receiver_nick'] as String,
  );
}

Map<String, dynamic> _$SCGroupJoinToJson(SCGroupJoin instance) =>
    <String, dynamic>{
      'msg_id': instance.msgId,
      'type': instance.type,
      'group_title': instance.groupTitle,
      'group_id': instance.groupId,
      'inviter_id': instance.inviterId,
      'inviter_nick': instance.inviterNick,
      'receiver_id': instance.receiverId,
      'receiver_nick': instance.receiverNick,
    };

SCGroupUpdate _$SCGroupUpdateFromJson(Map<String, dynamic> json) {
  return SCGroupUpdate(
    json['msg_id'] as String,
    json['type'] as String,
    json['group_id'] as String,
  );
}

Map<String, dynamic> _$SCGroupUpdateToJson(SCGroupUpdate instance) =>
    <String, dynamic>{
      'msg_id': instance.msgId,
      'type': instance.type,
      'group_id': instance.groupId,
    };

SCGroupRemove _$SCGroupRemoveFromJson(Map<String, dynamic> json) {
  return SCGroupRemove(
    json['msg_id'] as String,
    json['type'] as String,
    json['group_id'] as String,
    json['operator_id'] as String,
    json['operator_nick'] as String,
  );
}

Map<String, dynamic> _$SCGroupRemoveToJson(SCGroupRemove instance) =>
    <String, dynamic>{
      'msg_id': instance.msgId,
      'type': instance.type,
      'group_id': instance.groupId,
      'operator_id': instance.operatorId,
      'operator_nick': instance.operatorNick,
    };

SCAck _$SCAckFromJson(Map<String, dynamic> json) {
  return SCAck(
    json['msg_id'] as String,
    json['ack_msg_id'] as String,
    json['s_msg_id'] as String,
    json['type'] as String,
    json['from'] as String,
  );
}

Map<String, dynamic> _$SCAckToJson(SCAck instance) => <String, dynamic>{
      'msg_id': instance.msgId,
      'ack_msg_id': instance.ackMsgLocalId,
      's_msg_id': instance.ackMsgServerId,
      'type': instance.type,
      'from': instance.from,
    };

SCFriendApply _$SCFriendApplyFromJson(Map<String, dynamic> json) {
  return SCFriendApply(
    json['msg_id'] as String,
    json['type'] as String,
    json['from'] as String,
    json['inviter_nick'] as String,
    json['inviter_icon'] as String,
    json['to'] as String,
    json['note'] as String,
  );
}

Map<String, dynamic> _$SCFriendApplyToJson(SCFriendApply instance) =>
    <String, dynamic>{
      'msg_id': instance.msgId,
      'type': instance.type,
      'from': instance.from,
      'inviter_nick': instance.inviterNick,
      'inviter_icon': instance.inviterIcon,
      'to': instance.to,
      'note': instance.note,
    };

SCFriendResult _$SCFriendResultFromJson(Map<String, dynamic> json) {
  return SCFriendResult(
    json['msg_id'] as String,
    json['type'] as String,
    json['from'] as String,
    json['from_nick'] as String,
    json['from_icon'] as String,
    json['to'] as String,
    json['status'] as String,
    json['note'] as String,
  );
}

Map<String, dynamic> _$SCFriendResultToJson(SCFriendResult instance) =>
    <String, dynamic>{
      'msg_id': instance.msgId,
      'type': instance.type,
      'from': instance.from,
      'from_nick': instance.from_nick,
      'from_icon': instance.from_icon,
      'to': instance.to,
      'status': instance.status,
      'note': instance.note,
    };

SCKickOut _$SCKickOutFromJson(Map<String, dynamic> json) {
  return SCKickOut(
    json['msg_id'] as String,
    json['type'] as String,
    json['source'] as String,
    json['device_id'] as String,
    json['to'] as String,
  );
}

Map<String, dynamic> _$SCKickOutToJson(SCKickOut instance) => <String, dynamic>{
      'msg_id': instance.msgId,
      'type': instance.type,
      'source': instance.source,
      'device_id': instance.deviceId,
      'to': instance.to,
    };

CSPing _$CSPingFromJson(Map<String, dynamic> json) {
  return CSPing(
    json['msg_id'] as String,
    json['type'] as String,
    json['source'] as String,
    json['user_id'] as String,
  );
}

Map<String, dynamic> _$CSPingToJson(CSPing instance) => <String, dynamic>{
      'msg_id': instance.msgId,
      'type': instance.type,
      'source': instance.source,
      'user_id': instance.userId,
    };

SCPong _$SCPongFromJson(Map<String, dynamic> json) {
  return SCPong(
    json['msg_id'] as String,
    json['type'] as String,
    json['source'] as String,
    json['user_id'] as String,
  );
}

Map<String, dynamic> _$SCPongToJson(SCPong instance) => <String, dynamic>{
      'msg_id': instance.msgId,
      'type': instance.type,
      'source': instance.source,
      'user_id': instance.userId,
    };
