import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/manager/userCentre.dart';

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
    String myId = UserCentre.getInfo()?.userID ?? "";
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
