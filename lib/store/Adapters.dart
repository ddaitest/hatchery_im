import 'package:hatchery_im/api/entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

const ADAPTER_SESSION = 1;
const ADAPTER_MESSAGE = 2;

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = ADAPTER_MESSAGE;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
        fields[1] as int,
        fields[2] as String,
        fields[3] as String,
        fields[4] as String,
        fields[5] as String,
        fields[12] as String?,
        fields[7] as String,
        fields[8] as String,
        fields[9] as String,
        fields[10] as String,
        fields[11] as int,
        fields[6] as String?,
        fields[13] as int?);
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(13)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.userMsgID)
      ..writeByte(4)
      ..write(obj.sender)
      ..writeByte(5)
      ..write(obj.nick)
      ..writeByte(6)
      ..write(obj.receiver)
      ..writeByte(7)
      ..write(obj.icon)
      ..writeByte(8)
      ..write(obj.source)
      ..writeByte(9)
      ..write(obj.content)
      ..writeByte(10)
      ..write(obj.contentType)
      ..writeByte(11)
      ..write(obj.createTime)
      ..writeByte(12)
      ..write(obj.groupID)
      ..writeByte(13)
      ..write(obj.progress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionAdapter extends TypeAdapter<Session> {
  @override
  final int typeId = ADAPTER_SESSION;

  @override
  Session read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Session(
      fields[1] as int,
      fields[2] as String,
      fields[6] as int,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[7] as Message?,
      fields[8] as Message?,
      fields[9] as int,
      fields[10] as int,
      fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer
      ..writeByte(11)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.ownerID)
      ..writeByte(5)
      ..write(obj.otherID)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.lastChatMessage)
      ..writeByte(8)
      ..write(obj.lastGroupChatMessage)
      ..writeByte(9)
      ..write(obj.updateTime)
      ..writeByte(10)
      ..write(obj.createTime)
      ..writeByte(11)
      ..write(obj.top);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
