import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:hatchery_im/api/API.dart';
import 'package:hatchery_im/api/ApiResult.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/config.dart';
import 'package:hatchery_im/api/entity.dart';
import 'package:hatchery_im/common/tools.dart';
import 'package:hatchery_im/routers.dart';
import 'package:hatchery_im/common/AppContext.dart';
import 'package:hatchery_im/common/utils.dart';
import 'package:hatchery_im/manager/userCentre.dart';
import 'package:location/location.dart';

class ShowMapManager extends ChangeNotifier {
  Location location = Location();
  LocationData? locationData;

  /// 初始化
  init() {
    print("DEBUG=> locationData $locationData");
    buildLocation();
  }

  Future<dynamic> buildLocation() async {
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    locationData = await location.getLocation();
    print(
        "DEBUG=> locationData ${locationData!.longitude} ${locationData!.latitude}");
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
