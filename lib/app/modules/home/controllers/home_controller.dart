import 'dart:async';
import 'dart:io';

import 'package:latlong2/latlong.dart' as latLng;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sales_app/app/modules/home/widgets/exportFile.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  RxBool isShiftOn = false.obs;

  toggleShiftStatus(bool value) {
    isShiftOn.value = value;
    if (value) {
      locations.clear();
      recordLocation();
    } else {
      cancelTimer();
    }
  }

  LocationSettings locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
      forceLocationManager: true,
      intervalDuration: const Duration(minutes: 2),
      //(Optional) Set foreground notification config to keep the app alive
      //when going to the background
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationText:
            "Sales App will continue to receive your location even when you aren't using it",
        notificationTitle: "Running in Background",
        enableWakeLock: true,
      ));

  late Position position;

  Timer? timer;

  RxList locations = [].obs;

  late var testLocations = [
    [12.972890, 77.597628],
    [13.001661, 77.598315],
    [13.005340, 77.584917],
    [13.011027, 77.563617],
    [13.009689, 77.542661],
    [12.995974, 77.508306]
  ];

  recordLocation() async {
    await Geolocator.requestPermission();

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    locations.add([position.latitude, position.longitude]);

    int j = 0;

    timer = Timer.periodic(selectedLocationFetchInterval.duration, (t) async {
      position = await Geolocator.getCurrentPosition(
          forceAndroidLocationManager: true,
          desiredAccuracy: LocationAccuracy.best);

      // locations.add(testLocations[j]);
      // j++;

      locations.add([position.latitude, position.longitude]);

      print(locations);
      locations.refresh();
      update();
    });
  }

  cancelTimer() {
    timer?.cancel();
  }

  //-------------------------- FETCH LOCATION INTERVAL------------------

  late LocationFetchInterval selectedLocationFetchInterval =
      locationFetchIntervals[0];

  List<LocationFetchInterval> locationFetchIntervals = [
    LocationFetchInterval('10s', Duration(seconds: 10)),
    LocationFetchInterval('2m', Duration(minutes: 2)),
    LocationFetchInterval('10m', Duration(minutes: 10)),
  ];

  changeLocationFetchInterval(LocationFetchInterval option) {
    selectedLocationFetchInterval = option;
    update();
  }

//-----------------------------------MAP WIDGET:

  // var mapCenterInital = latLng.LatLng(12.9716, 77.5946);

  final mapController = MapController();

  getMapMarkers() {
    List<Marker> markers = [];

    if (locations.isEmpty) {
      return <Marker>[];
    } else {
      for (var location in locations) {
        markers.add(
          Marker(
              point: latLng.LatLng(location[0], location[1]),
              width: 100,
              height: 100,
              builder: (context) => Icon(
                    Icons.location_on,
                    color: Colors.red,
                  )),
        );
      }

      var latestPosition = latLng.LatLng(locations.last[0], locations.last[1]);

      mapController.move(latestPosition, 15);

      return markers;
    }
  }

  getPolyLines() {
    List<latLng.LatLng> polyLinePoints = [];

    if (locations.isEmpty) {
      return [Polyline(points: [])];
    } else {
      for (var location in locations) {
        polyLinePoints.add(latLng.LatLng(location[0], location[1]));
      }

      return [
        Polyline(
          strokeWidth: 2,
          points: polyLinePoints,
          color: Colors.blue,
        )
      ];
    }
  }
}

class LocationFetchInterval {
  String label;
  Duration duration;

  LocationFetchInterval(this.label, this.duration);
}
