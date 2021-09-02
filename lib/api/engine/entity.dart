import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

//flutter pub run build_runner build

///1.请求认证消息（C--->S）
@JsonSerializable()
class CSAuthMessage {
  @JsonKey(name: 'msg_id')
  String msgId;
  @JsonKey(name: 'user_id')
  String userId;
  String type = "AUTH";
  String token;
  String source;
  @JsonKey(name: 'device_id')
  String deviceId;
  @JsonKey(name: 'login_ip')
  String loginIp;

  CSAuthMessage(this.msgId, this.userId, this.type, this.token, this.source,
      this.deviceId, this.loginIp);

  factory CSAuthMessage.fromJson(Map<String, dynamic> json) =>
      _$CSAuthMessageFromJson(json);

  Map<String, dynamic> toJson() => _$CSAuthMessageToJson(this);
}

///2.认证返回消息（S-->C）
@JsonSerializable()
class SCAuthMessage {
  @JsonKey(name: 'msg_id')
  String msgId;
  @JsonKey(name: 'user_id')
  String userId;
  String type;
  String code;
  String message;
  @JsonKey(name: 'ack_msg_id')
  String ackMsgId;

  SCAuthMessage(this.msgId, this.userId, this.type, this.code, this.message,
      this.ackMsgId);

  factory SCAuthMessage.fromJson(Map<String, dynamic> json) =>
      _$SCAuthMessageFromJson(json);

  Map<String, dynamic> toJson() => _$SCAuthMessageToJson(this);
}

///3 单聊消息
@JsonSerializable()
class CSSendMessage {
  @JsonKey(name: 'msg_id')
  String msgId;
  String type = "CHAT"; //聊天类型（CHAT表示单聊，GROUP表示群聊）
  @JsonKey(name: 's_msg_id')
  String serverMsgId; //服务端消息ID（由服务端生成。客户端不用过问
  String from; //发送者(用户ID)
  String nick; //发送者昵称
  String to; //接受者(用户ID)
  String icon; //发送者头像
  String source; //来源信息(ANDROID/IOS/WEB/IOT/PC)
  Map<String, dynamic> content; //发送内容（可根据content_type自定义内容）
  @JsonKey(name: 'content_type')
  String contentType;

  CSSendMessage(
      this.msgId,
      this.type,
      this.serverMsgId,
      this.from,
      this.nick,
      this.to,
      this.icon,
      this.source,
      this.content,
      this.contentType); //消息内容类型（TEXT表示文本、IMAGE表示图片、VIDEO 表示视频、GEO表示地理位置、VOICE表示语音、FILE表 示文件、URL表示链接、CARD表示名片消息、STICKER 表示表情）

  factory CSSendMessage.fromJson(Map<String, dynamic> json) =>
      _$CSSendMessageFromJson(json);

  Map<String, dynamic> toJson() => _$CSSendMessageToJson(this);
}

///4.单聊客户端ACK消息（C-->S
@JsonSerializable()
class CSAckMessage {
  @JsonKey(name: 'msg_id')
  String msgId;

  @JsonKey(name: 'ack_msg_id')
  String ackMsgId; //消息ID(前端消息ID)

  String type = "CHAT_ACK"; //聊天类型（CHAT表示单聊，GROUP表示群聊）

  String from; //发送者(用户ID)
  String to; //接受者(用户ID)
  @JsonKey(name: 's_msg_id')
  String serverMsgId; //服务端消息ID（由服务端生成。客户端不用过问

  String source;

  CSAckMessage(this.msgId, this.ackMsgId, this.type, this.from, this.to,
      this.serverMsgId, this.source); //来源信息(ANDROID/IOS/WEB/IOT/PC)

  factory CSAckMessage.fromJson(Map<String, dynamic> json) =>
      _$CSAckMessageFromJson(json);

  Map<String, dynamic> toJson() => _$CSAckMessageToJson(this);
}

