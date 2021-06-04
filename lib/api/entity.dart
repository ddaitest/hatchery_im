import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

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

// @JsonSerializable()
// class Groups {
//   final String friendId;
//   final String? remarks;
//   final String icon;
//   final String nickName;
//   final int status;
//   Groups(
//       {required this.friendId,
//       this.remarks,
//       required this.icon,
//       required this.nickName,
//       required this.status});
//   factory Groups.fromJson(Map<String, dynamic> json) => _$GroupsFromJson(json);
//   Map<String, dynamic> toJson() => _$GroupsToJson(this);
// }

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
