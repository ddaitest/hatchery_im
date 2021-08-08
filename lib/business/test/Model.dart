import 'package:hive_flutter/hive_flutter.dart';

class TestMessage extends HiveObject {
  String title;
  int age;

  TestMessage(this.title, this.age);

  @override
  String toString() {
    return 'TestMessage{title: $title, age: $age}';
  }
}

class TestMsgAdapter extends TypeAdapter<TestMessage> {
  @override
  final typeId = 0;

  @override
  TestMessage read(BinaryReader reader) {
    return TestMessage(reader.read(), reader.readInt());
  }

  @override
  void write(BinaryWriter writer, TestMessage obj) {
    writer.write(obj.title);
    writer.write(obj.age);
  }
}