///5.群聊消息（C-->S）
@JsonSerializable()
class CSSendGroupMessage {
  @JsonKey(name: 'msg_id')
  String msgId;
  String type = "GROUP"; //聊天类型（CHAT表示单聊，GROUP表示群聊）
  @JsonKey(name: 's_msg_id')
  String serverMsgId; //服务端消息ID（由服务端生成。客户端不用过问
  String from; //发送者(用户ID)
  String nick; //发送者昵称
  @JsonKey(name: 'group_id')
  String groupId; //群ID
  @JsonKey(name: 'group_name')
  String groupName; //群名
  String icon; //发送者头像
  String source; //来源信息(ANDROID/IOS/WEB/IOT/PC)
  Map<String, dynamic> content; //发送内容（可根据content_type自定义内容）
  @JsonKey(name: 'content_type')
  String contentType;

  CSSendGroupMessage(
      this.msgId,
      this.type,
      this.serverMsgId,
      this.from,
      this.nick,
      this.groupId,
      this.groupName,
      this.icon,
      this.source,
      this.content,
      this.contentType);

  factory CSSendGroupMessage.fromJson(Map<String, dynamic> json) =>
      _$CSSendGroupMessageFromJson(json);

  Map<String, dynamic> toJson() => _$CSSendGroupMessageToJson(this);
}

///6.1 群通知消息（S-->C）群创建初始消息
@JsonSerializable()
class SCGroupCreate {
  @JsonKey(name: 'msg_id')
  String msgId;
  String type = "GROUP_INIT";
  @JsonKey(name: 'group_title')
  String groupTitle; //群名称
  @JsonKey(name: 'group_id')
  String groupId; //群ID
  @JsonKey(name: 'group_icon')
  String groupIcon; //群图标
  @JsonKey(name: 'group_owner_id')
  String groupOwnerId; //群主ID
  @JsonKey(name: 'group_owner_nick')
  String groupOwnerNick; //群主昵称
  @JsonKey(name: 'group_owner_icon')
  String groupOwnerIcon;

  SCGroupCreate(
      this.msgId,
      this.type,
      this.groupTitle,
      this.groupId,
      this.groupIcon,
      this.groupOwnerId,
      this.groupOwnerNick,
      this.groupOwnerIcon); //群主头像

  factory SCGroupCreate.fromJson(Map<String, dynamic> json) =>
      _$SCGroupCreateFromJson(json);

  Map<String, dynamic> toJson() => _$SCGroupCreateToJson(this);
}

// ///6.2 群通知消息（S-->C）邀请进群通知
// @JsonSerializable(explicitToJson: true)
// class SCGroupInvite {
//   @JsonKey(name: 'msg_id')
//   String msgId;
//   String type = "GROUP_INVIT";
//   @JsonKey(name: 's_msg_id')
//   String serverMsgId; //群名称
//   String from; //发送者(用户ID)
//   String nick; //发送者昵称
//   String to; //接受者(用户ID)
//   String icon; //发送者头像
//   String source; //来源信息(ANDROID/IOS/WEB/IOT/PC)
//   SCGroupInviteContent content;
//   @JsonKey(name: 'content_type')
//   String contentType;
//
//   SCGroupInvite(this.msgId, this.type, this.serverMsgId, this.from, this.nick,
//       this.to, this.icon, this.source, this.content, this.contentType);
//
//   factory SCGroupInvite.fromJson(Map<String, dynamic> json) =>
//       _$SCGroupInviteFromJson(json);
//
//   Map<String, dynamic> toJson() => _$SCGroupInviteToJson(this);
// }

///6.2.1 群通知消息（S-->C）邀请进群通知的内容
@JsonSerializable()
class SCGroupInviteContent {
  @JsonKey(name: 'group_title')
  String groupTitle; //群名称
  @JsonKey(name: 'group_id')
  String groupId; //群ID
  @JsonKey(name: 'group_icon')
  String groupIcon; //群图标
  String url; //接收邀请url
  String note;

