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
