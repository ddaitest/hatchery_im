import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'ApiResult.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/config.dart';

extension ExtendedDio on Dio {
  initWrapper() {
    InterceptorsWrapper wrapper =
        InterceptorsWrapper(onRequest: (options, handler) {
      print('HTTP.onRequest: ${options.data} ');
      print('HTTP.headers: ${options.headers} ');
      print('HTTP.url: ${options.uri} ');
      return handler.next(options); //continue
    }, onResponse: (response, handler) {
      print(
          'HTTP.onResponse: statusCode = ${response.statusCode} ;data = ${response.data} ');
      if (response.statusCode == 403) {
        showToast('请重新登录');
        SP.delete(SPKey.userInfo);
        Routers.navigateAndRemoveUntil('/login');
      }
      return handler.next(response); // continue
    }, onError: (DioError e, handler) {
      print('HTTP.onError: = ${e.message} ');
      print('HTTP.onError: = ${e.response?.data} ');
      print('HTTP.onError: = ${e.response?.statusCode} ');
      print('HTTP.onError: = ${e.response?.statusMessage} ');
      return handler.next(e); //continue
    });
    this.interceptors.add(wrapper);
    return this;
  }
}

class API {
  static Dio _dio = Dio(BaseOptions(
    baseUrl: Flavors.apiInfo.API_HOST,
    connectTimeout: Flavors.apiInfo.API_CONNECT_TIMEOUT,
    receiveTimeout: Flavors.apiInfo.API_RECEIVE_TIMEOUT,
    queryParameters: commonParamMap,
  )).initWrapper();

  static bool skipCheck = false;
  static String? _userInfoData;
  static String _token = '';
  static Map<String, dynamic> commonParamMap = DeviceInfo.info;

  static _checkToken() {
    _userInfoData = SP.getString(SPKey.userInfo);
    if (_userInfoData != null) {
      _token = jsonDecode(SP.getString(SPKey.userInfo))['token'];
    }
    return _token;
  }

  static init() {
    _checkToken();
    if (!skipCheck) {
      isNetworkConnect().then((value) {
        if (!value) {
          showToast('网络未连接，请检查网络设置');
        }
      });
    }
  }

