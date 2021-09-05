import 'package:flutter/material.dart';
import 'package:hatchery_im/common/widget/app_bar.dart';
import 'package:hatchery_im/flavors/Flavors.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:hatchery_im/manager/map_manager/showMapManager.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../AppContext.dart';

class ShowMapPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShowMapPageState();
}

class _ShowMapPageState extends State<ShowMapPageBody> {
  final manager = App.manager<ShowMapManager>();

  void initState() {
    manager.init();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(body: _mainMapView());
  }

  Widget _mainMapView() {
    return Selector<ShowMapManager, LocationData?>(
      builder: (BuildContext context, LocationData? value, Widget? child) {
        return FlutterMap(
          options: MapOptions(
            center: value == null
                ? LatLng(39.90888114862166, 116.39738028474197)
                : LatLng(
                    value.longitude!.toDouble(), value.latitude!.toDouble()),
            zoom: 15.0,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 40.0,
                  height: 40.0,
                  point: value == null
                      ? LatLng(39.90888114862166, 116.39738028474197)
                      : LatLng(value.longitude!.toDouble(),
                          value.latitude!.toDouble()),
                  builder: (ctx) => Container(
                    child: FlutterLogo(),
                  ),
                ),
              ],
            ),
          ],
        );
      },
      selector: (BuildContext context, ShowMapManager showMapManager) {
        return showMapManager.locationData ?? null;
      },
      shouldRebuild: (pre, next) => (pre != next),
    );
  }
}
