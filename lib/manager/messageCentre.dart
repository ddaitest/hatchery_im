import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/log.dart';

import 'Constants.dart';
import '../store/LocalStore.dart';
import 'app_handler.dart';

typedef SessionListener = void Function(List<Session> news);
typedef MessageListener = void Function(List<Message> news);

const LOAD_SIZE = 50;

class MessageCentre {
  static final MessageCentre _singleton = MessageCentre._internal();

  factory MessageCentre() {
    return _singleton;
  }

  MessageCentre._internal();

  ///本地存储
  LocalStore _localStore = LocalStore();

  ///Session
  List<Session>? sessions;

  ///监听 session 变化
  SessionListener? sessionListener;

  MessageListener? messageListener;

  String currentListenId = "";

  static init() {
    //获取 session
    var centre = MessageCentre();
    centre._initSessions();
    LocalStore.init();
  }

  static Future<List<Message>> getMessages(String friendId) async {
    return [];
  }

  listenSessions(SessionListener listener) {
    sessionListener = listener;
    if (sessions != null) {
      listener(sessions ?? []);
    }
  }

  listenMessage(MessageListener listener, String friendId) {
    currentListenId = friendId;
    messageListener = listener;
  }

  ///获取 session 信息. 然后同步每个session 最新的消息。
  _initSessions() async {
    Log.yellow("_initSessions 开始");
    // Step1. 返回本地存储的数据。
    sessions = await _localStore.getSessions();
    Log.yellow("_initSessions Step1. 返回本地存储的数据 $sessions");
    sessionListener?.call(sessions ?? []);
    // Step2. 从Server获取最新数据。
    API.querySession().then((value) {
      if (value.isSuccess()) {
        var news = value.getDataList((m) => Session.fromJson(m));
        Log.yellow("_initSessions Step1. 从Server获取最新数据。 $news");
        // Step3. 刷新本地数据。
        _localStore.saveSessions(news);
        _syncNewSessions(news);
        sessions = news;
        sessionListener?.call(sessions ?? []);
        Log.yellow("_initSessions 从Server获取最新数据");
      }
    });
  }

  ///找出需要同步的session
  _syncNewSessions(List<Session> news) {
    List<Session> before = new List.from(sessions ?? []);
    news.forEach((newOne) {
      int index = before.indexWhere((oldOne) => oldOne.id == newOne.id);
      if (index < 0) {
        _syncSession(null, newOne);
      } else {
        _syncSession(before[index], newOne);
      }
    });
  }

  ///同步 session 的 message
  _syncSession(Session? before, Session latest) {
    if (latest.type == CHAT_TYPE_ONE) {
      //单聊
      if (before == null) {
        //更新消息,一直到没有
        _loadFriendHistory(latest.otherID, latest.lastChatMessage.id, -1);
      } else if (before.lastChatMessage.id != latest.lastChatMessage.id) {
        //更新消息,一直到before
        _loadFriendHistory(latest.otherID, latest.lastChatMessage.id,
            before.lastChatMessage.id);
      }
    } else {
      //群聊
      if (before == null) {
        //更新消息,一直到没有
        _loadGroupHistory(latest.otherID, latest.lastGroupChatMessage.id, -1);
      } else if (before.lastGroupChatMessage.id !=
          latest.lastGroupChatMessage.id) {
        //更新消息,一直到before
        _loadGroupHistory(latest.otherID, latest.lastGroupChatMessage.id,
            before.lastGroupChatMessage.id);
      }
    }
  }

  _loadFriendHistory(String friendID, int from, int to) async {
    Log.yellow("更新消息, 单聊, $from to $to");
    int currentFrom = from;
    bool found = false;
    bool end = false;
    while (!found && !end) {
      var result = await _queryHistoryFriend(friendID, currentFrom);
      end = result.length < 1;
      var temp = <Message>[];
      for (var msg in result) {
        if (msg.id == to) {
          found = true;
          break;
        } else {
          currentFrom = msg.id;
          _localStore.saveMessage(msg);
          temp.add(msg);
        }
      }
      if (temp.length > 0) {
        //Notify all
        _notifyMessageChanged(friendID);
      }
    }
  }

  _loadGroupHistory(String friendID, int from, int to) async {
    Log.yellow("更新消息, 群聊, $from to $to");
    //TODO
  }

  Future<List<Message>> _queryHistoryFriend(String friendID, int from) async {
    var values = await API.messageHistoryWithFriend(
        friendID: friendID, currentMsgID: from, page: 0, size: LOAD_SIZE);
    var news = values.getDataList((m) => Message.fromJson(m));
    return news;
  }

  Future<List<Message>> _queryHistoryGroup(String groupID, int from) async {
    var values = await API.getGroupHistory(
        groupID: groupID, currentMsgID: from, page: 0, size: LOAD_SIZE);
    var news = values.getDataList((m) => Message.fromJson(m));
    return news;
  }

  _notifyMessageChanged(String friendID) {}
}