  SCGroupInviteContent(this.groupTitle, this.groupId, this.groupIcon, this.url,
      this.note); //邀请留言

  factory SCGroupInviteContent.fromJson(Map<String, dynamic> json) =>
      _$SCGroupInviteContentFromJson(json);

  Map<String, dynamic> toJson() => _$SCGroupInviteContentToJson(this);
}

///6.3 群通知消息（S-->C）群踢人通知
@JsonSerializable()
class SCGroupKick {
  @JsonKey(name: 'msg_id')
  String msgId;
  String type = "GROUP_KICK";

  @JsonKey(name: 'group_id')
  String groupId; //群ID
  @JsonKey(name: 'kick_id')
  String kickId; //被踢人ID
  @JsonKey(name: 'kick_nick')
  String kickNick; //被踢人ID昵称
  @JsonKey(name: 'operator_id')
  String operatorId; //操作者
  @JsonKey(name: 'operator_nick')
  String operatorNick;

  SCGroupKick(this.msgId, this.type, this.groupId, this.kickId, this.kickNick,
      this.operatorId, this.operatorNick); //操作者昵称

  factory SCGroupKick.fromJson(Map<String, dynamic> json) =>
      _$SCGroupKickFromJson(json);

  Map<String, dynamic> toJson() => _$SCGroupKickToJson(this);
}

///6.4 群通知消息（S-->C）进群消息
@JsonSerializable()
class SCGroupJoin {
  @JsonKey(name: 'msg_id')
  String msgId;
  String type = "GROUP_JOIN";

  @JsonKey(name: 'group_title')
  String groupTitle; //群名称
  @JsonKey(name: 'group_id')
  String groupId; //群ID
  @JsonKey(name: 'inviter_id')
  String inviterId; //邀请人ID
  @JsonKey(name: 'inviter_nick')
  String inviterNick; //邀请人昵称
  @JsonKey(name: 'receiver_id')
  String receiverId; //接收人ID
  @JsonKey(name: 'receiver_nick')
  String receiverNick;

  SCGroupJoin(
      this.msgId,
      this.type,
      this.groupTitle,
      this.groupId,
      this.inviterId,
      this.inviterNick,
      this.receiverId,
      this.receiverNick); //接收人昵称

  factory SCGroupJoin.fromJson(Map<String, dynamic> json) =>
      _$SCGroupJoinFromJson(json);

  Map<String, dynamic> toJson() => _$SCGroupJoinToJson(this);
}

///6.5 群通知消息（S-->C）群信息变更消息
@JsonSerializable()
class SCGroupUpdate {
  @JsonKey(name: 'msg_id')
  String msgId;
  String type = "GROUP_UPDATE";

  @JsonKey(name: 'group_id')
  String groupId;

  SCGroupUpdate(this.msgId, this.type, this.groupId); //群ID

  factory SCGroupUpdate.fromJson(Map<String, dynamic> json) =>
      _$SCGroupUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$SCGroupUpdateToJson(this);
}

///6.6 群通知消息（S-->C）解散群消息
@JsonSerializable()
class SCGroupRemove {
  @JsonKey(name: 'msg_id')
  String msgId;
  String type = "GROUP_REMOVE";

  @JsonKey(name: 'group_id')
  String groupId;

  @JsonKey(name: 'operator_id')
  String operatorId;

  @JsonKey(name: 'operator_nick')
  String operatorNick;

  SCGroupRemove(
      this.msgId, this.type, this.groupId, this.operatorId, this.operatorNick);

  factory SCGroupRemove.fromJson(Map<String, dynamic> json) =>
      _$SCGroupRemoveFromJson(json);

  Map<String, dynamic> toJson() => _$SCGroupRemoveToJson(this);
}

///7 服务端ACK消息（S-->C）
@JsonSerializable()
class SCAck {
  @JsonKey(name: 'msg_id')
  String msgId;

