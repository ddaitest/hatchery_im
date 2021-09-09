import 'dart:async';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';

class ShowMapManager extends ChangeNotifier {
  final _locationPlugin = AMapFlutterLocation();
  late AMapController _aMapController;
  Map<String, Object>? locationResult;
  StreamSubscription<Map<String, Object>>? _locationListener;

  /// 初始化
  init() {
    _buildLocation();
    _locationListen();
  }

  Future<dynamic> _buildLocation() async {
    _requestPermission().then((bool hasLocationPermission) {
      if (hasLocationPermission) {
        _startLocation();
      }
    });
  }

  /// 动态申请定位权限
  Future<bool> _requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await _requestLocationPermission();
    if (hasLocationPermission) {
      return true;
    } else {
      showToast("没有获取到定位权限");
      return false;
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> _requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  ///开始定位
  void _startLocation() {
    ///开始定位之前设置定位参数
    _setLocationOption();
    _locationPlugin.startLocation();
  }

  ///停止定位
  void stopLocation() {
    ///销毁定位
    _locationListener?.cancel();
    _locationPlugin.destroy();
  }

  void _locationListen() {
    ///注册定位结果监听
    _locationListener = _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      locationResult = result;
      moveCameraMethod(locationResult!['latitude'] as double,
          locationResult!['longitude'] as double);
      print("DEBUG=> locationResult $locationResult");
    });
  }

  ///设置定位参数
  void _setLocationOption() {
    AMapLocationOption locationOption = AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = true;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;

    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 2000;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  void onMapCreated(AMapController controller) {
    _aMapController = controller;
  }

  void moveCameraMethod(double latitude, double longitude,
      {double zoomLevel = 15.0}) {
    _aMapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: zoomLevel)));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
