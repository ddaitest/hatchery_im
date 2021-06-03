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
