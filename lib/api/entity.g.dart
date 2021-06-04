// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friends _$FriendsFromJson(Map<String, dynamic> json) {
  return Friends(
    friendId: json['friendId'] as String,
    remarks: json['remarks'] as String?,
    icon: json['icon'] as String,
    nickName: json['nickName'] as String,
    status: json['status'] as int,
  );
}

Map<String, dynamic> _$FriendsToJson(Friends instance) => <String, dynamic>{
      'friendId': instance.friendId,
      'remarks': instance.remarks,
      'icon': instance.icon,
      'nickName': instance.nickName,
      'status': instance.status,
    };

MyProfile _$MyProfileFromJson(Map<String, dynamic> json) {
  return MyProfile(
    json['id'] as int,
    json['userID'] as String?,
    json['loginName'] as String,
    json['nickName'] as String,
    json['icon'] as String,
    json['phone'] as String?,
    json['notes'] as String?,
    json['email'] as String?,
    json['password'] as String,
    json['address'] as String?,
    json['status'] as int,
    json['updateTime'] as String,
    json['createTime'] as String,
  );
}

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
