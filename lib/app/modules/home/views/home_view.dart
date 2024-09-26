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
                decoration:
                    InputDecoration(labelText: 'Latitude (Decimal Degrees)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  controller.latitudeDD.value = value;
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration:
                    InputDecoration(labelText: 'Longitude (Decimal Degrees)'),
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
              ElevatedButton(
                onPressed: () {
                  controller.convertCoordinates();
                },
                child: Text('Convert Coords'),
              ),
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
