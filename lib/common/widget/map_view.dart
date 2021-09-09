import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hatchery_im/manager/map_manager/showMapManager.dart';
import 'package:map_launcher/map_launcher.dart';
import '../AppContext.dart';
import '../utils.dart';

class ShowMapPageBody extends StatefulWidget {
  final MapOriginType mapOriginType;
  final LatLng? position;
  ShowMapPageBody({this.mapOriginType = MapOriginType.Send, this.position});
  @override
  State<StatefulWidget> createState() => _ShowMapPageState();
}

class _ShowMapPageState extends State<ShowMapPageBody> {
  final manager = App.manager<ShowMapManager>();
  final Map<String, Marker> _initMarkerMap = <String, Marker>{};
  void initState() {
    if (widget.position != null) {
      _setCustomMapPin();
      _checkLocalMapApp();
    }
    manager.init(widget.mapOriginType, widget.position);
    super.initState();
  }

  @override
  void dispose() {
    manager.stopLocation();
    super.dispose();
  }

  void _setCustomMapPin() async {
    Marker marker = Marker(
        position: widget.position!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
    _initMarkerMap[marker.id] = marker;
  }

  void _checkLocalMapApp() async {
    final availableMaps = await MapLauncher.installedMaps;
    print("DEBUG=> availableMaps $availableMaps");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: Flavors.sizesInfo.screenHeight,
            width: Flavors.sizesInfo.screenWidth,
            child: _mapViewContainer()));
  }

  Widget _mapViewContainer() {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        AMapWidget(
          onMapCreated: manager.onMapCreated,
          myLocationStyleOptions: MyLocationStyleOptions(true,
              circleFillColor: Colors.transparent,
              circleStrokeColor: Colors.transparent),
          markers: Set<Marker>.of(_initMarkerMap.values),
        ),
        Builder(
          builder: (context) => GestureDetector(
            onTap: () => Navigator.of(App.navState.currentContext!).pop(true),
            child: Container(
                width: 40.0.w,
                height: 40.0.h,
                margin: const EdgeInsets.only(left: 20.0, top: 60.0),
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular((6.0)), // 圆角度
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x33000000),
                          offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                          blurRadius: 3.0, //阴影模糊程度
                          spreadRadius: 0.0 //阴影扩散程度
                          )
                    ]),
                child: Icon(Icons.arrow_back, size: 25.0, color: Colors.black)),
          ),
        ),
        Positioned(
          right: 20.0,
          top: 60.0,
          child: Container(
            height: 40.0.h,
            child: TextButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                primary: Flavors.colorInfo.mainColor,
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: Text(
                widget.mapOriginType == MapOriginType.Send ? '发送' : '导航',
                textAlign: TextAlign.center,
                style: Flavors.textStyles.chatHomeSlideText,
              ),
            ),
          ),
        ),
        Positioned(
          right: 20.0,
          bottom: 60.0,
          child: GestureDetector(
            onTap: () async => manager.locationResult != null
                ? manager.moveCameraMethod(LatLng(
                    manager.locationResult!['latitude'] as double,
                    manager.locationResult!['longitude'] as double))
                : showToast('没有获取到当前位置'),
            child: Container(
              child: Image.asset('images/my_locate.png'),
            ),
          ),
        ),
      ],
    );
  }
}
