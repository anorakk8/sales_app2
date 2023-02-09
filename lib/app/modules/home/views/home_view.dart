import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app_settings/app_settings.dart';
import 'package:get/get.dart';
import 'package:sales_app/app/modules/home/widgets/camera.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => print(AppSettings.openLocationSettings()),
              child: Text('Open Location Settings'),
            ),
            Obx(
              () => Column(children: [
                Text(
                    !controller.isShiftOn.value ? 'Start Shift' : 'Stop Shift'),
                CupertinoSwitch(
                    value: controller.isShiftOn.value,
                    onChanged: (value) {
                      controller.toggleShiftStatus(value);
                    }),
                SizedBox(
                  height: 20,
                ),
                Text('Recorded locations:'),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 400,
                  width: 200,
                  child: ListView.builder(
                      itemCount: controller.locations.length,
                      itemBuilder: (context, index) => SelectableText(
                          '${controller.locations[index][0]}, ${controller.locations[index][1]}')),
                )
              ]),
            ),

            // ElevatedButton(
            //   onPressed: () async {
            //     var location = await LocationHandler.getLocation();
            //     showDialog(
            //         context: context,
            //         builder: ((context) => SimpleDialog(
            //             title: Text(
            //                 'Lat: ${location[0]}\nLong: ${location[1]}'))));
            //   },
            //   child: Text('Display Location'),
            // ),
            ElevatedButton(
              onPressed: () async => {
                await availableCameras().then(
                  (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Camera(cameras: value))),
                )
              },
              child: Text('Take Photo'),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload Photo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  saveCurrentLocation() {}
}
