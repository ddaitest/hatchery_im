import 'package:hatchery_im/api/entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

const ADAPTER_SESSION = 1;
const ADAPTER_MESSAGE = 2;

class SessionAdapter extends TypeAdapter<Session> {
  @override
  final typeId = ADAPTER_SESSION;

  @override
  Session read(BinaryReader reader) {
    return Session(
      reader.readInt(),
      reader.readString(),
      reader.readInt(),
      reader.readString(),
      reader.readString(),
      reader.readString(),
      reader.read(ADAPTER_MESSAGE),
      reader.read(ADAPTER_MESSAGE),
      reader.readString(),
      reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.title);
    writer.writeInt(obj.type);
    writer.writeString(obj.icon);
    writer.writeString(obj.ownerID);
    writer.writeString(obj.otherID);
    writer.write(obj.lastChatMessage);
    writer.write(obj.lastGroupChatMessage);
    writer.writeString(obj.updateTime);
    writer.writeString(obj.createTime);
  }
}

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final typeId = ADAPTER_SESSION;

  @override
  Message read(BinaryReader reader) {
    return Message(
      reader.readInt(),
      reader.readString(),
      reader.readString(),
      reader.readString(),
      reader.readString(),
      reader.readString(),
      reader.readString(),
      reader.readString(),
      reader.readString(),
      reader.readString(),
      reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.type);
    writer.writeString(obj.userMsgID);
    writer.writeString(obj.sender);
    writer.writeString(obj.nick);
    writer.writeString(obj.receiver);
    writer.writeString(obj.icon);
    writer.writeString(obj.source);
    writer.writeString(obj.content);
    writer.writeString(obj.contentType);
    writer.writeString(obj.createTime);
  }
}