  ///账号注册
  static Future<ApiResult> usersRegister(
    String loginName,
    String nickName,
    String avatar,
    String password,
    String notes,
    String phone,
    String email,
    String address,
  ) async {
    Map<String, String> body = {
      "loginName": loginName,
      "nickName": nickName,
      "icon": avatar,
      "password": password,
      "notes": notes,
      "phone": phone,
      "email": email,
      "address": address
    };
    init();
    try {
      Response response = await _dio.post("/users/create", data: body);
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///发送手机验证码
  static Future<ApiResult> sendSMS(
    String userPhone,
    String areaCode,
    int sendType,
  ) async {
    Map<String, dynamic> body = {
      "userPhone": userPhone,
      "areaCode": areaCode,
      "sendType": sendType
    };
    init();
    try {
      Response response = await _dio.post("/sms/send", data: json.encode(body));
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///手机号登录
  static Future<ApiResult> phoneLogin(
    String phone,
    String areaCode,
    String code,
  ) async {
    Map<String, String> body = {
      "phone": phone,
      "areaCode": areaCode,
      "code": code,
    };
    init();
    try {
      Response response =
          await _dio.post("/users/phone/login", data: json.encode(body));
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///获取好友列表
  static Future<ApiResult> getConfig() async {
    init();
    try {
      Response response = await _dio.get("/config/system/info",
          options: Options(
            headers: {"BEE_TOKEN": _token},
          ));
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///账号登录
  static Future<ApiResult> usersLogin(
    String loginName,
    String password,
  ) async {
    Map<String, String> body = {
      "loginName": loginName,
      "password": password,
    };
    init();
    try {
      Response response =
          await _dio.post("/users/login", data: json.encode(body));
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///搜索好友
  static Future<ApiResult> searchNewContacts(
    String searchKey,
  ) async {
    Map<String, String> queryParam = {
      "searchStr": searchKey,
    };
    init();
    try {
      Response response = await _dio.get("/users/search",
          queryParameters: queryParam,
          options: Options(
            headers: {"BEE_TOKEN": _token},
          ));
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///获取好友列表
  static Future<ApiResult> getFriendsListData(
    int size,
    int page,
  ) async {
    Map<String, int> queryParam = {
      "size": size,
      "page": page,
    };
    init();
    try {
      Response response = await _dio.get("/roster/page",
          queryParameters: queryParam,
          options: Options(
            headers: {"BEE_TOKEN": _token},
          ));
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///好友申请数据
  static Future<ApiResult> getNewFriendsApplicationListData(
    int size,
    int page,
  ) async {
    Map<String, int> queryParam = {
      "size": size,
      "page": page,
    };
    init();
    try {
      Response response = await _dio.get("/roster/friends/applications",
          queryParameters: queryParam,
          options: Options(
            headers: {"BEE_TOKEN": _token},
          ));
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///好友申请回复
  ///status： -1 拒绝；0：同意
  static Future<ApiResult> replyNewContactsRes(String friendId, int status,
      {String notes = ''}) async {
    Map<String, dynamic> body = {
      "friendId": friendId,
      "notes": notes,
      "status": status,
    };
    init();
    try {
      Response response = await _dio.post("/roster/reply",
          data: json.encode(body),
          options: Options(
            headers: {"BEE_TOKEN": _token},
          ));
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///入群申请
  static Future<ApiResult> replyNewGroupRes(String merberlogID) async {
    Map<String, dynamic> body = {
      "merberlogID": merberlogID,
    };
    init();
    try {
      Response response = await _dio.post("/groups/groups/approve",
          data: json.encode(body),
          options: Options(
            headers: {"BEE_TOKEN": _token},
          ));
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///获取群列表
  static Future<ApiResult> getGroupListData(
    int size,
    int page,
  ) async {
    Map<String, int> queryParam = {
      "size": size,
      "page": page,
    };
    init();
    try {
      Response response = await _dio.get("/groups/page",
          queryParameters: queryParam,
          options: Options(
            headers: {"BEE_TOKEN": _token},
          ));
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///创建群组
  static Future<ApiResult> createNewGroup(
    String groupName,
    String groupDescription,
    String groupIcon,
    String notes,
    List<dynamic> members,
  ) async {
    Map<String, dynamic> body = {
      "groupName": groupName,
      "groupDescription": groupDescription,
      "groupIcon": groupIcon,
      "notes": notes,
      "members": members,
    };
    init();
    try {
      Response response = await _dio.post("/groups/create",
          data: json.encode(body),
          options: Options(
            headers: {"BEE_TOKEN": _token},
          ));
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///获取单聊离线消息
  static Future<ApiResult> messageHistoryWithFriend(
      {String? friendID, int? page, int? size, int? currentMsgID}) async {
    init();
    Map<String, dynamic> queryParam = {
      "friendID": friendID,
      "page": page,
      "size": size,
      "currentMsgID": currentMsgID
    };
    try {
      if (currentMsgID == 0) queryParam.remove("currentMsgID");
      Response response = await _dio.get("/messages/chat/history",
          queryParameters: queryParam,
          options: Options(
            headers: {"BEE_TOKEN": _token},
          ));
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///更新个人资料
  static Future<ApiResult> updateProfileData(
    String keyName,
    String value,
  ) async {
    Map<String, String> body = {keyName: value};
    init();
    try {
      Response response = await _dio.post("/users/update", data: body);
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///获取群聊离线消息
  static Future<ApiResult> getGroupHistory(
      {String? groupID, int? page, int? size, int? currentMsgID}) async {
    init();
    Map<String, dynamic> queryParam = {
      "groupID": groupID,
      "page": page,
      "size": size,
      "currentMsgID": currentMsgID
    };
    try {
      if (currentMsgID == 0) queryParam.remove("currentMsgID");
      Response response = await _dio.get("/messages/groupchat/history",
          queryParameters: queryParam,
          options: Options(
            headers: {"BEE_TOKEN": _token},
          ));
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }

  ///获取SESSION
  static Future<ApiResult> querySession() async {
    init();
    try {
      Response response = await _dio.get("/sessions/list",
          queryParameters: {
            "page": 0,
          },
          options: Options(
            headers: {"BEE_TOKEN": _token},
          ));
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }
}

class ApiForFileService {
  static Dio _dio = Dio(BaseOptions(
    baseUrl: Flavors.apiInfo.File_UPLOAD_PATH,
    connectTimeout: Flavors.apiInfo.API_CONNECT_TIMEOUT,
    receiveTimeout: Flavors.apiInfo.API_RECEIVE_TIMEOUT,
    queryParameters: commonParamMap,
  )).initWrapper();

  static bool skipCheck = false;
  static String? _userInfoData;
  static String _token = '';
  static Map<String, dynamic> commonParamMap = DeviceInfo.info;

  static _checkToken() {
    _userInfoData = SP.getString(SPKey.userInfo);
    if (_userInfoData != null) {
      _token = jsonDecode(SP.getString(SPKey.userInfo))['token'];
    }
    return _token;
  }

  static init() {
    if (!skipCheck) {
      isNetworkConnect().then((value) {
        if (!value) {
          showToast('网络未连接，请检查网络设置');
        }
      });
    }
  }

  ///上传图片
  static Future<ApiResult> uploadFile(
      String filePath, ProgressCallback callback) async {
    init();
    var name =
        filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);

    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromFileSync(filePath, filename: name),
    });
    print(
        "DDAI name=$name; suffix=$suffix; filePath=$filePath; formData=$formData");
    print(
        "DDAI formData.files.first.value.length=${formData.files.first.value.length}");
    try {
      Response response = await _dio.post("/files/upload", data: formData,
          onSendProgress: (a, b) {
        print("send >>> $a/$b");
        callback(a, b);
      }, onReceiveProgress: (a, b) {
        print("receive <<< $a/$b");
      });

      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }
}
