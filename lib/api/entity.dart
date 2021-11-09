import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

///flutter pub run build_runner build

@JsonSerializable()
class CustomMenuInfo {
  final String? title;
  final String? url;
  final String? icon;

  CustomMenuInfo({
    this.title,
    this.url,
    this.icon,
  });

  factory CustomMenuInfo.fromJson(Map<String, dynamic> json) =>
      _$CustomMenuInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CustomMenuInfoToJson(this);
}

@JsonSerializable()
class UsersInfo {
  final String userID;
  final String loginName;
  final String nickName;
  final String? icon;
  final String? remarks;
  final String? notes;
  final String? phone;
  final String? email;
  final String? address;
  final int? status;
  final String? updateTime;
  final String? createTime;
  final bool isFriends;

  UsersInfo(
      {required this.userID,
      required this.loginName,
      required this.nickName,
      this.icon,
      this.remarks,
      this.notes,
      this.phone,
      this.email,
      this.address,
      required this.status,
      this.updateTime,
      this.createTime,
      required this.isFriends});

  factory UsersInfo.fromJson(Map<String, dynamic> json) =>
      _$UsersInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UsersInfoToJson(this);
}

@JsonSerializable()
class Friends {
  final String friendId;
  final String? remarks;
  final String icon;
  final String? notes;
  final String? phone;
  final String? email;
  final String? address;
  final String nickName;
  final int status;

  Friends(
      {required this.friendId,
      this.remarks,
      this.notes,
      this.phone,
      this.email,
      this.address,
      required this.icon,
      required this.nickName,
      required this.status});

  factory Friends.fromJson(Map<String, dynamic> json) =>
      _$FriendsFromJson(json);

  Map<String, dynamic> toJson() => _$FriendsToJson(this);
}

@JsonSerializable()
class BlockList {
  final String userID;
  final String? loginName;
  final String? nickName;
  final String? icon;
  final String? notes;

  BlockList(
      {required this.userID,
      this.loginName,
      this.nickName,
      this.icon,
      this.notes});

  factory BlockList.fromJson(Map<String, dynamic> json) =>
      _$BlockListFromJson(json);

  Map<String, dynamic> toJson() => _$BlockListToJson(this);
}

@JsonSerializable()
class FriendsApplicationInfo {
  final String friendId;
  final String? remarks;
  final String icon;
  final String nickName;
  final int status;

  FriendsApplicationInfo(
      {required this.friendId,
      this.remarks,
      required this.icon,
      required this.nickName,
      required this.status});

  factory FriendsApplicationInfo.fromJson(Map<String, dynamic> json) =>
      _$FriendsApplicationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FriendsApplicationInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Groups {
  GroupInfo group;
  int membersCount = 0;
  List<GroupMembers> top3Members;

  Groups(
    this.group,
    this.membersCount,
    this.top3Members,
  );

  factory Groups.fromJson(Map<String, dynamic> json) => _$GroupsFromJson(json);

  Map<String, dynamic> toJson() => _$GroupsToJson(this);
}

@JsonSerializable()
class GroupInfo {
  int id;
  String? groupId = '';
  String? icon = '';
  String? groupName = '';
  String? groupDescription = '';
  String? notes = '';
  int status;
  String? updateTime = '';
  String? createTime = '';

  GroupInfo(
      this.id,
      this.groupId,
      this.icon,
      this.groupName,
      this.groupDescription,
      this.notes,
      this.status,
      this.updateTime,
      this.createTime);

  factory GroupInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GroupInfoToJson(this);
}

@JsonSerializable()
class GroupMembers {
  int id = 0;
  String? userID = '';
  String? loginName = '';
  String? nickName = '';
  String? icon = '';
  String? notes = '';
  String? phone = '';
  String? email = '';
  String? password = '';
  String? address = '';
  int status = 0;
  int groupRole = 0;
  String? groupNickName = '';
  String? groupId = '';
  int? groupStatus = 0;

  GroupMembers(
      this.id,
      this.userID,
      this.loginName,
      this.nickName,
      this.icon,
      this.notes,
      this.phone,
      this.email,
      this.password,
      this.address,
      this.status,
      this.groupRole,
      this.groupNickName,
      this.groupId,
      this.groupStatus);

  factory GroupMembers.fromJson(Map<String, dynamic> json) =>
      _$GroupMembersFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMembersToJson(this);
}

@JsonSerializable()
class MyProfile {
  int id;
  String? userID = '';
  String loginName = '';
  String? nickName = '';
  String? icon = '';
  String? phone = '';
  String? notes = '';
  String? email = '';
  String password = '';
  String? address = '';
  int status;
  String updateTime = '';
  String createTime = '';

  MyProfile(
      this.id,
      this.userID,
      this.loginName,
      this.nickName,
      this.icon,
      this.phone,
      this.notes,
      this.email,
      this.password,
      this.address,
      this.status,
      this.updateTime,
      this.createTime);

  factory MyProfile.fromJson(Map<String, dynamic> json) =>
      _$MyProfileFromJson(json);

  Map<String, dynamic> toJson() => _$MyProfileToJson(this);
}

@JsonSerializable()
class FriendProfile {
  String friendId = '';
  String? remarks = '';
  String? icon = '';
  String? nickName = '';
  String? notes = '';
  String? phone = '';
  String? email = '';
  String? address = '';

  FriendProfile(
    this.friendId,
    this.remarks,
    this.icon,
    this.nickName,
    this.notes,
    this.phone,
    this.email,
    this.address,
  );

  factory FriendProfile.fromJson(Map<String, dynamic> json) =>
      _$FriendProfileFromJson(json);

  Map<String, dynamic> toJson() => _$FriendProfileToJson(this);
}

@JsonSerializable()
class Message extends HiveObject {
  int id;
  String type; //"CHAT"; //聊天类型（CHAT 表示单聊，GROUP 表示群聊）
  String userMsgID;
  String sender;
  String nick;
  String? receiver;
  String icon;
  String source;
  String content;
  String contentType;
  String createTime;
  String? groupID;
  // int progress = 0; // 0默认; 1发送中; 2发送完成; 3已读; 4收到的消息。

  Message(
    this.id,
    this.type,
    this.userMsgID,
    this.sender,
    this.nick,
    this.groupID,
    this.icon,
    this.source,
    this.content,
    this.contentType,
    this.createTime,
    this.receiver,
  );

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable()
class SearchNewContactsInfo {
  String userID = '';
  String loginName = '';
  String nickName = '';
  String icon = '';
  bool isFriends;
  String? notes;

  SearchNewContactsInfo(this.userID, this.loginName, this.nickName, this.icon,
      this.isFriends, this.notes);

  factory SearchNewContactsInfo.fromJson(Map<String, dynamic> json) =>
      _$SearchNewContactsInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SearchNewContactsInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Session extends HiveObject {
  int id; //会话ID
  String title; //会话标题
  String icon; //会话图标
  String ownerID; //会话拥有者ID
  String otherID; //对方ID，单聊回话的时候是对方ID，群聊的时候是群ID
  int type; //会话类型，0表示单聊，1表示群聊
  Message? lastChatMessage; //最后一条消息，当是单聊时此处有值
  Message? lastGroupChatMessage; //最后一条消息，当是群聊时此处有值
  String updateTime; //更新时间
  String createTime;

  Session(
      this.id,
      this.title,
      this.type,
      this.icon,
      this.ownerID,
      this.otherID,
      this.lastChatMessage,
      this.lastGroupChatMessage,
      this.updateTime,
      this.createTime); //创建时间

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
