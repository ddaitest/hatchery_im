// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomMenuInfo _$CustomMenuInfoFromJson(Map<String, dynamic> json) =>
    CustomMenuInfo(
      title: json['title'] as String?,
      url: json['url'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$CustomMenuInfoToJson(CustomMenuInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'icon': instance.icon,
    };

UsersInfo _$UsersInfoFromJson(Map<String, dynamic> json) => UsersInfo(
      userID: json['userID'] as String,
      loginName: json['loginName'] as String,
      nickName: json['nickName'] as String,
      icon: json['icon'] as String?,
      remarks: json['remarks'] as String?,
      notes: json['notes'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      status: json['status'] as int?,
      updateTime: json['updateTime'] as int?,
      createTime: json['createTime'] as int?,
      isFriends: json['isFriends'] as bool,
    );

Map<String, dynamic> _$UsersInfoToJson(UsersInfo instance) => <String, dynamic>{
      'userID': instance.userID,
      'loginName': instance.loginName,
      'nickName': instance.nickName,
      'icon': instance.icon,
      'remarks': instance.remarks,
      'notes': instance.notes,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'status': instance.status,
      'updateTime': instance.updateTime,
      'createTime': instance.createTime,
      'isFriends': instance.isFriends,
    };

Friends _$FriendsFromJson(Map<String, dynamic> json) => Friends(
      friendId: json['friendId'] as String,
      remarks: json['remarks'] as String?,
      notes: json['notes'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      icon: json['icon'] as String,
      nickName: json['nickName'] as String,
      status: json['status'] as int,
    );

Map<String, dynamic> _$FriendsToJson(Friends instance) => <String, dynamic>{
      'friendId': instance.friendId,
      'remarks': instance.remarks,
      'icon': instance.icon,
      'notes': instance.notes,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'nickName': instance.nickName,
      'status': instance.status,
    };

BlockList _$BlockListFromJson(Map<String, dynamic> json) => BlockList(
      userID: json['userID'] as String,
      loginName: json['loginName'] as String?,
      nickName: json['nickName'] as String?,
      icon: json['icon'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$BlockListToJson(BlockList instance) => <String, dynamic>{
      'userID': instance.userID,
      'loginName': instance.loginName,
      'nickName': instance.nickName,
      'icon': instance.icon,
      'notes': instance.notes,
    };

FriendsApplicationInfo _$FriendsApplicationInfoFromJson(
        Map<String, dynamic> json) =>
    FriendsApplicationInfo(
      friendId: json['friendId'] as String,
      remarks: json['remarks'] as String?,
      icon: json['icon'] as String,
      nickName: json['nickName'] as String,
      status: json['status'] as int,
    );

Map<String, dynamic> _$FriendsApplicationInfoToJson(
        FriendsApplicationInfo instance) =>
    <String, dynamic>{
      'friendId': instance.friendId,
      'remarks': instance.remarks,
      'icon': instance.icon,
      'nickName': instance.nickName,
      'status': instance.status,
    };

Groups _$GroupsFromJson(Map<String, dynamic> json) => Groups(
      GroupInfo.fromJson(json['group'] as Map<String, dynamic>),
      json['membersCount'] as int,
      (json['top3Members'] as List<dynamic>)
          .map((e) => GroupMembers.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupsToJson(Groups instance) => <String, dynamic>{
      'group': instance.group.toJson(),
      'membersCount': instance.membersCount,
      'top3Members': instance.top3Members.map((e) => e.toJson()).toList(),
    };

GroupInfo _$GroupInfoFromJson(Map<String, dynamic> json) => GroupInfo(
      json['id'] as int,
      json['groupId'] as String?,
      json['icon'] as String?,
      json['groupName'] as String?,
      json['groupDescription'] as String?,
      json['notes'] as String?,
      json['status'] as int,
      json['updateTime'] as int?,
      json['createTime'] as int?,
    );

Map<String, dynamic> _$GroupInfoToJson(GroupInfo instance) => <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'icon': instance.icon,
      'groupName': instance.groupName,
      'groupDescription': instance.groupDescription,
      'notes': instance.notes,
      'status': instance.status,
      'updateTime': instance.updateTime,
      'createTime': instance.createTime,
    };

GroupMembers _$GroupMembersFromJson(Map<String, dynamic> json) => GroupMembers(
      json['id'] as int,
      json['userID'] as String?,
      json['loginName'] as String?,
      json['nickName'] as String?,
      json['icon'] as String?,
      json['notes'] as String?,
      json['phone'] as String?,
      json['email'] as String?,
      json['password'] as String?,
      json['address'] as String?,
      json['status'] as int,
      json['groupRole'] as int,
      json['groupNickName'] as String?,
      json['groupId'] as String?,
      json['groupStatus'] as int?,
    );

Map<String, dynamic> _$GroupMembersToJson(GroupMembers instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userID': instance.userID,
      'loginName': instance.loginName,
      'nickName': instance.nickName,
      'icon': instance.icon,
      'notes': instance.notes,
      'phone': instance.phone,
      'email': instance.email,
      'password': instance.password,
      'address': instance.address,
      'status': instance.status,
      'groupRole': instance.groupRole,
      'groupNickName': instance.groupNickName,
      'groupId': instance.groupId,
      'groupStatus': instance.groupStatus,
    };

MyProfile _$MyProfileFromJson(Map<String, dynamic> json) => MyProfile(
      json['id'] as int,
      json['userID'] as String?,
      json['loginName'] as String,
      json['nickName'] as String?,
      json['icon'] as String?,
      json['phone'] as String?,
      json['notes'] as String?,
      json['email'] as String?,
      json['password'] as String,
      json['address'] as String?,
      json['status'] as int,
      json['updateTime'] as int,
      json['createTime'] as int,
    );

Map<String, dynamic> _$MyProfileToJson(MyProfile instance) => <String, dynamic>{
      'id': instance.id,
      'userID': instance.userID,
      'loginName': instance.loginName,
      'nickName': instance.nickName,
      'icon': instance.icon,
      'phone': instance.phone,
      'notes': instance.notes,
      'email': instance.email,
      'password': instance.password,
      'address': instance.address,
      'status': instance.status,
      'updateTime': instance.updateTime,
      'createTime': instance.createTime,
    };

FriendProfile _$FriendProfileFromJson(Map<String, dynamic> json) =>
    FriendProfile(
      json['friendId'] as String,
      json['loginName'] as String,
      json['remarks'] as String?,
      json['icon'] as String?,
      json['nickName'] as String?,
      json['notes'] as String?,
      json['phone'] as String?,
      json['email'] as String?,
      json['address'] as String?,
      json['status'] as int,
      json['createTime'] as int,
    );

Map<String, dynamic> _$FriendProfileToJson(FriendProfile instance) =>
    <String, dynamic>{
      'friendId': instance.friendId,
      'loginName': instance.loginName,
      'remarks': instance.remarks,
      'icon': instance.icon,
      'nickName': instance.nickName,
      'notes': instance.notes,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'status': instance.status,
      'createTime': instance.createTime,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      json['id'] as int,
      json['type'] as String,
      json['userMsgID'] as String,
      json['sender'] as String,
      json['nick'] as String,
      json['groupID'] as String?,
      json['icon'] as String,
      json['source'] as String,
      json['content'] as String,
      json['contentType'] as String,
      json['createTime'] as int,
      json['receiver'] as String?,
      json['progress'] as int?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'userMsgID': instance.userMsgID,
      'sender': instance.sender,
      'nick': instance.nick,
      'receiver': instance.receiver,
      'icon': instance.icon,
      'source': instance.source,
      'content': instance.content,
      'contentType': instance.contentType,
      'createTime': instance.createTime,
      'groupID': instance.groupID,
      'progress': instance.progress,
    };

SearchNewContactsInfo _$SearchNewContactsInfoFromJson(
        Map<String, dynamic> json) =>
    SearchNewContactsInfo(
      json['userID'] as String,
      json['loginName'] as String,
      json['nickName'] as String,
      json['icon'] as String,
      json['isFriends'] as bool,
      json['notes'] as String?,
    );

Map<String, dynamic> _$SearchNewContactsInfoToJson(
        SearchNewContactsInfo instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'loginName': instance.loginName,
      'nickName': instance.nickName,
      'icon': instance.icon,
      'isFriends': instance.isFriends,
      'notes': instance.notes,
    };

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      json['id'] as int,
      json['title'] as String,
      json['type'] as int,
      json['icon'] as String,
      json['ownerID'] as String,
      json['otherID'] as String,
      json['lastChatMessage'] == null
          ? null
          : Message.fromJson(json['lastChatMessage'] as Map<String, dynamic>),
      json['lastGroupChatMessage'] == null
          ? null
          : Message.fromJson(
              json['lastGroupChatMessage'] as Map<String, dynamic>),
      json['updateTime'] as int,
      json['createTime'] as int,
      json['top'] as int?,
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon': instance.icon,
      'ownerID': instance.ownerID,
      'otherID': instance.otherID,
      'type': instance.type,
      'lastChatMessage': instance.lastChatMessage?.toJson(),
      'lastGroupChatMessage': instance.lastGroupChatMessage?.toJson(),
      'updateTime': instance.updateTime,
      'createTime': instance.createTime,
      'top': instance.top,
    };
