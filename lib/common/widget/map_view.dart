import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/manager/map_manager/showMapManager.dart';
import 'package:flutter_map/flutter_map.dart';

import '../AppContext.dart';

class ShowMapPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShowMapPageState();
}

class _ShowMapPageState extends State<ShowMapPageBody> {
  List<Widget> _approvalNumberWidget = [];
  final manager = App.manager<ShowMapManager>();
  @override
  void initState() {
    manager.init();
    super.initState();
  }

  @override
  void dispose() {
    manager.stopLocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: AMapWidget(
        onMapCreated: manager.onMapCreated,
        myLocationStyleOptions: MyLocationStyleOptions(true,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            circleFillColor: Colors.transparent,
            circleStrokeColor: Colors.transparent),
      ),
    );
  }
}
