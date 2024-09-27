import 'package:converter_latlong/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: Text('Converter LatLong'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  controller.latitudeDD.value = value;
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  controller.longitudeDD.value = value;
                },
              ),
              SizedBox(height: 16.0),
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latitude (DMS): ${controller.latitudeDMS.value}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Longitude (DMS): ${controller.longitudeDMS.value}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )),
              SizedBox(height: 16.0),
              Obx(() => ElevatedButton.icon(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            controller.convertCoordinates();
                          },
                    icon: controller.isLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ))
                        : null, // The icon to display
                    label: Text('Convert Coords'), // The label of the button
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                    ),
                  )),
              SizedBox(height: 26.0),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppPages.SHOW_MAP);
                },
                child: Text('Show Map'),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
