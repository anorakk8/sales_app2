import 'dart:async';
import 'dart:io';

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
      saveLocationsToDevice();
    }
  }

  LocationSettings locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
      forceLocationManager: true,
      intervalDuration: const Duration(seconds: 10),
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

  recordLocation() async {
    await Geolocator.requestPermission();

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    locations.add([position.latitude, position.longitude]);

    timer = Timer.periodic(Duration(seconds: 10), (t) async {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      locations.add([position.latitude, position.longitude]);
      print(locations);
      locations.refresh();
    });
  }

  cancelTimer() {
    timer?.cancel();
  }

  saveLocationsToDevice() async {
    var text = flatten(locations);
    print(text.toString());
    await ExportFile().write(text.toString());
  }

  List<T> flatten<T>(List list) => [for (var sublist in list) ...sublist];
}
