import 'package:hatchery_im/api/entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

const ADAPTER_SESSION = 1;
const ADAPTER_MESSAGE = 2;

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = ADAPTER_MESSAGE;

  @override
  Message read(BinaryReader reader) {
    // final numOfFields = 12;
    // final fields = <int, dynamic>{
    //   for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    // };
    return Message(
      reader.read() as int,
      reader.read() as String,
      reader.read() as String,
      reader.read() as String,
      reader.read() as String,
      reader.read() as String,
      reader.read() as String,
      reader.read() as String,
      reader.read() as String,
      reader.read() as String,
      reader.read() as String,
      reader.read() as String,
    );
    // )..progress = fields[12];
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..write(obj.id)
      ..write(obj.type)
      ..write(obj.userMsgID)
      ..write(obj.sender)
      ..write(obj.nick)
      ..write(obj.receiver)
      ..write(obj.icon)
      ..write(obj.source)
      ..write(obj.content)
      ..write(obj.contentType)
      ..write(obj.createTime)
      ..write(obj.groupID);
    // ..writeByte(12);
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
