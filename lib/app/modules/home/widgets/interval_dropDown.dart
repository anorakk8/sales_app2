import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_app/app/modules/home/controllers/home_controller.dart';

class DropDownButtonLocationInterval extends StatelessWidget {
  const DropDownButtonLocationInterval({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Location Interval Time:'),
      SizedBox(
        width: 5,
      ),
      GetBuilder<HomeController>(
        builder: (controller) => SizedBox(
          width: 100,
          height: 40,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<LocationFetchInterval>(
              dropdownElevation: 2,
              buttonDecoration: BoxDecoration(
                  //   color: Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4)),
              buttonPadding: const EdgeInsets.all(5),
              itemPadding: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              underline: null,
              icon: Icon(
                Icons.arrow_drop_down,
              ),
              isExpanded: true,
              isDense: true,
              hint: const Text(
                "Select",
              ),
              value: controller.selectedLocationFetchInterval,
              selectedItemBuilder: (context) {
                return controller.locationFetchIntervals
                    .map<Widget>((LocationFetchInterval locationFetchInterval) {
                  return Text(locationFetchInterval.label);
                }).toList();
              },
              onChanged: (LocationFetchInterval? value) async {
                if (controller.isShiftOn.value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Can't change interval during shift!"),
                  ));
                } else {
                  controller.changeLocationFetchInterval(value!);
                }
              },
              items: controller.locationFetchIntervals
                  .map<DropdownMenuItem<LocationFetchInterval>>(
                      (LocationFetchInterval locationFetchInterval) {
                return DropdownMenuItem<LocationFetchInterval>(
                  enabled: true,
                  value: locationFetchInterval,
                  child: Center(
                    child: Text(
                      locationFetchInterval.label,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    ]);
  }
}
