import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

///flutter pub run build_runner build

@JsonSerializable()
class Friends {
  final String friendId;
  final String? remarks;
  final String icon;
  final String nickName;
  final int status;
  Friends(
      {required this.friendId,
      this.remarks,
      required this.icon,
      required this.nickName,
      required this.status});
  factory Friends.fromJson(Map<String, dynamic> json) =>
      _$FriendsFromJson(json);
  Map<String, dynamic> toJson() => _$FriendsToJson(this);
}

@JsonSerializable()
class Groups {
  GroupsInfo group;
  int membersCount = 0;
  List<GroupsTop3Members> top3Members;
  Groups(
    this.group,
    this.membersCount,
    this.top3Members,
  );
  factory Groups.fromJson(Map<String, dynamic> json) => _$GroupsFromJson(json);
  Map<String, dynamic> toJson() => _$GroupsToJson(this);
}

@JsonSerializable()
class GroupsInfo {
  int id;
  String? groupId = '';
  String? icon = '';
  String? groupName = '';
  String? groupDescription = '';
  String? notes = '';
  int status;
  String? updateTime = '';
  String? createTime = '';
  GroupsInfo(
      this.id,
      this.groupId,
      this.icon,
      this.groupName,
      this.groupDescription,
      this.notes,
      this.status,
      this.updateTime,
      this.createTime);
  factory GroupsInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupsInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GroupsInfoToJson(this);
}

@JsonSerializable()
class GroupsTop3Members {
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
  GroupsTop3Members(
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
  factory GroupsTop3Members.fromJson(Map<String, dynamic> json) =>
      _$GroupsTop3MembersFromJson(json);
  Map<String, dynamic> toJson() => _$GroupsTop3MembersToJson(this);
}

@JsonSerializable()
class MyProfile {
  int id;
  String? userID = '';
  String loginName = '';
  String nickName = '';
  String icon = '';
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
class FriendsHistoryMessages {
  int id;
  String type;
  String userMsgID;
  String sender;
  String nick;
  String receiver;
  String icon;
  String source;
  String content;
  String contentType;
  String createTime;
  FriendsHistoryMessages(
      this.id,
      this.type,
      this.userMsgID,
      this.sender,
      this.nick,
      this.receiver,
      this.icon,
      this.source,
      this.content,
      this.contentType,
      this.createTime);
  factory FriendsHistoryMessages.fromJson(Map<String, dynamic> json) =>
      _$FriendsHistoryMessagesFromJson(json);
  Map<String, dynamic> toJson() => _$FriendsHistoryMessagesToJson(this);
}
