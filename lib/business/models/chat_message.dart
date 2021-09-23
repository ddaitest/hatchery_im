import 'package:flutter/cupertino.dart';
import 'package:hatchery_im/business/chat_detail/chat_detail_page.dart';

import '../../config.dart';

class ChatMessage {
  String? message;
  MessageBelongType? type;
  ChatMessage({@required this.message, @required this.type});
}
