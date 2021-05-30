import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'ApiResult.dart';

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
    queryParameters: commonParamMap,
  )).initWrapper();

  static bool skipCheck = false;

  static Map<String, dynamic> commonParamMap = DeviceInfo.info;

  static String clientId = Flavors.appId.client_id;

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
    try {
      Response response = await _dio.post("/users/login", data: body);
      return ApiResult.of(response.data);
    } catch (e) {
      print("e = $e");
      return ApiResult.error(e);
    }
  }
}
