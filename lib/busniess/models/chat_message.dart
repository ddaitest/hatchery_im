import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/busniess/chat_detail/chat_detail_page.dart';

class ChatMessage {
  String? message;
  MessageType? type;
  ChatMessage({@required this.message, @required this.type});
}
