import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:sales_app/app/modules/home/controllers/home_controller.dart';

class CustomMap extends StatelessWidget {
  CustomMap({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController _controller = Get.put(HomeController());

    return GetBuilder<HomeController>(
      builder: (_) => FlutterMap(
        mapController: _controller.mapController,
        options: MapOptions(
          center: latLng.LatLng(12.9716, 77.5946),
          maxBounds: LatLngBounds(
            latLng.LatLng(-90, -180.0),
            latLng.LatLng(90.0, 180.0),
          ),
        ),
        nonRotatedChildren: [],
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'dev.anorakk.app',
          ),
          MarkerLayer(
            markers: _controller.getMapMarkers(),
          ),
          PolylineLayer(
            polylines: _controller.getPolyLines(),
          )
        ],
      ),
    );
  }
}
