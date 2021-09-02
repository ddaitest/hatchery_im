import 'package:hatchery_im/api/entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

const ADAPTER_SESSION = 1;
const ADAPTER_MESSAGE = 2;

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
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
      fields[9] as String,
      fields[10] as String,
      fields[11] as String,
    );
    // )..progress = fields[12];
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.userMsgID)
      ..writeByte(3)
      ..write(obj.sender)
      ..writeByte(4)
      ..write(obj.nick)
      ..writeByte(5)
      ..write(obj.receiver)
      ..writeByte(6)
      ..write(obj.icon)
      ..writeByte(7)
      ..write(obj.source)
      ..writeByte(8)
      ..write(obj.content)
      ..writeByte(9)
      ..write(obj.contentType)
      ..writeByte(10)
      ..write(obj.createTime)
      ..writeByte(11)
      ..write(obj.groupID)
      ..writeByte(12);
    // ..write(obj.progress);
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
      fields[0] as int,
      fields[1] as String,
      fields[5] as int,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[6] as Message,
      fields[7] as Message,
      fields[8] as String,
      fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.ownerID)
      ..writeByte(4)
      ..write(obj.otherID)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.lastChatMessage)
      ..writeByte(7)
      ..write(obj.lastGroupChatMessage)
      ..writeByte(8)
      ..write(obj.updateTime)
      ..writeByte(9)
      ..write(obj.createTime);
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
