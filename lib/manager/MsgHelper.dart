import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/manager/userCentre.dart';

// 0发送失败；1发送中; 2发送完成; 3消息已读; 4收到但未读
const MSG_FAULT = 0;
const MSG_SENDING = 1;
const MSG_SENT = 2;
const MSG_READ = 3;
const MSG_RECEIVED = 4;

extension MessageExt on Message {
  bool isGroup() {
    return this.type == "GROUP";
  }

  int? getMsgStatus() {
    if (this.progress != null) {
      this.progress = 4;
      return this.progress;
    } else {
      return this.progress;
    }
  }

  String? getOtherId() {
    String myId = UserCentre.getUserID();
    if (this.sender == myId) {
      if (isGroup()) {
        return this.groupID;
      } else {
        return this.receiver;
      }
    } else {
      return this.sender;
    }
  }
}