  @JsonKey(name: 'ack_msg_id')
  String ackMsgLocalId;

  @JsonKey(name: 's_msg_id')
  String ackMsgServerId;

  String type = "SERVER_ACK";

  String from;


  SCAck(this.msgId, this.ackMsgLocalId, this.ackMsgServerId, this.type,
      this.from);

  factory SCAck.fromJson(Map<String, dynamic> json) => _$SCAckFromJson(json);

  Map<String, dynamic> toJson() => _$SCAckToJson(this);
}

///8.1 系统通知消息（S-->C）	好友申请消息
@JsonSerializable()
class SCFriendApply {
  @JsonKey(name: 'msg_id')
  String msgId;
  String type = "FRIEND_APPL";

  String from; //邀请人ID
  @JsonKey(name: 'inviter_nick')
  String inviterNick; //邀请人昵称
  @JsonKey(name: 'inviter_icon')
  String inviterIcon; //邀请人头像
  String to; //接收人ID
  String note;

  SCFriendApply(this.msgId, this.type, this.from, this.inviterNick,
      this.inviterIcon, this.to, this.note); //邀请留言

  factory SCFriendApply.fromJson(Map<String, dynamic> json) =>
      _$SCFriendApplyFromJson(json);

  Map<String, dynamic> toJson() => _$SCFriendApplyToJson(this);
}

///8.2 系统通知消息（S-->C）	好友申请结果消息
@JsonSerializable()
class SCFriendResult {
  @JsonKey(name: 'msg_id')
  String msgId;
  String type = "FRIEND_RESULT";

  String from; //邀请人ID
  String from_nick; //邀请人昵称
  String from_icon; //邀请人头像
  String to; //接收人ID
  String status; //状态（APPROVE同意、REFUSE拒绝、NONE未处理）
  String note;

  SCFriendResult(this.msgId, this.type, this.from, this.from_nick,
      this.from_icon, this.to, this.status, this.note); //邀请留言

  factory SCFriendResult.fromJson(Map<String, dynamic> json) =>
      _$SCFriendResultFromJson(json);

  Map<String, dynamic> toJson() => _$SCFriendResultToJson(this);
}

///8.3 系统通知消息（S-->C）	被挤掉线消息
@JsonSerializable()
class SCKickOut {
  @JsonKey(name: 'msg_id')
  String msgId;
  String type = "OCCUPATION_LINE";

  String source; //邀请人ID
  @JsonKey(name: 'device_id')
  String deviceId; //邀请人昵称
  String to;

  SCKickOut(this.msgId, this.type, this.source, this.deviceId, this.to); //接收人ID

  factory SCKickOut.fromJson(Map<String, dynamic> json) =>
      _$SCKickOutFromJson(json);

  Map<String, dynamic> toJson() => _$SCKickOutToJson(this);
}

///心跳发送消息（C-->S）
@JsonSerializable()
class CSPing {
  @JsonKey(name: 'msg_id')
  String msgId;
  String type = "PING";

  String source; //邀请人ID
  @JsonKey(name: 'user_id')
  String userId;

  CSPing(this.msgId, this.type, this.source, this.userId); //用户ID

  factory CSPing.fromJson(Map<String, dynamic> json) => _$CSPingFromJson(json);

  Map<String, dynamic> toJson() => _$CSPingToJson(this);
}

///心跳回复消息（S-->C）
@JsonSerializable()
class SCPong {
  @JsonKey(name: 'msg_id')
  String msgId;
  String type = "PONG";

  String source; //邀请人ID
  @JsonKey(name: 'user_id')
  String userId;

  // @JsonKey(name: 'ack_msg_id')
  // String ackMsgId;

  SCPong(this.msgId, this.type, this.source, this.userId); //邀请人昵称

  factory SCPong.fromJson(Map<String, dynamic> json) => _$SCPongFromJson(json);

  Map<String, dynamic> toJson() => _$SCPongToJson(this);
}
