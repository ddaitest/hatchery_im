import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'ApiResult.dart';
import 'package:hatchery_im/config.dart';

extension ExtendedDio on Dio {
  initWrapper() {
    InterceptorsWrapper wrapper =
        InterceptorsWrapper(onRequest: (options, handler) {
      print('HTTP.onRequest: ${options.uri} ');
      print('HTTP.onRequest: ${options.data} ');
      return handler.next(options); //continue
    }, onResponse: (response, handler) {
      print(
          'HTTP.onResponse: statusCode = ${response.statusCode} ;data = ${response.data} ');
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
    // headers: {"Authorization": Flavors.apiInfo.BASIC_AUTH},
    queryParameters: commonParam(),
  )).initWrapper();

  static bool skipCheck = false;

  static String clientId = Flavors.appId.client_id;

  static commonParam() {
    Map<String, dynamic> commonParamMap = DeviceInfo.info;
    // String? token = jsonDecode(SP.getString(SPKey.userInfo))['token'];
    // if (token != null) commonParamMap.putIfAbsent("token", () => token);
    return commonParamMap;
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
    Map<String, dynamic> body = {
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

  ///账号登录
  static Future<ApiResult> usersLogin(
    String loginName,
    String password,
  ) async {
    Map<String, dynamic> body = {
      "loginName": loginName,
      "password": password,
    };
    init();
    Response response =
        await _dio.post("/users/login", data: json.encode(body));
    return ApiResult.of(response.data);
  }

  ///上传图片
  static Future<ApiResult> uploadImage(
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
      Response response = await _dio.post("/resources/files/upload",
          data: formData, onSendProgress: (a, b) {
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
